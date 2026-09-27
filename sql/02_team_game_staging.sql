CREATE OR REPLACE VIEW regular_detailed_results_team AS

WITH rdr_supp_metrics AS (
    SELECT *,
        ("WFGM" + (0.5*"WFGM3")) / "WFGA" AS "WEFG",
        ("LFGM" + (0.5*"LFGM3")) / "LFGA" AS "LEFG",
        "WFGA" + "WFGA3" AS "WSA",
        "LFGA" + "LFGA3" AS "LSA",
        "WScore" - "LScore" AS "Wptdiff",
        "LScore" - "WScore" AS "Lptdiff"
    FROM public.regular_detailed_results
--    LIMIT 2
),

team_level AS (
    SELECT
        "WTeamID" AS team,
        "Season" AS season,
        "DayNum" AS day_num,
        "NumOT" AS num_ot,
        "WEFG" AS efg,
        "WSA" AS sa,
        "WScore" AS score,
        "Wptdiff" AS pt,
        "WAst" AS ast,
        "WTO" AS to,
        "WStl" AS stl,
        "WBlk" AS blk,
        "WOR" AS or,
        "WDR" AS dr,
        "WFGM3" AS fgm3,
        "WFGA3" AS fga3
    FROM rdr_supp_metrics
    UNION ALL
    SELECT
        "LTeamID" AS team,
        "Season" AS season,
        "DayNum" AS day_num,
        "NumOT" AS num_ot,
        "LEFG" AS efg,
        "LSA" AS sa,
        "LScore" AS score,
        "Lptdiff" AS pt,
        "LAst" AS ast,
        "LTO" AS to,
        "LStl" AS stl,
        "LBlk" AS blk,
        "LOR" AS or,
        "LDR" AS dr,
        "LFGM3" AS fgm3,
        "LFGA3" AS fga3
    FROM rdr_supp_metrics
--    LIMIT 5
)

SELECT 
    t.*,
    c."ConfAbbrev" AS conf
FROM team_level t
JOIN public.team_conf c
    ON t.team = c."TeamID"
    AND t.season = c."Season"
-- LIMIT 5
;