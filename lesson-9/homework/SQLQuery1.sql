--TASK 1
--DROP TABLE IF EXISTS Employees
--CREATE TABLE Employees
--(
--	EmployeeID  INTEGER PRIMARY KEY,
--	ManagerID   INT NULL,
--	JobTitle    VARCHAR(100) NOT NULL
--);
--INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
--VALUES
--	(1001, NULL, 'President'),
--	(2002, 1001, 'Director'),
--	(3003, 1001, 'Office Manager'),
--	(4004, 2002, 'Engineer'),
--	(5005, 2002, 'Engineer'),
--	(6006, 2002, 'Engineer');

WITH EmployeeLevels AS (
    SELECT 
        EmployeeID,
        ManagerID,
        JobTitle,
        0 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.JobTitle,
        el.Level + 1
    FROM Employees e
    INNER JOIN EmployeeLevels el ON e.ManagerID = el.EmployeeID
)
SELECT * 
FROM EmployeeLevels
ORDER BY Level;

GO

-- Task 2: Find Factorials up to N
DECLARE @n INT = 10;

;WITH factorial AS(
	SELECT 1 as num, 1 as fact
	union all	
	select num+1, fact*num  from factorial
	where num < @n
)
SELECT *
FROM factorial
GO
--TASK 3: Find Fibonacci numbers up to N

DECLARE @N INT = 10;
WITH fibonacci AS(
	SELECT 1 as n, 0 as a, 1 as b
	UNION ALL
	SELECT n+1, b, a+b
	FROM fibonacci
	WHERE n<@n
)
SELECT n, a as fib 
FROM fibonacci
GO
