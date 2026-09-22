# Data

This project uses external NCAA March Madness competition data supplemented by conference rankings from BartTorvik.

## Data Sources

### NCAA March Madness

The primary data source is the NCAA March Madness competition data obtained through Kaggle.

The project uses both men's and women's data, including tournament results, regular-season results, team information, tournament seeds, tournament slots, seasons, and team conference information.

The raw source files are not included in this repository.

See [`raw/README.md`](raw/README.md) for data acquisition and local setup instructions.

### BartTorvik

Conference rankings from [BartTorvik](https://barttorvik.com/) are used as supplemental data.

These source files are also excluded from the repository.

See [`raw/README.md`](raw/README.md) for additional information.

## Data Workflow

The notebooks are intended to be run in numerical order, with generated intermediate datasets stored in `data/processed/` and consumed by downstream notebooks as needed.

```text
External Source Data
        │
        ▼
    data/raw/
        │
        ▼
   01_ETL.ipynb
        │
        ├────► 02_EDA.ipynb
        │
        ▼
   03_Dyad_Merges.ipynb
        │
        ▼
   04_All_Variables.ipynb
        │
        ▼
05_Feature_Selection_Model.ipynb
        │
        ▼
06_XGBoost_Model.ipynb
        │
        ▼
07_Ensemble_Model.ipynb

Intermediate datasets generated and consumed throughout this
workflow are stored locally in `data/processed/`.

## Repository Policy

Raw and processed datasets are excluded from GitHub.

The repository contains the notebooks and documentation needed to understand and reproduce the workflow, while the underlying source data must be obtained separately.

The .gitignore file prevents local raw and processed datasets from being committed to the repository.