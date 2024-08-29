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

## Phase 1: Data Cleaning

Before performing any analysis, it’s essential to clean and organize the raw data to ensure accuracy and consistency. In this phase, the focus was on:

1. **Removing duplicates**: Ensuring that no duplicate records exist.
2. **Standardizing data**: Ensuring uniformity in columns like `State_Name` and `Place`.
3. **Checking for Incorrect Values**: Ensuring that the data is free from invalid or incorrect values.

### Example Code Block 1: Removing duplicates

In this step, I identified and removed duplicate records in the `USHouseholdIncome` table using the following SQL queries:

```sql
-- Duplicates in USHouseholdIncome

-- Look for existence of duplicates
SELECT id, COUNT(id) count
FROM USHouseholdIncome
GROUP BY id
HAVING count > 1;

-- Get duplicates
SELECT *
FROM (SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id) AS row_num
    FROM USHouseholdIncome) row_num
WHERE row_num > 1
;

-- Remove duplicates
DELETE FROM USHouseholdIncome
WHERE row_id IN (SELECT row_id
                FROM (SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id) AS row_num
                    FROM USHouseholdIncome) row_num
                WHERE row_num > 1);
```

#### Explanation

In this example, I first identified duplicate records by counting occurrences of the id column. Then, I used the ROW_NUMBER() function to locate the duplicate rows and removed them from the USHouseholdIncome table, ensuring no duplicate records remain.

### Example Code Block 2: Standardizing Data

Ensuring consistency in the dataset is crucial for accurate analysis. The following SQL queries were used to standardize the `State_Name` column in the `USHouseholdIncome` table:

```sql
-- Standardize Data

-- USHouseholdIncome
-- State_Name

SELECT DISTINCT State_Name
FROM USHouseholdIncome;

SELECT State_Name
FROM USHouseholdIncome
WHERE State_Name LIKE 'alabama';

-- Fix it
UPDATE USHouseholdIncome
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Fix it
UPDATE USHouseholdIncome
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';
```

#### Explanation

In this process, I first identified inconsistent state names in the `State_Name` column. By using the `SELECT DISTINCT` query, I detected anomalies like "alabama" and "georia". I then corrected these issues using `UPDATE` queries to ensure uniformity across the dataset. For instance, "alabama" was standardized to "Alabama" and "georia" to "Georgia".

### Example Code Block 3: Checking for Incorrect Values

Ensuring that the data is free from invalid or incorrect values is an important part of the data cleaning process. The following SQL queries were used to check for potential issues in the `ALand` and `AWater` columns:

```sql
-- Check that possible wrong values are only zeros
SELECT DISTINCT Awater
FROM USHouseholdIncome
WHERE AWater = ''
    OR AWater = 0
    OR AWater IS NULL;

-- Look for cases where both zeros
SELECT ALand, AWater
FROM USHouseholdIncome
WHERE ALand = 0
    AND AWater = 0; -- there are not
```

#### Explanation

In this step, I first checked for potential errors in the `AWater` column, such as empty strings, zero values, or `NULL` entries. After identifying the distinct values, I ran a query to ensure there were no cases where both the `ALand` and `AWater` columns had a value of zero, confirming data integrity in those fields.
