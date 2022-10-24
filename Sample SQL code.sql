

/*
Sample SQL code 

*/

-- Join another tabble -- 
select c.CustomerID,c.Fname,c.Lname
from tblCUSTOMER c
join tblORDER o on c.CustomerID=o.CustomerID
join tblORDER_PRODUCT op on o.OrderID=op.OrderID
join tblPRODUCT p on p.ProductID=op.ProductID
join tblPRODUCT_TYPE pt on pt.ProdTypeID=p.ProdTypeID
join (select c.CustomerID,c.Fname,c.Lname
from tblCUSTOMER c
join tblORDER o on c.CustomerID=o.CustomerID
join tblORDER_PRODUCT op on o.OrderID=op.OrderID
join tblPRODUCT p on p.ProductID=op.ProductID
join tblPRODUCT_TYPE pt on pt.ProdTypeID=p.ProdTypeID
where pt.ProdTypeName='Kitchen' and o.OrderDate < 'December 31,2008' and 'January 1,1999'<o.OrderDate
group by c.CustomerID,c.Fname,c.Lname
having sum(p.Price)<30 )AS subq1 ON c.CustomerID = subq1.CustomerID
where pt.ProdTypeName='Electronics' and o.OrderDate<'January 1,2013'
group by c.CustomerID,c.Fname,c.Lname
having count(p.ProductID)<3


-- Select from with datediff -- 
select top 6 c.CustState, sum(op.Calc_LineTotal)as total_dallars
from tblCUSTOMER c
join tblORDER o on c.CustomerID=o.CustomerID
join tblORDER_PRODUCT op on o.OrderID=op.OrderID
join tblPRODUCT p on p.ProductID=op.ProductID
join tblPRODUCT_TYPE pt on pt.ProdTypeID=p.ProdTypeID
where pt.ProdTypeName='Garden'
group by c.CustState, DATEDIFF(year, BirthDate, OrderDate)
having DATEDIFF(year, BirthDate, OrderDate)<33


-- CASE statement with 2 subqueries -- 
select (case 
when AutoUnits<20 and TotalBucksKitchen<800
then'Blue'
when AutoUnits between 20 and 30 and TotalBucksKitchen<800
then 'Green'
when AutoUnits between 31 and 45 and TotalBucksKitchen<800
then 'Orange'
when AutoUnits between 46 and 60 and TotalBucksKitchen between 801 and 3000
then 'Purple'
else 'Unknown'
end) as labelofautoandkitchen, COUNT(*) AS NumberOfCustomers
from (select c.CustomerID, SUM(OP.Quantity)as AutoUnits
from tblCUSTOMER c
   join tblORDER o on c.CustomerID=o.CustomerID
   join tblORDER_PRODUCT op on o.OrderID=op.OrderID
   join tblPRODUCT p on p.ProductID=op.ProductID
   join tblPRODUCT_TYPE pt on p.ProdTypeID=pt.ProdTypeID
   where pt.ProdTypeName='Automotive'
   GROUP BY c.CustomerID) A
join (select c.CustomerID, SUM(op.Calc_LineTotal)as TotalBucksKitchen
from tblCUSTOMER c
   join tblORDER o on c.CustomerID=o.CustomerID
   join tblORDER_PRODUCT op on o.OrderID=op.OrderID
   join tblPRODUCT p on p.ProductID=op.ProductID
   join tblPRODUCT_TYPE pt on p.ProdTypeID=pt.ProdTypeID
   where pt.ProdTypeName='Kitchen'
   GROUP BY c.CustomerID) B 
 on A.CustomerID=B.CustomerID
GROUP BY (case 
when AutoUnits<20 and TotalBucksKitchen<800
then'Blue'
when AutoUnits between 20 and 30 and TotalBucksKitchen<800
then 'Green'
when AutoUnits between 31 and 45 and TotalBucksKitchen<800
then 'Orange'
when AutoUnits between 46 and 60 and TotalBucksKitchen between 801 and 3000
then 'Purple'
else 'Unknown'
end)
ORDER BY NumberOfCustomers DESC
go 


-- create a stored procedure to DELETE a row in the DEPARTMENT table -- 
CREATE PROCEDURE uspDELETE_Department
@DeptName varchar(50),
@DeptAbbrev varchar(50),
@DeptDescr varchar(50),
@CollegeName varchar(50),
@CollegeDescr varchar(50)
AS
DECLARE @D_ID INT

SET @D_ID =  (SELECT DeptID
              FROM tblDEPARTMENT D
                   JOIN tblCOLLEGE C ON D.CollegeID＝C.CollegeID
              WHERE D.DeptDescr = @DeptDescr
                   AND D.DeptName = @DeptName
                   AND D.DeptAbbrev = @DeptAbbrev
                   AND C.CollegeName= @CollegeName
                   AND C.CollegeDescr= @CollegeDescr)

IF @D_ID IS NULL
	BEGIN
		PRINT 'Variable has come back NULL; check spelling of all parameters'; 
		RAISERROR ('@D_ID cannot be NULL; process is terminating', 11,1) 
        RETURN
	END


DELETE FROM tblDEPARTMENT
WHERE DeptID = @D_ID
GO


-- Create procedure with error reminder -- 
CREATE PROCEDURE uspInsertShow
@Title VARCHAR(100),
@TypeName VARCHAR(100),
@Release_Year DATE,
@Duration INT,
@Desc VARCHAR(2000),
@Date_Added DATE,
@Rating NUMERIC(3,2)
AS
DECLARE @TypeID INT

SET @TypeID = (SELECT TYPE_ID
               FROM [TYPE]
               WHERE TypeName = @TypeName)

IF @TypeID IS NULL
  BEGIN
    PRINT 'Type_ID has come back NULL; check spelling of all parameters';
		THROW 55555, 'Type_ID cannot be NULL; process is terminating', 1; 
		RETURN
  END

BEGIN TRAN T1
INSERT INTO SHOW (Title, Type_ID, Release_Year, Duration, Description, Date_Added, Rating)
VALUES (@Title, @TypeID, @Release_Year, @Duration, @Desc, @Date_Added, @Rating)
COMMIT TRAN T1
GO


-- Window function -- 
SELECT NAME, OBJECT, GRADE,
ROW_NUMBER(GRADE) OVER(PARTITION BY NAME
ORDER BY GRADE DESC) AS GRADE_RANK
FROM CLASS_A
ORDER BY NAME ASC


-- Create function -- 
CREATE FUNCTION east_or_west (
	@long DECIMAL(9,6))
RETURNS CHAR(4) AS
BEGIN
	DECLARE @return_value CHAR(4);
	SET @return_value = 'same';
    IF (@long > 0.00) SET @return_value = 'east';
    IF (@long < 0.00) SET @return_value = 'west';
    RETURN @return_value
END;

-- Create table/ERD database --
CREATE DATABASE People;


CREATE TABLE  People1  (
    Year_Birth date,
    Customer_id integer,
    Education varchar,
    Marital_Status varchar,
    Kidhome varchar,
    Teenhome varchar,
    Income varchar, 
    Dt_Customer varchar, 
    Product_id integer
);


CREATE TABLE Products (
     Promotion_id int identity(1,1), Member_id int identity(1,1),
     Product_id int identity(1,1) primary key,
     MntWines varchar,
     MntMeatProducts varchar,
     MntGoldProds varchar,
     MntSweetProducts varchar,
     MntFishProducts varchar,
     MntFruits varchar
);


CREATE TABLE  People_list (
    Customerid int identity(1,1)primary key,
    Complain varchar,
    Recency varchar
);


CREATE TABLE  Promotion (
    Promotionid int identity(1,1)primary key,
    Promotionplaceid int identity(1,1),
    AcceptedCmp1 varchar,
    AcceptedCmp2 varchar,
    AcceptedCmp3 varchar,
    AcceptedCmp4 varchar,
    AcceptedCmp5 varchar, 
    Response varchar, 
    NumDealsPurchases varchar
);


CREATE TABLE  Promotion_place (
    Promotionplaceid int identity(1,1)primary key,
    NumWebPurchases varchar,
    NumCatalogPurchases varchar,
    NumStorePurchases varchar,
    NumDealsPurchases varchar,
    NumWebVisitsMonth varchar
);
