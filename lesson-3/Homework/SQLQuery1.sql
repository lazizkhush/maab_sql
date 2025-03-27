--Task 1
-- Creating the employee table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

--Inserting Values into employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate) 
VALUES 
(1, 'John', 'Doe', 'IT', 75000.00, '2022-03-15'),
(2, 'Jane', 'Smith', 'HR', 65000.00, '2021-07-10'),
(3, 'Michael', 'Johnson', 'Finance', 80000.00, '2019-10-05'),
(4, 'Emily', 'Davis', 'Marketing', 72000.00, '2020-06-20'),
(5, 'Robert', 'Wilson', 'IT', 85000.00, '2018-11-12'),
(6, 'Sarah', 'Miller', 'HR', 67000.00, '2023-02-01'),
(7, 'David', 'Anderson', 'Finance', 90000.00, '2017-09-30'),
(8, 'Laura', 'Taylor', 'Marketing', 71000.00, '2021-04-18'),
(9, 'James', 'Brown', 'IT', 78000.00, '2019-12-05'),
(10, 'Olivia', 'Martinez', 'Finance', 82000.00, '2022-08-22');

--Filtering data
SELECT Department, AVG(SALARY) AS Average_salary,
	CASE
		WHEN AVG(SALARY)>80000 THEN 'HIGH'
		WHEN AVG(SALARY)<80000 AND AVG(SALARY) >50000 THEN 'MEDIUM'
		ELSE 'LOW'
	END 
	AS Salary_Categories
FROM Employees
GROUP BY Department
ORDER BY Average_salary
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY

--Task 2
--Creating the orders table

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);


--Inserting Data into orders table
INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status) 
VALUES 
(1, 'John Doe', '2024-03-01', 150.75, 'Shipped'),
(2, 'Jane Smith', '2023-03-02', 89.50, 'Delivered'),
(3, 'Michael Johnson', '2023-03-03', 220.00, 'Pending'),
(4, 'Emily Davis', '2023-03-04', 45.99, 'Cancelled'),
(5, 'Robert Wilson', '2023-03-05', 320.40, 'Shipped'),
(6, 'Sarah Miller', '2023-03-06', 175.25, 'Pending'),
(7, 'David Anderson', '2024-03-07', 135.60, 'Delivered'),
(8, 'Laura Taylor', '2023-03-08', 290.10, 'Shipped'),
(9, 'James Brown', '2024-03-09', 60.75, 'Cancelled'),
(10, 'Olivia Martinez', '2024-03-10', 410.20, 'Delivered'),
(11, 'William Garcia', '2023-01-11', 88.00, 'Pending'),
(12, 'Sophia Thomas', '2024-03-12', 150.00, 'Shipped'),
(13, 'Daniel Harris', '2024-03-13', 199.99, 'Delivered'),
(14, 'Ethan White', '2023-03-14', 275.80, 'Shipped'),
(15, 'Emma Clark', '2023-03-15', 50.30, 'Pending');


SELECT 
	CASE
		WHEN Status = 'Delivered' or Status = 'Shipped' THEN 'Completed'
		ELSE Status
	END AS OrderStatus,
	COUNT(*) AS TotalOrders,
	SUM(TotalAmount) AS TotalRevunue
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY 
	CASE
		WHEN Status = 'Delivered' or Status = 'Shipped' THEN 'Completed'
		ELSE Status
	END
HAVING SUM(TotalAmount)>5000
ORDER BY SUM(TotalAmount) DESC


--Task3
--Creating the products table

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);


--Inserting Data into pruducts table


INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) 
VALUES 
(1, 'Laptop', 'Electronics', 899.99, 25),
(2, 'Smartphone', 'Electronics', 699.50, 50),
(3, 'Headphones', 'Electronics', 129.99, 100),
(4, 'Desk Chair', 'Furniture', 199.99, 30),
(5, 'Dining Table', 'Furniture', 499.99, 10),
(6, 'Blender', 'Home Appliances', 79.99, 40),
(7, 'Microwave Oven', 'Home Appliances', 249.99, 20),
(8, 'Refrigerator', 'Home Appliances', 1099.99, 15),
(9, 'Running Shoes', 'Sports', 89.99, 60),
(10, 'Tennis Racket', 'Sports', 159.99, 35),
(11, 'Backpack', 'Accessories', 49.99, 75),
(12, 'Sunglasses', 'Accessories', 79.99, 90),
(13, 'Watch', 'Accessories', 199.99, 55),
(14, 'Notebook', 'Stationery', 5.99, 200),
(15, 'Ballpoint Pen', 'Stationery', 1.50, 500);

--Selects distinct categories from products table

SELECT DISTINCT Category
FROM Products

--Select the most highest price for each category
SELECT Category, MAX(Price)
FROM Products
GROUP BY Category

--Working with Inventory Status

SELECT *, 
	IIF(Stock = 0, 'Out of stock',
		IIF(Stock BETWEEN 1 AND 10, 'Low stock', 'Stock')) AS InventoryStatus 
FROM Products
ORDER BY Price DESC
OFFSET 5 ROWS