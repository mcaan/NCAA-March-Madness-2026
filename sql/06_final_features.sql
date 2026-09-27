CREATE OR REPLACE VIEW final_features AS 

WITH conf_strength AS (
    SELECT
        season,
        conf,
        "M_W",
        MAX("Rank") OVER(
            PARTITION BY season, "M_W"
        ) + 1 - "Rank" AS conf_strength
    FROM public.conf_rank --data only exists from 2022 onward
)

SELECT 
    s.*,
    m.rank_in_conf,
    m.top,
    m.mid,
    m.bot,
    m."z.winsbefore",
    m."z.winsafter",
    t.winperc_last_4,
    t.tourney_games_last_4,
    CASE WHEN t.seed IS NOT NULL THEN 17-t.seed ELSE 0 END 
        AS seed_strength,
    CASE WHEN s.team >= 1000 AND s.team < 3000 THEN 'M' ELSE 'W' END
        AS "M_W",
    c.conf_strength
FROM team_season_metrics s 
LEFT JOIN team_season_momentum m 
    ON s.season = m.season AND s.team = m.team AND s.conf = m.conf
LEFT JOIN staging.tourney_results_team t
    ON s.season = t.season AND s.team = t.team
LEFT JOIN conf_strength c
    ON s.season = c.season
    AND s.conf = c.conf
    AND (CASE WHEN s.team >= 1000 AND s.team < 3000
            THEN 'M' ELSE 'W' END) = c."M_W"
WHERE s.season >= 2022
;
