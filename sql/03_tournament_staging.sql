CREATE OR REPLACE VIEW tourney_results_team AS

WITH team_seasons AS (
    SELECT DISTINCT season, team
    FROM regular_detailed_results_team
),

tourney_games AS (
    SELECT
        "Season" AS season,
        "WTeamID" AS team,
        1 AS team1win
    FROM public.tourney_compact_results
    UNION ALL
    SELECT
        "Season" AS season,
        "LTeamID" AS team,
        0 AS team1win
    FROM public.tourney_compact_results
), 

history AS (
    SELECT
        b.season,
        b.team,
        AVG(g.team1win) AS winperc_last_4,
        COUNT(g.team1win) AS tourney_games_last_4
    FROM team_seasons b
    LEFT JOIN tourney_games g
        ON g.team = b.team
        AND g.season BETWEEN b.season -4 AND b.season -1 
        --tournament performance in last 4 seasons
    GROUP BY b.season, b.team
),

seeds AS (
    SELECT
        "Season" AS season,
        "TeamID" AS team,
        SUBSTRING("Seed", 2, 2)::int AS seed
    FROM public.tourney_seeds
)

SELECT 
    h.season,
    h.team,
    h.winperc_last_4,
    h.tourney_games_last_4,
    s.seed
FROM history h
LEFT JOIN seeds s
    ON h.season = s.season
    AND h.team = s.team
-- LIMIT 5
;