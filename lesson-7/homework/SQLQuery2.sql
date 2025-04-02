CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

INSERT INTO Customers VALUES 
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');


--Retrieve All Customers With Their Orders (Include Customers Without Orders)
SELECT cust.CustomerID, CustomerName, OrderID, OrderDate 
FROM Customers AS cust
LEFT JOIN Orders AS ord 
	ON cust.CustomerID = ord.CustomerID

--Find Customers Who Have Never Placed an Order
SELECT cust.CustomerID, CustomerName, OrderID
FROM Customers AS cust
LEFT JOIN Orders AS ord 
	ON cust.CustomerID = ord.CustomerID
WHERE OrderID IS NULL

--List All Orders With Their Products
SELECT ordDet.OrderID, pr.ProductName, ordDet.Quantity
FROM OrderDetails AS ordDet
JOIN Products AS pr 
	ON ordDet.ProductID = pr.ProductID

 --Find the Most Expensive Product in Each Order
SELECT 
	ordDet.OrderID,
	pr.ProductName,
	CAST(MAX(ordDet.Price/ordDet.Quantity) AS decimal(10,2)) AS TheMostExpensive
FROM OrderDetails as ordDet
JOIN Products AS pr 
	ON ordDet.ProductID = pr.ProductID
GROUP BY ordDet.OrderID, pr.ProductName
ORDER BY ordDet.OrderID

--Find the Latest Order for Each Customer
SELECT 
	cust.CustomerID, 
	cust.CustomerName, 
	MAX(ord.OrderDate) AS LatestOrderDate
FROM Orders AS ord
JOIN Customers AS cust 
	ON cust.CustomerID = ord.CustomerID
GROUP BY cust.CustomerID, cust.CustomerName

--Find Customers Who Ordered at Least One 'Stationery' Product
SELECT  cust.CustomerID, cust.CustomerName, ord.OrderID,ordDet.ProductID, pr.ProductName
FROM Orders AS ord
JOIN Customers AS cust
	ON ord.CustomerID = cust.CustomerID
JOIN OrderDetails AS ordDet
	ON ord.OrderID = ordDet.OrderID
JOIN Products as pr
	ON ordDet.ProductID = pr.ProductID
WHERE pr.Category = 'Stationery'


--Find Total Amount Spent by Each Customer
SELECT CUST.CustomerID, cust.CustomerName, SUM(ordDet.Price) AS TotalSpent
FROM Customers AS cust
JOIN Orders AS ord
	ON ord.CustomerID = cust.CustomerID
JOIN OrderDetails AS ordDet
	ON ord.OrderID = ordDet.OrderID
GROUP BY CUST.CustomerID, cust.CustomerName