# sql
Code examples for SQL Server and PostgreSQL

# SQL Server

```
/* List all databases: */
SELECT *
FROM master.dbo.sysdatabases;

/* List all tables: */
USE SalesOrdersExample;
SELECT *
FROM information_schema.tables;
``` 

## CREATE STORED PROCEDURE

```
/* USE SalesOrdersExample; */

CREATE PROCEDURE SelectAllCustomers
AS
SELECT * FROM Customers;

```
