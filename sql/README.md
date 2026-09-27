# NCAA March Madness 2026: PostgreSQL feature pipeline

This side project rebuilds the data preparation in the existing March Madness notebooks as PostgreSQL views. It prepares team-season features and labeled or requested team matchups; it does not replace the previously run modeling notebooks or their recorded results. The companion `00_import_csv_to_postgresql.ipynb` imports source CSV files before the SQL views are created.

## Data flow

| Script | Output schema | Purpose |
| --- | --- | --- |
| `01_create_combined_views.sql` | `public` | Combine men's and women's source tables; combine submission stages. |
| `02_team_game_staging.sql` | `staging` | Convert detailed regular-season results to one row per team per game and attach conference. |
| `03_tournament_staging.sql` | `staging` | Calculate each team's tournament wins and games over the prior four seasons; attach the current season's seed. |
| `04_team_season_metrics.sql` | `analytics` | Aggregate regular-season box-score, close-game, and overtime metrics at team-season grain; standardize across teams within season. |
| `05_team_season_momentum.sql` | `analytics` | Calculate wins through and after Day 100, conference ranks and categories, and season-standardized momentum. |
| `06_final_features.sql` | `analytics` | Join team-season metrics, momentum, four-season history, seeds, and conference strength. |
| `07_games_to_predict.sql` | `analytics` | Split submission IDs into season and the two team IDs. |
| `08_dyad_features.sql` | `analytics` | Create labeled 2022–2025 regular-season and tournament game rows with team A minus team B features. |
| `09_prediction_dyads.sql` | `analytics` | Create feature differences for the requested 2026 matchups, keyed by submission ID. |

The SQL view names are `staging.regular_detailed_results_team`, `staging.tourney_results_team`, `analytics.team_season_metrics`, `analytics.team_season_momentum`, `analytics.final_features`, `analytics.games_to_predict`, `analytics.dyad_training`, and `analytics.dyad_predictions_2026`. Script 01 creates the combined views in `public`.

## Running the pipeline

1. Place the raw men's and women's NCAA files, submission stages, and conference-ranking CSVs in the repository's `data/raw/` directory. Install pandas, SQLAlchemy, and psycopg2 in your Python environment. Set `PGUSER`, `PGPASSWORD`, `PGHOST`, `PGPORT`, and optionally `PGDATABASE` for your PostgreSQL instance. Run `00_import_csv_to_postgresql.ipynb` from the repository root or `notebooks/` working directory; it creates the database if needed and imports each CSV as a `public` table, skipping tables that already exist. The account needs permission to create a database if one does not exist. Check that every required table was imported before running the SQL scripts. Raw CSVs and credentials should remain outside version control.
2. Create the `staging` and `analytics` schemas if they do not exist: `CREATE SCHEMA IF NOT EXISTS staging; CREATE SCHEMA IF NOT EXISTS analytics;`.
3. Run scripts 01 through 09 in numerical order, stopping at the first error. These scripts use unqualified `CREATE VIEW` names, so set the session `search_path` **before each script**: `public` for 01; `staging, public` for 02–03; and `analytics, staging, public` for 04–09. In pgAdmin, set the path and execute the file in the same query session. No separate databases are needed.

For example, script 06 can be run in a `psql` session with:

```sql
SET search_path TO analytics, staging, public;
\i 06_final_features.sql
```

The run needs a database containing the raw source tables and the two schemas. Scripts 08 and 09 deliberately fix training at 2022–2025 and prediction at 2026; update those filters for a later tournament cycle.

## Feature definitions and modeling boundary

- `analytics.final_features` has one row per `season, team` from 2022 onward. Team-game staging uses one row per team per played regular-season game. Season z-scores are computed from **team-season averages**, so teams with more games do not receive more weight in the standardization.
- `winperc_last_4` equals tournament wins divided by tournament games over seasons `Y-4` through `Y-1` for a team-season in year `Y`; `tourney_games_last_4` is that denominator. The win percentage remains null when there are no prior games. Current-season tournament results are never used in this feature.
- `seed_strength` is `17 - seed` when a current-season seed exists and `0` otherwise. Thus an unseeded team cannot receive strength 17, while seeded 2026 teams retain their known seeds even without 2026 tournament results.
- Conference strength reverses the conference ranking within each season and men's/women's division. `M_W` is derived from the team ID range used by the source data.
- In dyads, `team_a` is the lower-ID team, and `team_a_win` marks whether it won. Numeric difference features are team A minus team B. For dyad calculations, null historical tournament win percentages and undefined clutch, grit, or post-Day-100 z-scores are replaced with zero **per team before subtraction**; source feature nulls remain intact. The history game-count difference helps distinguish missing history from an observed zero win rate.
- `analytics.dyad_training` contains **both** regular-season and tournament game labels from 2022–2025, reflecting the previously run notebook's design. Its regular-season rows have a known limitation: their full-season team features include the game whose outcome is being predicted, and may include later games. This can make training and validation performance optimistic. The SQL conversion records this issue; it does not claim to resolve it. Use season-held-out evaluation and a pregame feature pipeline before treating those rows as leakage-free predictive training data.

Other intentional differences from the pandas implementation include removing a many-to-many merge that duplicated regular-season games in the notebook's momentum path, ranking teams within conferences with ties and conference-relative top/middle/bottom groups, and using the same four-season history definition for training and 2026 features. Exact equality to the earlier notebook output is therefore not a validation target.

## Validation performed

The views were rebuilt in script order after clearing the earlier derived views. The resulting `analytics.final_features` contained **3,614 rows and 3,614 distinct `(season, team)` keys** for 2022–2026; conference strength was present for all rows, and each season had 136 seeded teams with seed strengths from 0 to 16. Manual checks against tournament game records matched four-season win rates and counts for examples in 2022 and 2026.

`analytics.dyad_training` contained **43,487 regular-season games and 536 tournament games** from 2022–2025. Game keys were unique and both teams matched feature rows. The 2026 submission contained **132,133 unique requested matchups**; all had feature rows for both teams. The prediction dyad view returned the expected row and ID counts with no null output columns. These checks validate coverage and selected calculations, not predictive model performance.

The previously run notebooks remain the historical record of the original project. Integrating PostgreSQL outputs into later models is a future iteration.
