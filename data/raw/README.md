# Raw Data

The raw datasets used in this project are not included in the GitHub repository.

## 1. NCAA March Madness Competition Data

The primary data source is the NCAA March Madness competition data provided through Kaggle.

The project uses NCAA men's and women's basketball data, including tournament and regular-season results, team information, tournament seeds, tournament slots, seasons, and team conference information.

Download the required competition data from Kaggle and place the files directly in this directory: 

data/raw/

The ETL notebook (notebooks/01_ETL.ipynb) documents the specific files loaded by the project.


## 2. BartTorvik Conference Rankings

The project supplements the NCAA/Kaggle data with conference rankings from BartTorvik:

https://barttorvik.com/

The required conference-ranking files should also be placed in:

data/raw/

The ETL notebook documents the files used by the project.


Data Privacy / Repository Policy

Raw competition and supplemental datasets are intentionally excluded from this repository.

The .gitignore file prevents files placed in data/raw/ from being committed to GitHub.

To reproduce the project, obtain the required source data independently and place the files in the expected local directory before running the notebooks.