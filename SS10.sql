USE AdventureWorks2019
GO 

--1
CREATE VIEW VW_ProductInfo AS 
SELECT ProductID, ProductNumber, Name, SafetyStockLevel
FROM Production.Product
GO 

--2
SELECT * FROM dbo.VW_ProductInfo

--3
CREATE VIEW VW_PersonDetails AS
SELECT p.Title, p.FirstName , p.MiddleName, p.LastName, e.JobTitle
FROM HumanResources.Employee e
     INNER JOIN Person.Person p
	 ON p.BusinessEntityID = e.BusinessEntityID
GO 

--4
SELECT * FROM dbo.VW_PersonDetails

--5
CREATE VIEW VW_PersonDetailsNew AS 
SELECT COALESCE(p.Title, '') AS Title ,
       p.FirstName,
	   COALESCE(p.MiddleName, '')AS MiddleName,
	   p.LastName,
	   e.JobTitle
FROM HumanResources.Employee e
     INNER JOIN Person.Person p
	 ON p.BusinessEntityID = e.BusinessEntityID
GO 

SELECT * FROM VW_PersonDetailsNew

--6
CREATE VIEW VW_SortedPersonDetails AS 
SELECT TOP 10 COALESCE(p.Title, '') AS Title ,
       p.FirstName,
	   COALESCE(p.MiddleName, '')AS MiddleName,
	   p.LastName,
	   e.JobTitle
FROM HumanResources.Employee e
     INNER JOIN Person.Person p
	 ON p.BusinessEntityID = e.BusinessEntityID
	 ORDER BY p.FirstName
GO 

SELECT * FROM VW_SortedPersonDetails

--7
CREATE TABLE Emplyee_Personal_Details (
    EmpID INT NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Address VARCHAR(30)
)
GO 

--8
CREATE TABLE Emplyee_Salary_Details (
    EmpID INT NOT NULL,
	Designation VARCHAR(30),
	Salary VARCHAR(30) NOT NULL
)
GO 

--9
CREATE VIEW VW_Emplyee_Personal_Details AS
SELECT e1.EmpID, e1.FirstName, e1.LastName, e2.Designation, e2.Salary
FROM dbo.Emplyee_Personal_Details e1
JOIN dbo.Emplyee_Salary_Details e2
ON e2.EmpID = e1.EmpID

SELECT * FROM VW_Emplyee_Personal_Details 

--10
INSERT INTO VW_Emplyee_Personal_Details VALUES (2, 'Jack', 'Wilson', 'Sofware', 'Developer', 16000)

--11
CREATE VIEW VW_EmpDetails AS 
SELECT FirstName, Address
FROM Emplyee_Personal_Details
GO 

SELECT * FROM VW_EmpDetails

--12
INSERT INTO VW_EmpDetails VALUES ('Jack', 'NYC')

--13
CREATE TABLE Product_Details
(
    ProductID INT,
	ProductName VARCHAR(30),
	Rate MONEY
)

--14
CREATE VIEW VW_Product_Details AS 
SELECT ProductName, Rate 
FROM dbo.Product_Details

INSERT INTO VW_Product_Details VALUES ('DVD Writer', 2250),
                                      ('DVD Writer', 1250),
									  ('DVD Writer', 1250),
									  ('Extemal Hard Drive', 4250),
									  ('Extemal Hard Drive', 4250)


--15
UPDATE VW_Product_Details
SET Rate = 3000
WHERE ProductName = 'DVD Writer'

SELECT * FROM VW_Product_Details


--16 
CREATE VIEW VW_Product_Details AS 
SELECT ProductName, Description,Rate 
FROM dbo.Product_Details

--17
UPDATE VW_Product_Details
SET Description.WRITE(N'Ex',0,2)
WHERE ProductName = 'Portable Hard Drive'

--18
DELETE FROM  VW_CustDetails WHERE CustID = 'C0004'

--19
ALTER VIEW VW_ProductInfo AS
SELECT ProductID, ProductNumber, Name, SafetyStockLevel, ReOrderPoint
FROM Production.Product
GO 

--20
DROP VIEW VW_ProductInfo

--21
EXEC sp_helptext VW_Emplyee_Personal_Details

--22
CREATE VIEW VW_Product_Details AS 
SELECT ProductName, AVG(Rate) AS AverageRate
FROM Product_Details

--23
CREATE VIEW VW_ProductInfo AS
SELECT ProductID, ProductNumber, Name, SafetyStockLevel, ReorderPoint
FROM Production.Product
WHERE SafetyStockLevel <= 1000
WITH CHECK OPTION  --  kiểm tra điều kiện 

SELECT * FROM VW_ProductInfo

--24
UPDATE dbo.VW_ProductInfo SET SafetyStockLevel = 2500
WHERE ProductID = 321

--25
CREATE VIEW VW_NewProductInfo 
WITH Schemabinding  AS
SELECT ProductID, ProductNumber, Name, SafetyStockLevel
FROM Production.Product

SELECT * FROM VW_NewProductInfo

--26
CREATE TABLE Customers
(
    CustID INT,
	CustName VARCHAR(50),
	Address VARCHAR(60)
)
GO 

--27
CREATE VIEW VW_Customers AS
SELECT * FROM Customers

--28
SELECT * FROM VW_Customers

--29
ALTER TABLE Customers 
    ADD Age int -- k update vào View 

--30
SELECT * FROM VW_Customers

--31
EXEC sp_refreshview'VW_Customers' -- cập nhập mới nhất 

--32
ALTER TABLE Production.Product 
    ALTER COLUMN ProductID varchar(7)

--33
EXECUTE xp_fileexist 'C:\MyTest.txt'

--34
CREATE PROCEDURE uspGetCustTerritory AS
SELECT TOP 10 CustomerID, Customer.TerritoryID, Sales.SalesTerritory.Name
FROM  Sales.Customer 
JOIN Sales.SalesTerritory 
ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID

--35
EXEC uspGetCustTerritory

--36
CREATE PROCEDURE uspGetSales 
   @territory varchar(40)
AS
SELECT BusinessEntityID, B.SalesYTD, B.SalesLastYear 
FROM Sales.SalesPerson A
JOIN Sales.SalesTerritory B
ON A.TerritoryID = B.TerritoryID
WHERE B.Name = @territory

EXECUTE uspGetSales @territory='Northwest'

--37
CREATE PROCEDURE uspGetTotalSales 
   @territory varchar(40),
   @sum int OUTPUT 
AS 
SELECT  @sum = SUM(B.SalesYTD)
FROM Sales.SalesPerson A 
JOIN Sales.SalesTerritory B 
ON A.TerritoryID = B.TerritoryID
WHERE B.NAME = @territory

--38
DECLARE @sumsales money
EXEC uspGetTotalSales 'Northwest0', @sumsales OUTPUT 
PRINT 'The' + CONVERT(varchar(100), @sumsales)

--39
ALTER PROCEDURE uspGetTotal
    @territory varchar = 40
AS 
SELECT BusinessEntityID, B.SalesYTD, B.CostYTD, B.SalesLastYear
FROM  Sales.Salesperson A 
JOIN Sales.SalesTerritory B 
ON A.TerritoryID = B.TerritoryID
WHERE B.NAME = @territory
GO 

--40
DROP PROCEDURE uspGetTotal

--41
CREATE PROCEDURE NestedProcedure AS
BEGIN 
EXEC uspGetCustTerrutory
EXEC uspGetSales 'France'
END 

--42
SELECT name, object_id, type, type_desc
FROM sys.tables

--43
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES

--44
SELECT SERVERPROPERTY('Edition') AS EditionName

--45
SELECT session_id, login_time, program_name
FROM sys.dm_exec_sessions
WHERE login_time = 'sa' AND is_user_process = 1