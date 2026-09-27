CREATE OR REPLACE VIEW tourney_compact_results AS
    SELECT *
    FROM m_ncaa_tourney_compact_results
    UNION ALL
    SELECT *
    FROM w_ncaa_tourney_compact_results
;

CREATE OR REPLACE VIEW tourney_seeds AS
    SELECT *
    FROM m_ncaa_tourney_seeds
    UNION ALL
    SELECT *
    FROM w_ncaa_tourney_seeds
;

CREATE OR REPLACE VIEW teams AS
    SELECT "TeamID", "TeamName"
    FROM m_teams
    UNION ALL
    SELECT "TeamID", "TeamName"
    FROM w_teams
;

CREATE OR REPLACE VIEW team_conf AS
    SELECT *
    FROM m_team_conferences
    UNION ALL
    SELECT *
    FROM w_team_conferences
;

CREATE OR REPLACE VIEW regular_detailed_results AS
    SELECT *
    FROM m_regular_season_detailed_results
    UNION ALL
    SELECT *
    FROM w_regular_season_detailed_results
;

CREATE OR REPLACE VIEW sample_submission AS
    SELECT *
    FROM sample_submission_stage1
    UNION -- drop duplicates
    SELECT *
    FROM sample_submission_stage2
;

CREATE OR REPLACE VIEW regular_compact_results AS
    SELECT *
    FROM m_regular_season_compact_results
    UNION ALL
    SELECT *
    FROM w_regular_season_compact_results
;

CREATE OR REPLACE VIEW conf_rank AS
    SELECT *
    FROM m_conference_rankings_barttorvik_com
    UNION ALL
    SELECT *
    FROM w_conference_rankings_barttorvik_com
;

