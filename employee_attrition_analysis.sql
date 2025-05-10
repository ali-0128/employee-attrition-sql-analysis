
-- ===================
-- EMPLOYEE ANALYTICS 
-- ===================

-- ==============
-- DATA OVERVIEW
-- ==============

SELECT * FROM Employees;

-- ==============
-- DATA CLEANING
-- ==============

-- Check for Missing Values
SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN education IS NULL THEN 1 ELSE 0 END) AS 'missing education',
    SUM(CASE WHEN JoiningYear IS NULL THEN 1 ELSE 0 END) AS 'missing junior year',
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS 'missing city',
    SUM(CASE WHEN PaymentTier IS NULL THEN 1 ELSE 0 END) AS 'missing payment tier',
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS 'missing age',
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS 'missing gender',
    SUM(CASE WHEN EverBenched IS NULL THEN 1 ELSE 0 END) AS 'missing ever benched',
    SUM(CASE WHEN ExperienceInCurrentDomain IS NULL THEN 1 ELSE 0 END) AS 'missing experience',
    SUM(CASE WHEN LeaveOrNot IS NULL THEN 1 ELSE 0 END) AS 'missing leave'
FROM Employees;

-- Add Employee ID Column
ALTER TABLE Employees ADD EmployeeID INT IDENTITY(1, 1);

-- Check for Duplicates
SELECT EmployeeID, COUNT(*) AS duplicates
FROM Employees
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

-- Standardize Text Format
UPDATE Employees
SET
    Education = UPPER(Education),
    City = UPPER(City),
    Gender = UPPER(Gender);

-- Calculate Years of Service
SELECT *,
    YEAR(GETDATE()) - JoiningYear AS YearsOfService
FROM Employees;

-- ===============================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- ===============================

-- What is the distribution of educational qualifications?
select Education,
	count(*) as TotalEmployee
from Employees
group by Education
order by TotalEmployee;

-- What is the gender distribution among employees?
select Gender,
	count(*) as TotalEmployee
from Employees
group by Gender
order by TotalEmployee;

-- How does the year of joining vary across cities?
SELECT 
    City,
    AVG(2024 - JoiningYear) AS AvgTenure,
    MIN(2024 - JoiningYear) AS MinTenure,
    MAX(2024 - JoiningYear) AS MaxTenure,
    COUNT(*) AS TotalEmployees
FROM Employees
GROUP BY City
ORDER BY AvgTenure DESC;

-- Is there a relationship between payment tier and experience?
SELECT 
    PaymentTier,
    AVG(ExperienceInCurrentDomain) AS AvgExperience,
    MIN(ExperienceInCurrentDomain) AS MinExperience,
    MAX(ExperienceInCurrentDomain) AS MaxExperience,
    COUNT(*) AS TotalEmployees
FROM Employees
GROUP BY PaymentTier
ORDER BY AvgExperience DESC;

-- Total number of employees who left
SELECT 
    COUNT(*) AS TotalEmployees,
    SUM(LeaveOrNot) AS TotalLeavers,
    (SUM(LeaveOrNot) * 100.0 / COUNT(*)) AS OverallLeaveRate
FROM Employees;


--Turnover by Education
select education,  
	count(*) as TotalEmployees,
	sum(leaveornot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from Employees
group by Education
order by OverallLeaveRate desc;


-- Turnover by Joining Year
select joiningyear,
	count(*) as TotalEmployees,
	sum(leaveornot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from Employees
group by JoiningYear
order by OverallLeaveRate desc;


--Turnover by City
select city,
	count(*) as TotalEmployees,
	sum(LeaveOrNot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from Employees
group by City
order by OverallLeaveRate desc;

--Turnover by Payment Tier
select paymenttier,
	count(*) as TotalEmployees,
	sum(leaveornot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from Employees
group by PaymentTier
order by OverallLeaveRate;

--Turnover by Age
select age,
	count(*) as TotalEmployees,
	sum(leaveornot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from Employees
group by Age
order by OverallLeaveRate desc;


--Turnover by Gender
select gender,
	count(*) as TotalEmployees,
	sum(leaveornot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from employees
group by gender
order by OverallLeaveRate desc;


-- Turnover by Benched 
select everbenched,
	count(*) as TotalEmployee,
	sum(leaveornot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from employees
group by everbenched
order by OverallLeaveRate desc;


--Turnover by Experience
select ExperienceInCurrentDomain,
	count(*) as TotalEmployee,
	sum(leaveornot) as TotalLeavers,
	(sum(leaveornot) * 100.0 / count(*)) as OverallLeaveRate
from employees
group by ExperienceInCurrentDomain
order by OverallLeaveRate desc;

-- Turnover by age group
SELECT 
    CASE 
        WHEN Age BETWEEN 22 AND 30 THEN '22-30'
        WHEN Age BETWEEN 31 AND 41 THEN '31-41'
    END AS AgeGroup,
    COUNT(*) AS TotalEmployees,
    SUM(LeaveOrNot) AS Leavers,
    (SUM(LeaveOrNot) * 100.0 / COUNT(*)) AS LeaveRate
FROM Employees
GROUP BY CASE 
        WHEN Age BETWEEN 22 AND 30 THEN '22-30'
        WHEN Age BETWEEN 31 AND 41 THEN '31-41'
    END
ORDER BY LeaveRate DESC;

-- Turnover by service duration group
SELECT
    CASE
        WHEN (YEAR(GETDATE()) - JoiningYear) < 3 THEN '0-2 Years'
        WHEN (YEAR(GETDATE()) - JoiningYear) BETWEEN 3 AND 5 THEN '3-5 Years'
        ELSE '6+ Years'
    END AS ServiceGroup,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN LeaveOrNot = 1 THEN 1 ELSE 0 END) AS LeftEmployees,
    ROUND(100.0 * SUM(CASE WHEN LeaveOrNot = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS TurnoverRate
FROM Employees
GROUP BY
    CASE
        WHEN (YEAR(GETDATE()) - JoiningYear) < 3 THEN '0-2 Years'
        WHEN (YEAR(GETDATE()) - JoiningYear) BETWEEN 3 AND 5 THEN '3-5 Years'
        ELSE '6+ Years'
    END;

-- Turnover by experience level
SELECT 
    CASE 
        WHEN ExperienceInCurrentDomain <= 2 THEN 'Junior'
        WHEN ExperienceInCurrentDomain <= 5 THEN 'Mid'
        ELSE 'Senior'
    END AS ExperienceLevel,
    COUNT(*) AS TotalEmployees,
    SUM(LeaveOrNot) AS Leavers,
    (SUM(LeaveOrNot) * 100.0 / COUNT(*)) AS LeaveRate
FROM Employees
GROUP BY CASE 
        WHEN ExperienceInCurrentDomain <= 2 THEN 'Junior'
        WHEN ExperienceInCurrentDomain <= 5 THEN 'Mid'
        ELSE 'Senior'
	End
ORDER BY LeaveRate DESC;

-- Average age and experience: left vs stayed
SELECT 
    LeaveOrNot,
    AVG(Age) AS AvgAge,
    AVG(ExperienceInCurrentDomain) AS AvgExperience
FROM Employees
GROUP BY LeaveOrNot;

-- Average years of service for those who left vs stayed
SELECT
    LeaveOrNot,
    COUNT(*) AS TotalEmployees,
    ROUND(AVG(YEAR(GETDATE()) - JoiningYear), 2) AS AvgYearsOfService
FROM Employees
GROUP BY LeaveOrNot;


-- Impact of city and payment tier together
SELECT 
    City,
    PaymentTier,
    COUNT(*) AS TotalEmployees,
    SUM(LeaveOrNot) AS Leavers,
    (SUM(LeaveOrNot) * 100.0 / COUNT(*)) AS LeaveRate
FROM Employees
GROUP BY City, PaymentTier
ORDER BY LeaveRate DESC;