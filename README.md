# sql
Code examples for SQL Server and PostgreSQL

## SQL Server

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

### CREATE STORED PROCEDURE

```
/* USE SalesOrdersExample; */

CREATE PROCEDURE SelectAllCustomers
AS
SELECT * FROM Customers;

```

### QUERY WITH JOIN
**FROM first_table join_type second_table [ON (join_condition)]**

```
SELECT ProductID, Purchasing.Vendor.BusinessEntityID, Name
FROM Purchasing.ProductVendor JOIN Purchasing.Vendor
    ON (Purchasing.ProductVendor.BusinessEntityID = Purchasing.Vendor.BusinessEntityID)
WHERE StandardPrice > $10
    AND Name LIKE N'F%'
```

