# NCAA March Madness 2026

A machine learning project for predicting NCAA March Madness basketball tournament outcomes using historical game data, team statistics, conference rankings, and multiple classification models.

## Project Overview

This project develops and evaluates four model stages for predicting NCAA tournament matchups:

* **All-Variables Logistic Regression**
* **RFECV / Pruned Logistic Regression**
* **XGBoost**
* **Ensemble Model** combining the RFECV/pruned logistic and XGBoost predictions

The resulting predictions are formatted for both Kaggle submissions and bracket generation. Model predictions are also represented as completed CBS Sports March Madness brackets.

The project is organized as a sequential notebook workflow, from data preparation and exploratory analysis through feature engineering, model development, and ensemble prediction.

---

## Data Sources

The project uses two primary data sources.

### NCAA March Madness Competition Data

The primary dataset comes from the NCAA March Madness competition data available through Kaggle.

The data include historical NCAA men's and women's basketball information used throughout the data preparation, matchup construction, feature engineering, and modeling workflows.

The raw Kaggle data are **not included in this repository**.

See [`data/raw/README.md`](data/raw/README.md) for information about obtaining and locally storing the required source data.

### BartTorvik Conference Rankings

Conference rankings from [BartTorvik](https://barttorvik.com/) are used as supplemental data.

These files are also **not included in this repository** and must be obtained separately.

See [`data/raw/README.md`](data/raw/README.md) for additional information.

---

## Project Workflow

The analysis follows this sequence:

```text
External Data
     │
     ▼
01_ETL
     │
     ▼
02_EDA
     │
     ▼
03_Dyad_Merges
     │
     ▼
04_All_Variables
     │
     ├───────────────┐
     ▼               ▼
05_Feature       06_XGBoost
Selection Model      Model
     │               │
     └───────┬───────┘
             ▼
      07_Ensemble Model
             │
             ▼
     Model Predictions
             │
       ┌─────┴─────┐
       ▼           ▼
   Kaggle      Bracket
 Submissions  Predictions
```

### Notebook 01 — ETL

`01_ETL.ipynb`

Prepares and consolidates the source data for subsequent analysis.

### Notebook 02 — EDA

`02_EDA.ipynb`

Performs exploratory data analysis and examines relationships and patterns in the prepared data.

### Notebook 03 — Dyad Merges

`03_Dyad_Merges.ipynb`

Constructs matchup-level data by creating team-pair ("dyad") representations of games and associated team statistics.

### Notebook 04 — All Variables

`04_All_Variables.ipynb`

Builds the all-variables logistic regression model using the available matchup features and generates the corresponding Kaggle and bracket prediction files.

### Notebook 05 — Feature Selection Model

`05_Feature_Selection_Model.ipynb`

Develops a logistic regression model using recursive feature elimination with cross-validation (RFECV) to identify a reduced feature set.

### Notebook 06 — XGBoost Model

`06_XGBoost_Model.ipynb`

Develops an XGBoost classification model and performs its own RFECV process to identify the features used by the final model. 
The resulting feature selection is also compared with the pruned feature-selection results from Notebook 05.

### Notebook 07 — Ensemble Model

`07_Ensemble_Model.ipynb`

Combines predictions from the RFECV/logistic regression and XGBoost models.

The ensemble currently uses an equal weighting of the two model predictions:

```text
Ensemble Probability =
    0.5 × RFECV Probability
  + 0.5 × XGBoost Probability
```

A probability threshold of 0.5 is used to determine the predicted winner.

---

## Models

The repository contains prediction files for three modeling approaches:

### All-Variables Logistic Regression

A logistic regression model using the full candidate feature set developed in the all-variables modeling workflow.

### RFECV / Pruned Logistic Regression

A reduced logistic regression model developed through RFECV and subsequent feature-pruning decisions.

### XGBoost

A gradient-boosted decision-tree classification model using XGBoost.

### Ensemble

A fixed 50/50 combination of the RFECV/pruned logistic and XGBoost model predictions.

---

## Model Outputs

The `models/` directory contains six prediction files:

```text
models/
├── bracket_submission.csv
├── bracket_submission_RFECV.csv
├── bracket_submission_XGBoost.csv
├── bracket_submission_ensemble.csv
├── kaggle_submission.csv
├── kaggle_submission_RFECV.csv
├── kaggle_submission_XGBoost.csv
└── kaggle_submission_ensemble.csv
```

The `kaggle_submission_*.csv` files contain predictions formatted for Kaggle submission.

The `bracket_submission_*.csv` files contain predictions used to generate tournament bracket selections.

---

## Bracket Predictions

The `brackets/` directory contains PDF exports of the resulting predictions as completed March Madness brackets.

Both men's and women's tournament predictions are represented for each modeling approach:

```text
brackets/
├── M_Predictions_Ensemble.pdf
├── M_Predictions_RFECV.pdf
├── M_Predictions_XGBoost.pdf
├── W_Predictions_Ensemble.pdf
├── W_Predictions_RFECV.pdf
└── W_Predictions_XGBoost.pdf
```

---

## Repository Structure

```text
NCAA-March-Madness-2026/
│
├── .github/
│   └── workflows/
│
├── brackets/
│   └── Tournament bracket PDF predictions
│
├── data/
│   ├── raw/
│   │   └── Instructions for obtaining external source data
│   ├── processed/
│   │   └── Documentation for generated datasets
│   └── README.md
│
├── models/
│   └── Model prediction and submission files
│
├── notebooks/
│   ├── 01_ETL.ipynb
│   ├── 02_EDA.ipynb
│   ├── 03_Dyad_Merges.ipynb
│   ├── 04_All_Variables.ipynb
│   ├── 05_Feature_Selection_Model.ipynb
│   ├── 06_XGBoost_Model.ipynb
│   └── 07_Ensemble_Model.ipynb
│
├── outputs/
│   └── Local/generated analysis outputs
│
├── src/
│   └── Reusable project code
│
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

---

## Reproducing the Project

### 1. Clone the repository

```bash
git clone <repository-url>
cd NCAA-March-Madness-2026
```

### 2. Install the required Python packages

```bash
pip install -r requirements.txt
```

### 3. Obtain the source data

Obtain the required NCAA March Madness competition data and BartTorvik conference-ranking data.

Place the downloaded files in:

```text
data/raw/
```

See [`data/raw/README.md`](data/raw/README.md) for additional information.

### 4. Run the notebooks in order

Execute the notebooks sequentially:

```text
01_ETL
02_EDA
03_Dyad_Merges
04_All_Variables
05_Feature_Selection_Model
06_XGBoost_Model
07_Ensemble_Model
```

The notebooks generate intermediate datasets and model outputs used by subsequent stages of the workflow.

---

## Dependencies

The project uses:

* pandas
* numpy
* matplotlib
* seaborn
* scipy
* networkx
* scikit-learn
* statsmodels
* XGBoost

See [`requirements.txt`](requirements.txt) for the complete package list.

---

## Repository Data Policy

The underlying NCAA/Kaggle and BartTorvik datasets are intentionally excluded from this repository.

Raw source datasets and generated processed datasets are excluded through `.gitignore`.

The repository therefore contains the analysis workflow, modeling notebooks, documentation, prediction outputs, and bracket representations without redistributing the underlying source datasets.

---

## License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE) for details.
