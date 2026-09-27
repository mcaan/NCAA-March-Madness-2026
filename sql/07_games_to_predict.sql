CREATE OR REPLACE VIEW games_to_predict AS

SELECT
    "ID" as id,
    SPLIT_PART("ID", '_', 1)::int AS season,
    SPLIT_PART("ID", '_', 2)::int AS team1,
    SPLIT_PART("ID", '_', 3)::int AS team2
FROM public.sample_submission
;