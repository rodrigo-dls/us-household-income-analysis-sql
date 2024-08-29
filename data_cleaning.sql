# US_Household_Income 

SELECT *
FROM ushouseholdincome;

SELECT *
FROM ushouseholdincome_statistics;

SELECT COUNT(id)
FROM ushouseholdincome;

SELECT COUNT(id)
FROM ushouseholdincome_statistics;

-- Duplicates in USHouseholdIncome

-- Look for existance of duplicates

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

-- Duplicates in ushouseholdincome_statistics

-- Look for existance of duplicates

SELECT id, COUNT(id) count
FROM ushouseholdincome_statistics
GROUP BY id
HAVING count > 1; -- no duplicates

-- Standarize Data

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

-- State_ab
SELECT DISTINCT State_ab
FROM USHouseholdIncome;

-- County
SELECT DISTINCT County
FROM USHouseholdIncome
ORDER BY County ASC;

-- City
SELECT DISTINCT City
FROM USHouseholdIncome
ORDER BY City ASC;

-- Place
SELECT DISTINCT(Place)
FROM USHouseholdIncome
ORDER BY Place ASC; -- there is one NULL value to be fixex

-- Check the case
SELECT *
FROM USHouseholdIncome
WHERE Place IS NULL;

-- Compare to the similar ones
SELECT *
FROM USHouseholdIncome
WHERE County = 'Autauga County'
    AND City = 'Vinemont'
ORDER BY County, City, Place ASC;

-- Fix it
UPDATE USHouseholdIncome
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
    AND City = 'Vinemont';

-- Type
SELECT Type, COUNT(Type)
FROM USHouseholdIncome
GROUP BY Type
ORDER BY 1 ASC; -- considering the number of each type, there are a few that seem to have spelling mistakes

-- Fix it
UPDATE USHouseholdIncome
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- ALand & AWater
SELECT *
FROM USHouseholdIncome
WHERE ALand = ''
    OR ALand = 0
    OR ALand IS NULL;

-- Check that possible wrong values are only zeros
SELECT DISTINCT ALand
FROM USHouseholdIncome
WHERE ALand = ''
    OR ALand = 0
    OR ALand IS NULL;

SELECT *
FROM USHouseholdIncome
WHERE AWater = ''
    OR AWater = 0
    OR AWater IS NULL;

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
