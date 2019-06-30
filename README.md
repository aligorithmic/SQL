# sql
Code examples for SQL Server and PostgreSQL

# SQL Server

**Source: https://docs.microsoft.com/en-us/sql/sql-server/sql-server-technical-documentation**

```
/* List all databases: */
SELECT *
FROM master.dbo.sysdatabases;

/* List all tables: */
USE SalesOrdersExample;
SELECT *
FROM information_schema.tables;

USE AdventureWorks2012 ;  
CREATE TABLE ParentChildOrg  
   (  
    BusinessEntityID int PRIMARY KEY,  
    ManagerId int REFERENCES ParentChildOrg(BusinessEntityID),  
    EmployeeName nvarchar(50)   
   ) ;
```

## CREATE STORED PROCEDURE

```
/* USE SalesOrdersExample; */

CREATE PROCEDURE SelectAllCustomers
AS
SELECT * FROM Customers;

```

## QUERY WITH JOIN
**FROM first_table join_type second_table [ON (join_condition)]**

```
SELECT ProductID, Purchasing.Vendor.BusinessEntityID, Name
FROM Purchasing.ProductVendor JOIN Purchasing.Vendor
    ON (Purchasing.ProductVendor.BusinessEntityID = Purchasing.Vendor.BusinessEntityID)
WHERE StandardPrice > $10
    AND Name LIKE N'F%'
```

## QUERY PERFORMANCE TUNNING

1. Use SELECT Fields instead of SELECT *
2. Select More Fields to Avoid SELECT DISTINCT
3. Create Joins with INNER JOIN Rather than WHERE
4. Use WHERE instead of HAVING to Define Filters
5. When using LIKE operator, try to leave the wildcards on the right side of the VARCHAR.
6. Use LIMIT to Sample Query Results; Always restrict the number of rows and columns of your result. Always verify your WHERE clause and use TOP if necessary.
7. The decreasing performance order of operators is: = (faster)>, >=, <, <=, LIKE, <> (slower)
8. Use EXISTS or NOT EXISTS instead of IN or NOT IN. IN operator creates an overload on database; use BETWEEN instead of IN, too.
10. Queries with all operations on the WHERE clause connected by ANDs are processed from the left to right. If an operation returns false, all other operations in the right side of it are ignored, because they cannot change the AND result anyway. It is better then to start your WHERE clause with the operations that returns false most of the time.
11. Avoid cursors at all costs!

