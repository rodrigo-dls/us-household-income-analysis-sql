# US Household Income Exploratory Data Analysis

SELECT *
FROM USHouseholdincome;

SELECT *
FROM ushouseholdincome_statistics;

-- Top 10 States by ALand
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Top 10 States by AWater
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

-- Top 10 largest States
SELECT State_Name, SUM(ALand) + SUM(AWater) Total_area, SUM(ALand) Land_area, SUM(AWater) Water_Area
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Joining all data 
SELECT *
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id;

-- Looking for possible zero values in the statistics
SELECT *
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean = 0
OR Median = 0; -- there are zeros that affect some calculations

-- Top 10 States with the lowest average Income
SELECT u.State_Name, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 ASC
LIMIT 10;

-- Top 10 States with the highest average Income
SELECT u.State_Name, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Top 10 States with the lowest median Income
SELECT u.State_Name, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 ASC
LIMIT 10;

-- Top 10 States with the highest median Income
SELECT u.State_Name, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10;

-- Look at the top 5 higest and lowest average county incomes in New Jersey
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
ORDER BY 2 DESC
;

-- Number of Counties per State
SELECT State_Name, COUNT(DISTINCT(County))
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY 2;

-- Average number of counties per state
SELECT ROUND(AVG(num_count),1) avg_counties_per_state
FROM (SELECT State_Name, COUNT(DISTINCT(County)) num_count
    FROM USHouseholdIncome
    GROUP BY State_Name) num_count;


-- Types with the highest mean Income
SELECT u.Type, COUNT(u.Type) count_counties, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.Type
ORDER BY 3 DESC;

-- Types with the highest median Income
SELECT u.Type, COUNT(u.Type) count_counties, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.Type
ORDER BY 4 DESC; -- 'Urban' and 'Community' types have very dramatically low income compare to the other ones

-- Look at 'Community' type
SELECT *
FROM USHouseholdIncome
WHERE Type = 'Community'; -- They all belong to 'Puerto Rico', a state that is off land US, in Central America

-- Types with the highest median Income, filtering out the ones with low count of 'Type'
SELECT u.Type, COUNT(u.Type) count_counties, ROUND(AVG(Mean),1) Mean, ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.Type
HAVING count_counties > 100
ORDER BY 4 DESC;

-- Cities with the highest median Income
SELECT u.State_Name, u.City, ROUND(AVG(us.Mean),1) Mean,  ROUND(AVG(Median),1) Median
FROM USHouseholdIncome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
GROUP BY u.State_Name, u.City
ORDER BY Median DESC, Mean DESC -- looks like the highest values have been intentionally set.