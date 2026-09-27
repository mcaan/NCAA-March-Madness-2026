CREATE OR REPLACE VIEW team_season_momentum AS

WITH winsbefore AS (
    SELECT 
        team,
        season,
        conf,
        AVG(CASE WHEN pt > 0 THEN 1 ELSE 0 END) AS team_avg_winsbefore
    FROM staging.regular_detailed_results_team
    WHERE day_num <= 100
    GROUP BY team, season, conf
    -- LIMIT 10
),

ranked_before_d100 AS (
    SELECT
        *,
        RANK() OVER(
            PARTITION BY season, conf
            ORDER BY team_avg_winsbefore DESC
        ) AS rank_in_conf,
        RANK() OVER(
            PARTITION BY season, conf
            ORDER BY team_avg_winsbefore ASC
        ) AS rank_from_bottom,
        COUNT(*) OVER (
            PARTITION BY season, conf
        ) AS teams_in_conf
    FROM winsbefore
    -- LIMIT 10
),

rank_categories AS (
    SELECT
        *,
        CASE WHEN rank_in_conf <= CEIL(teams_in_conf * 0.20) THEN 1 ELSE 0 END AS top,
        CASE WHEN rank_from_bottom <= CEIL(teams_in_conf * 0.20) THEN 1 ELSE 0 END AS bot,
        CASE
            WHEN rank_in_conf > CEIL(teams_in_conf * 0.20)
            AND rank_from_bottom > CEIL(teams_in_conf * 0.20)
            THEN 1 ELSE 0
        END AS mid
    FROM ranked_before_d100
    -- LIMIT 10
),

winsafter AS (
    SELECT 
        team,
        season,
        conf,
        AVG(CASE WHEN pt > 0 THEN 1 ELSE 0 END) AS team_avg_winsafter
    FROM staging.regular_detailed_results_team
    WHERE day_num > 100
    GROUP BY team, season, conf
    -- LIMIT 10
),

team_calcs AS (
    SELECT 
        r.*, 
        w.team_avg_winsafter
    FROM rank_categories r
    LEFT JOIN winsafter w
        ON r.team = w.team
        AND r.season = w.season
        AND r.conf = w.conf
),

season_calcs AS (
    SELECT
        season,
        
        AVG(team_avg_winsbefore) AS season_avg_winsbefore,
        STDDEV(team_avg_winsbefore) AS season_std_winsbefore,

        AVG(team_avg_winsafter) AS season_avg_winsafter,
        STDDEV(team_avg_winsafter) AS season_std_winsafter
    FROM team_calcs
    GROUP BY season
),

momentum_final AS (
    SELECT
        t.season,
        t.team,
        t.conf,
        t.rank_in_conf,
        t.top,
        t.mid,
        t.bot,
        (t.team_avg_winsbefore - s.season_avg_winsbefore) / s.season_std_winsbefore AS "z.winsbefore",
        (t.team_avg_winsafter - s.season_avg_winsafter) / s.season_std_winsafter AS "z.winsafter"
    FROM team_calcs t 
    JOIN season_calcs s
        ON t.season = s.season
    ORDER BY t.team ASC
    -- LIMIT 10
)

SELECT *
FROM momentum_final
;
