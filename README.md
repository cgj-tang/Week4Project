# Getting and Cleaning Data Course Project
This repo contains the script necessary to generate the `tidied_dataset.csv` summary table file as part of the final course project for the **Getting and Cleaning Data** course offered on Coursera. In brief, `run_analysis.R` downloads the necessary data, appends training and test datasets together, tidies these data before generating the aforementioned summary table. Please refer to `codebook.md` for a more thorough summary of the data transformations and variables retained by the script.

# Pre-requisites
This Rscript was written in an R v4.1.3 environment using functions provided through tidyverse (v1.3.1).

# Running the script
1. Clone the repository.
2. Navigate to the main repository directory in an R environment.
3. Run `source(run_analysis.R)`.
