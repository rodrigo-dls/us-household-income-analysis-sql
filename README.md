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

### Removing duplicates

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

### Standardizing Data

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

## Phase 2: Exploratory Data Analysis (EDA)

Once the data cleaning was complete, the next step was to perform *Exploratory Data Analysis (EDA)*. EDA is crucial to understand the dataset, reveal trends, and extract insights related to household income distribution across different states and counties. In this phase, SQL queries were used to explore key aspects such as geographic size, income levels, and income disparities. Here are four key analyses from the EDA phase:

### Top 10 Largest States by Area

The first step in the analysis was to examine the largest states by total area (land and water). This allows us to see the geographical distribution across the United States.

```sql
-- Top 10 largest States
SELECT State_Name, SUM(ALand) + SUM(AWater) Total_area, SUM(ALand) Land_area, SUM(AWater) Water_Area
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;
```

#### Explanation

This query calculates the total area for each state by summing the land (`ALand`) and water (`AWater`) areas. It then groups the results by state and orders them by the largest area first. This provides a clear view of the states with the most geographical space, giving insight into how geography might influence economic factors like income distribution.

---

### Top 10 States with the Highest Average Income

Next, we calculated the top 10 states with the highest average income, which helps to understand the economic standing of various states.

```sql
-- Top 10 States with the highest average Income
SELECT u.State_Name, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;
```

#### Explanation

This query joins the `USHouseholdIncome` and `USHouseholdIncomeStatistics` tables to calculate the average (`AVG()`) mean and median incomes for each state. It excludes states where the mean income is zero and returns the top 10 states with the highest average incomes. This analysis is critical for understanding income distribution and identifying the wealthiest regions.

---

### Top 5 Highest and Lowest Average County Incomes in New Jersey

To further explore income distribution, we analyzed the counties in New Jersey with the highest and lowest average incomes. This provides a more granular view of income disparities within a single state.

```sql
-- Look at the top 5 highest and lowest average county incomes in New Jersey
SELECT *
FROM (SELECT u.County, ROUND(AVG(us.Mean),1) Mean -- highest income
    FROM USHouseholdIncome u
    JOIN ushouseholdincome_statistics us
        ON u.id = us.id
    WHERE u.State_Name LIKE 'New Jersey'
    AND Mean <> 0
    GROUP BY u.County
    ORDER BY 2 DESC
    LIMIT 5) highest_income
UNION
SELECT *
FROM (SELECT u.County, ROUND(AVG(us.Mean),1) Mean -- lowest income
    FROM USHouseholdIncome u
    JOIN ushouseholdincome_statistics us
        ON u.id = us.id
    WHERE u.State_Name LIKE 'New Jersey'
    AND Mean <> 0
    GROUP BY u.County
    ORDER BY 2 ASC
    LIMIT 5) lowest_income
ORDER BY 2 DESC;
```

#### Explanation

This query uses `UNION` to combine two sets of data: the top 5 counties in New Jersey with the highest average income and the 5 counties with the lowest. This gives a comprehensive overview of income extremes within a specific state. The use of subqueries and `JOINs` demonstrates advanced SQL capabilities, making it a strong example of handling complex queries.

---

### Average Number of Counties per State

Finally, we looked at the average number of counties per state, which helps us understand the typical administrative divisions across states.

```sql
-- Average number of counties per state
SELECT ROUND(AVG(num_count),1) avg_counties_per_state
FROM (SELECT State_Name, COUNT(DISTINCT(County)) num_count
    FROM USHouseholdIncome
    GROUP BY State_Name) num_count;
```

#### Explanation

This query calculates the average number of counties per state by first grouping the data by state and counting distinct counties. Then, it uses `AVG()` to calculate the overall average across all states. This analysis provides context on the geographic breakdown of the dataset and can inform further income-related analyses at the county level.

---

## Conclusion

The *Exploratory Data Analysis (EDA)* phase allowed us to gain critical insights into the distribution of household income across the United States. By analyzing both geographical and income data, we identified the largest states, states with the highest average incomes, and income disparities within specific states. These analyses demonstrate the power of SQL in exploring large datasets and uncovering trends that can inform policy or business decisions.

