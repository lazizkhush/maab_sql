-- Create the table
CREATE TABLE Shipments (
    N INT PRIMARY KEY,
    Num INT
);

-- Insert the original data (33 records with known shipments)
INSERT INTO Shipments (N, Num) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1),
(9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 4), (15, 4), 
(16, 4), (17, 4), (18, 4), (19, 4), (20, 4), (21, 4), (22, 4), 
(23, 4), (24, 4), (25, 4), (26, 5), (27, 5), (28, 5), (29, 5), 
(30, 5), (31, 5), (32, 6), (33, 7);

-- Add the missing 7 days with 0 shipments
INSERT INTO Shipments (N, Num)
SELECT N, 0
FROM (SELECT 34 AS N UNION ALL SELECT 35 UNION ALL SELECT 36 UNION ALL
      SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40) AS zeros;

-- Use ROW_NUMBER to sort data and find median
WITH Ordered AS (
    SELECT Num,
           ROW_NUMBER() OVER (ORDER BY Num) AS rn,
           COUNT(*) OVER () AS total
    FROM Shipments
),
MedianCalc AS (
    SELECT
        -- For even total, take average of middle two
        CASE
            WHEN total % 2 = 1 THEN 
                CAST(MAX(CASE WHEN rn = (total + 1) / 2 THEN Num END) AS FLOAT)
            ELSE 
                (CAST(MAX(CASE WHEN rn = total / 2 THEN Num END) AS FLOAT) +
                 CAST(MAX(CASE WHEN rn = total / 2 + 1 THEN Num END) AS FLOAT)) / 2.0
        END AS median_value
    FROM Ordered
)
SELECT median_value FROM MedianCalc;
