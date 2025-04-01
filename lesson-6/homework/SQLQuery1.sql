-- Create the Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

-- Create the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    DepartmentID INT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL
);

-- Create the Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50) NOT NULL,
    EmployeeID INT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);

-- Insert sample data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Insert sample data into Employees table
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

-- Insert sample data into Projects table
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

-- Write a query to get a list of employees along with their department names.
SELECT Name, d.DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID;

--Write a query to list all employees, including those who are not assigned to any department.
SELECT Name, d.DepartmentName
FROM Employees AS e
LEFT JOIN Departments AS d ON e.DepartmentID = d.DepartmentID;

--Write a query to list all departments, including those without employees.
SELECT NAME, D.DepartmentName
FROM Employees AS E
RIGHT JOIN Departments AS D ON E.DepartmentID=D.DepartmentID

--Write a query to retrieve all employees and all departments, even if there’s no match between them.
SELECT NAME, D.DepartmentName
FROM Employees AS E
FULL OUTER JOIN Departments AS D ON E.DepartmentID=D.DepartmentID

--Write a query to find the total salary expense for each department.
SELECT D.DepartmentName, SUM(Salary)
FROM Employees AS E
RIGHT JOIN Departments AS D ON E.DepartmentID=D.DepartmentID
GROUP BY D.DepartmentName

--Write a query to generate all possible combinations of departments and projects.
SELECT * 
FROM Departments
CROSS JOIN Projects

--Write a query to get a list of employees with their department names and assigned project names. 
--Include employees even if they don’t have a project.
SELECT Name, D.DepartmentName, P.ProjectName
FROM Employees AS E 
LEFT JOIN Departments AS D ON E.DepartmentID=D.DepartmentID
LEFT JOIN Projects AS P ON P.EmployeeID = E.EmployeeID

