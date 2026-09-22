# Processed Data

This directory contains datasets generated during the project's ETL and feature-engineering workflow.

These files are not included in the GitHub repository. They are generated locally by the notebooks from the raw NCAA/Kaggle and BartTorvik data.

## Key Processed Datasets

The notebook workflow generates intermediate datasets including:

- `df_full.csv` — consolidated team-level dataset created during ETL.
- `games_to_predict.csv` — prediction matchup dataset created during ETL.
- `team_a_2026.csv` — generated 2026 team data used in the matchup workflow.
- `team_b_2026.csv` — generated 2026 team data used in the matchup workflow.
- `dyad_matchups.csv` — matchup-level dataset created from tournament and regular-season results.
- `team_a_stats.csv` — team statistics for the first team in each matchup.
- `team_b_stats.csv` — team statistics for the second team in each matchup.
- `pruned_importance.csv` — intermediate feature-importance output from the feature-selection workflow.
- `2026_full_prediction.csv` — intermediate 2026 prediction dataset used by downstream modeling.

## Workflow

The primary processing sequence is:

```text
Raw Data
   ↓
01_ETL.ipynb
   ↓
df_full.csv
games_to_predict.csv
   ↓
03_Dyad_Merges.ipynb
   ↓
team_a_2026.csv
team_b_2026.csv
dyad_matchups.csv
team_a_stats.csv
team_b_stats.csv
   ↓
04_All_Variables.ipynb
05_Feature_Selection_Model.ipynb
06_XGBoost_Model.ipynb
07_Ensemble_Model.ipynb

## Repository Policy

Processed datasets are excluded from GitHub because they are derived from external source data and can be regenerated locally.

The .gitignore file prevents files placed in this directory from being committed to the repository.