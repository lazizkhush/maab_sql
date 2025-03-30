use lesson5

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Jack', 'HR', 52000, '2021-03-29');
-- Assign a Unique Rank to Each Employee Based on Salary
SELECT *, 
	DENSE_RANK() OVER(ORDER BY Salary)
FROM Employees
ORDER BY EmployeeID

--Find Employees Who Have the Same Salary Rank
--With current topics covered during lessons, we cannot find them.

--Identify the Top 2 Highest Salaries in Each Department
SELECT * FROM(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS Salary_rank
	FROM Employees
) AS T
WHERE Salary_rank<=2

--Find the Lowest-Paid Employee in Each Department
SELECT * FROM(
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary) as Salary_rank
	FROM Employees
) AS t
WHERE Salary_rank = 1

--Calculate the Running Total of Salaries in Each Department
SELECT *,
	SUM(Salary)	OVER(PARTITION BY Department ORDER BY Department ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM Employees

--Find the Total Salary of Each Department Without GROUP BY
SELECT 
	DISTINCT Department, 
	SUM(Salary) OVER(PARTITION BY Department)
FROM Employees

--Calculate the Average Salary in Each Department Without GROUP BY
SELECT 
	DISTINCT Department, 
	AVG(Salary) OVER(PARTITION BY Department)
FROM Employees

--Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT *,
	Salary-AVG(Salary) OVER(PARTITION BY Department) as Salary_Difference
FROM Employees

--Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
SELECT *,
	AVG(Salary) OVER(PARTITION BY Department ORDER BY EmployeeId ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Movinf_Avg
FROM Employees

--Find the Sum of Salaries for the Last 3 Hired Employees
SELECT SumSalary FROM(
	SELECT Salary, 
	SUM(Salary) OVER(ORDER BY HireDate DESC) as SumSalary,
	ROW_NUMBER() OVER(ORDER BY HireDate DESC) AS LastHired
	FROM Employees
) AS t
WHERE LastHired=3

--Calculate the Running Average of Salaries Over All Previous Employees
SELECT *, 
	AVG(Salary) OVER(ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM (
	SELECT *,
	ROW_NUMBER() OVER(ORDER BY HireDate DESC) as HireOrderDesc 
	FROM Employees	
) AS t
WHERE HireOrderDesc > 3

--Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
SELECT *,
	MAX(Salary) OVER(ORDER BY EmployeeID ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS SlidingMaxSaalary
FROM Employees

--Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary
SELECT *,
	 CAST(Salary/SUM(Salary) OVER(PARTITION BY DEPARTMENT) AS DECIMAL(10,2)) *100 AS PercentagetContrib
FROM Employees







