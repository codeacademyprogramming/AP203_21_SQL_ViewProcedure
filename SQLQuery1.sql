CREATE DATABASE P203Store

USE P203Store

CREATE TABLE Brands
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL
)

CREATE TABLE Notebooks
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	Price DECIMAL (18,2),
	BrandId INT CONSTRAINT FK_Notebooks_BrandId FOREIGN KEY REFERENCES Brands(Id)
)

INSERT INTO Brands 
VALUES
('Apple'),
('Asus'),
('Lenovo'),
('HP'),
('Samsung'),
('Acer'),
('Nokia'),
('Sony')

SELECT * FROM Brands

INSERT INTO Notebooks
VALUES
('Macbook PRO 13',3500,1),
('Macbook PRO 15',5500,1),
('Macbook PRO 14',4500,1),
('Predetor',3200,6),
('Pavilion',1800,4),
('Ideapad',2800,4),
('TUFU',3000,2)

INSERT INTO Notebooks
VALUES
('AZTU',220,NULL)

UPDATE Notebooks
SET BrandId=6 WHERE Id=6

SELECT N.Id,N.Name, B.Name AS 'BrandName' FROM Notebooks AS N
JOIN Brands AS B ON N.BrandId = B.Id
WHERE B.Name LIKE '%a%'

SELECT N.Id,N.Name,N.Price, B.Name AS 'BrandName' FROM Notebooks AS N
JOIN Brands AS B ON N.BrandId = B.Id
WHERE (N.Price BETWEEN 2000 AND 4000) AND (B.Name LIKE 'Apple')

CREATE TABLE Phones
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	Price DECIMAL(18,2) NOT NULL CHECK (Price>=0),
)

ALTER TABLE Phones
ADD BrandId INT NOT NULL

ALTER TABLE Phones
ADD CONSTRAINT FK_Phones_BrandId FOREIGN KEY (BrandId) REFERENCES Brands(Id)


INSERT INTO Phones
VALUES
('3010',5500,7),
('6300',1500,7),
('S10',1800,5),
('S22',2500,5),
('S9',1200,5),
('Xpreia Z',1550,8),
('Iphone 13',2500,1),
('Iphone 11',1800,1),
('Iphone 12',2100,1),
('Iphone X',1000,1)

SELECT * FROM 
(
SELECT N.Name,Price ,B.Name AS 'BrandName' FROM Notebooks AS N
JOIN Brands AS B ON N.BrandId = B.Id
UNION ALL
SELECT P.Name,Price, B.Name FROM Phones AS P
JOIN Brands AS B ON P.BrandId = B.Id
) AS T
WHERE T.Price>2000
ORDER BY T.Price DESC

SELECT COUNT(Id), BrandId FROM Phones
GROUP BY BrandId
HAVING COUNT(Id)>1

SELECT * FROM Notebooks ORDER BY Price DESC

SELECT Products.Id,Products.Name,Products.Price,Products.BrandId,Brands.Name  FROM (SELECT * FROM Notebooks
UNION ALL
SELECT * FROM Phones) AS Products
JOIN Brands ON Products.BrandId = Brands.Id
WHERE Brands.Id = 1

CREATE VIEW ALL_PRODUCTS
AS
SELECT Products.Id,Products.Name,Products.Price,Products.BrandId,Brands.Name AS 'BrandName'  FROM (SELECT * FROM Notebooks
UNION ALL
SELECT * FROM Phones) AS Products
JOIN Brands ON Products.BrandId = Brands.Id

SELECT * FROM ALL_PRODUCTS
WHERE Price>2000 AND Name LIKE '%a%'

SELECT * FROM ALL_PRODUCTS
WHERE Price BETWEEN 2000 AND 4000

SELECT * FROM ALL_PRODUCTS





CREATE PROCEDURE FILTER_PRODUCTS_BYPRICE 
@MinPrice DECIMAL(18,2)
AS
SELECT Products.Id,Products.Name,Products.Price,Products.BrandId,Brands.Name AS 'BrandName'  FROM (SELECT * FROM Notebooks
UNION ALL
SELECT * FROM Phones) AS Products
JOIN Brands ON Products.BrandId = Brands.Id
WHERE Price>@MinPrice

EXEC FILTER_PRODUCTS_BYPRICE 4000

CREATE PROCEDURE USP_INSERT_PHONE
@Name NVARCHAR(30),
@Price DECIMAL(18,2),
@BrandId INT
AS
INSERT INTO Phones (Name,Price,BrandId)
VALUES
(@Name,@Price,@BrandId)

EXEC USP_INSERT_PHONE 'IPHONE 12 MINI',1500,1

ALTER PROCEDURE FILTER_PRODUCTS_BYPRICE
@MinPrice DECIMAL(18,2)
AS
SELECT * FROM ALL_PRODUCTS
WHERE Price>@MinPrice




