CREATE OR REPLACE VIEW team_season_metrics AS

WITH games_calcs AS (
    SELECT
        *,
        CASE WHEN pt > 0 THEN 1 ELSE 0 END AS team1win,
        CASE WHEN pt BETWEEN -5 AND 5 THEN 1 ELSE 0 END AS close,
        CASE WHEN num_ot > 0 THEN 1 ELSE 0 END AS ot
    FROM staging.regular_detailed_results_team
),

team_calcs AS (
    SELECT
        season,
        team,
        conf,
        AVG(efg) AS team_avg_efg,
        AVG(sa) AS team_avg_sa,
        AVG(pt) AS team_avg_pt,
        AVG(ast) AS team_avg_ast,
        AVG("to") AS team_avg_to,
        AVG(stl) AS team_avg_stl,
        AVG(blk) AS team_avg_blk,
        AVG("or") AS team_avg_or,
        AVG(dr) AS team_avg_dr,
        AVG(fgm3) AS team_avg_fgm3,
        AVG(fga3) AS team_avg_fga3,
        AVG(score) AS team_avg_off,
        AVG(score - pt) AS team_avg_def,

        AVG(team1win) FILTER(WHERE close = 1) AS team_avg_clutch,
        AVG(close) AS team_avg_close,

        AVG(team1win) FILTER(WHERE ot = 1) AS team_avg_grit,
        AVG(ot) AS team_avg_ot
    FROM games_calcs
    GROUP BY season, conf, team
),

season_calcs AS (
    SELECT
        season,
        
        AVG(team_avg_efg) AS season_avg_efg,
        STDDEV(team_avg_efg) AS season_std_efg,

        AVG(team_avg_sa) AS season_avg_sa,
        STDDEV(team_avg_sa) AS season_std_sa,
        
        AVG(team_avg_pt) AS season_avg_pt,
        STDDEV(team_avg_pt) AS season_std_pt,

        AVG(team_avg_ast) AS season_avg_ast,
        STDDEV(team_avg_ast) AS season_std_ast,

        AVG(team_avg_to) AS season_avg_to,
        STDDEV(team_avg_to) AS season_std_to,

        AVG(team_avg_stl) AS season_avg_stl,
        STDDEV(team_avg_stl) AS season_std_stl,

        AVG(team_avg_blk) AS season_avg_blk,
        STDDEV(team_avg_blk) AS season_std_blk,

        AVG(team_avg_or) AS season_avg_or,
        STDDEV(team_avg_or) AS season_std_or,

        AVG(team_avg_dr) AS season_avg_dr,
        STDDEV(team_avg_dr) AS season_std_dr,

        AVG(team_avg_fgm3) AS season_avg_fgm3,
        STDDEV(team_avg_fgm3) AS season_std_fgm3,

        AVG(team_avg_fga3) AS season_avg_fga3,
        STDDEV(team_avg_fga3) AS season_std_fga3,

        AVG(team_avg_off) AS season_avg_off,
        STDDEV(team_avg_off) AS season_std_off,

        AVG(team_avg_def) AS season_avg_def,
        STDDEV(team_avg_def) AS season_std_def,
        
        AVG(team_avg_clutch) AS season_avg_clutch,
        STDDEV(team_avg_clutch) AS season_std_clutch,

        AVG(team_avg_close) AS season_avg_close,
        STDDEV(team_avg_close) AS season_std_close,
        
        AVG(team_avg_grit) AS season_avg_grit,
        STDDEV(team_avg_grit) AS season_std_grit,

        AVG(team_avg_ot) AS season_avg_ot,
        STDDEV(team_avg_ot) AS season_std_ot
    FROM team_calcs
    GROUP BY season
)

SELECT
    t.season,
    t.team,
    t.conf,
    (t.team_avg_efg - s.season_avg_efg) / s.season_std_efg AS "z.efg",
    (t.team_avg_sa - s.season_avg_sa) / s.season_std_sa AS "z.sa",
    (t.team_avg_pt - s.season_avg_pt) / s.season_std_pt AS "z.pt",
    (t.team_avg_ast - s.season_avg_ast) / s.season_std_ast AS "z.ast",
    (t.team_avg_to - s.season_avg_to) / s.season_std_to AS "z.to",
    (t.team_avg_stl - s.season_avg_stl) / s.season_std_stl AS "z.stl",
    (t.team_avg_blk - s.season_avg_blk) / s.season_std_blk AS "z.blk",
    (t.team_avg_or - s.season_avg_or) / s.season_std_or AS "z.or",
    (t.team_avg_dr - s.season_avg_dr) / s.season_std_dr AS "z.dr",
    (t.team_avg_fgm3 - s.season_avg_fgm3) / s.season_std_fgm3 AS "z.3m",
    (t.team_avg_fga3 - s.season_avg_fga3) / s.season_std_fga3 AS "z.3a",
    (t.team_avg_off - s.season_avg_off) / s.season_std_off AS "z.off",
    (t.team_avg_def - s.season_avg_def) / s.season_std_def AS "z.def",
    (t.team_avg_clutch - s.season_avg_clutch) / s.season_std_clutch AS "z.clutch",
    (t.team_avg_close - s.season_avg_close) / s.season_std_close AS "z.close",
    (t.team_avg_grit - s.season_avg_grit) / s.season_std_grit AS "z.grit",
    (t.team_avg_ot - s.season_avg_ot) / s.season_std_ot AS "z.ot"
FROM team_calcs t 
JOIN season_calcs s
    ON t.season = s.season
ORDER BY t.team ASC
;