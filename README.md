# US Household Income Analysis: Data Cleaning and Exploratory Data Analysis with SQL

## Introduction

This project is part of my data analysis portfolio and demonstrates my ability to conduct both *Data Cleaning* and *Exploratory Data Analysis (EDA)* using **SQL**. The analysis is performed on two key datasets: `US Household Income` and `US Household Income Statistics`, both of which contain detailed geographical and statistical information about household income across various regions in the United States.

The goal of this project is to showcase my SQL skills by cleaning, transforming, and analyzing the data to extract meaningful insights about household income distribution at the state, county, and city levels. The entire process, from data preparation to final analysis, is conducted using **MySQL**.

## Dataset Overview

The project uses two tables:

1. **`US Household Income`**  
   Columns:
   - `row_id`: Unique identifier for each row.
   - `id`: Identifier for each record.
   - `State_Code`: Abbreviation for the state.
   - `State_Name`: Full name of the state.
   - `State_ab`: Short abbreviation of the state.
   - `County`: Name of the county.
   - `City`: Name of the city.
   - `Place`: Specific place or location.
   - `Type`: Type of geographical area (Urban, Rural, etc.).
   - `Primary`: Indicates primary record.
   - `Zip_Code`: Zip code of the location.
   - `Area_Code`: Telephone area code.
   - `ALand`: Land area (square meters).
   - `AWater`: Water area (square meters).
   - `Lat`: Latitude of the location.
   - `Lon`: Longitude of the location.

2. **`US Household Income Statistics`**  
   Columns:
   - `id`: Identifier linking to the `US Household Income` table.
   - `State_Name`: Full name of the state.
   - `Mean`: Mean household income for the state.
   - `Median`: Median household income for the state.
   - `Stdev`: Standard deviation of the household income.
   - `sum_w`: Sum of weights used for the statistical analysis.
