CREATE OR REPLACE VIEW dyad_predictions_2026 AS

SELECT
    g.id,
    g.season,
    g.team1 AS team_a,
    g.team2 AS team_b,

    a.top AS top_a,
    a.mid AS mid_a,
    a.bot AS bot_a,
    b.top AS top_b,
    b.mid AS mid_b,
    b.bot AS bot_b,

    a."z.efg" - b."z.efg" AS efg_diff,
    a."z.sa" - b."z.sa" AS sa_diff,
    a."z.pt" - b."z.pt" AS pt_diff,
    a.rank_in_conf - b.rank_in_conf AS rank_diff,
    a."z.winsbefore" - b."z.winsbefore" AS winsbefore_diff,
    COALESCE(a."z.winsafter", 0)
        - COALESCE(b."z.winsafter", 0) AS winsafter_diff,
    COALESCE(a."z.clutch", 0)
        - COALESCE(b."z.clutch", 0) AS clutch_diff,
    a."z.close" - b."z.close" AS close_diff,
    COALESCE(a."z.grit", 0)
        - COALESCE(b."z.grit", 0) AS grit_diff,
    a."z.ot" - b."z.ot" AS ot_diff,
    a."z.off" - b."z.off" AS off_diff,
    a."z.def" - b."z.def" AS def_diff,
    a."z.ast" - b."z.ast" AS ast_diff,
    a."z.to" - b."z.to" AS to_diff,
    a."z.stl" - b."z.stl" AS stl_diff,
    a."z.blk" - b."z.blk" AS blk_diff,
    a."z.or" - b."z.or" AS or_diff,
    a."z.dr" - b."z.dr" AS dr_diff,
    a."z.3m" - b."z.3m" AS "3m_diff",
    a."z.3a" - b."z.3a" AS "3a_diff",

    COALESCE(a.winperc_last_4, 0)
        - COALESCE(b.winperc_last_4, 0) AS winperc_last_4_diff,
    a.tourney_games_last_4
        - b.tourney_games_last_4 AS tourney_games_last_4_diff,
    a.seed_strength - b.seed_strength AS seed_diff,
    a.conf_strength - b.conf_strength AS conf_diff

FROM analytics.games_to_predict g
JOIN analytics.final_features a
    ON g.season = a.season AND g.team1 = a.team
JOIN analytics.final_features b
    ON g.season = b.season AND g.team2 = b.team
WHERE g.season = 2026;