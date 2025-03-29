-- TASK 1
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT A, B , C, D  FROM [TestMultipleZero]
WHERE (A != 0) OR (B != 0) OR (C != 0) OR (D != 0)

--TASK 2

CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);


SELECT Year1, 
	CASE
		WHEN Max1 > Max2 AND Max1 > Max3 THEN Max1
		WHEN Max2 > Max1 AND Max2 > Max3 THEN Max2
		WHEN Max3 > Max1 AND Max3 > Max1 THEN Max3
	END
FROM TestMax

SELECT *FROM TestMax

-- TASK 3

CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

SELECT * FROM EmpBirth
WHERE MONTH(BirthDate) = 5 AND DAY(BirthDATE) BETWEEN 7 AND 15


-- TASK 4

create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

-- b will be the last
SELECT * FROM letters
ORDER BY 
CASE
	WHEN letter = 'b' THEN 2
	ELSE 1
END, letter

-- b will be the first

SELECT * FROM letters
ORDER BY 
CASE
	WHEN letter = 'b' THEN 1
	ELSE 2
END, letter


