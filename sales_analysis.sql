CREATE DATABASE SAMPLEDB;
USE SAMPLEDB;

-- make deptno as Primary Key
CREATE TABLE dept (
  deptno TINYINT PRIMARY KEY,
  dname varchar(14) default NULL,
  loc varchar(13) default NULL
);

INSERT INTO dept VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO dept VALUES (20,'RESEARCH','DALLAS');
INSERT INTO dept VALUES (30,'SALES','CHICAGO');
INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON');

SELECT * FROM dept;

CREATE TABLE emp (
  empno smallint PRIMARY KEY,
  ename varchar(10) default NULL,
  job varchar(9) default NULL,
  mgr smallint default NULL,
  hiredate date default NULL,
  sal decimal(7,2) default NULL,
  comm decimal(7,2) default NULL,
  deptno TINYINT,
  FOREIGN KEY(deptno) REFERENCES dept(deptno));
  
  DESC emp;
  
INSERT INTO emp VALUES (7369,'SMITH','CLERK',7902,'1980-12-17','800.00',NULL,20);
INSERT INTO emp VALUES (7499,'ALLEN','SALESMAN',7698,'1981-02-20','1600.00','300.00',30);
INSERT INTO emp VALUES (7521,'WARD','SALESMAN',7698,'1981-02-22','1250.00','500.00',30);
INSERT INTO emp VALUES (7566,'JONES','MANAGER',7839,'1981-04-02','2975.00',NULL,20);
INSERT INTO emp VALUES (7654,'MARTIN','SALESMAN',7698,'1981-09-28','1250.00','1400.00',30);
INSERT INTO emp VALUES (7698,'BLAKE','MANAGER',7839,'1981-05-01','2850.00',NULL,30);
INSERT INTO emp VALUES (7782,'CLARK','MANAGER',7839,'1981-06-09','2450.00',NULL,10);
INSERT INTO emp VALUES (7788,'SCOTT','ANALYST',7566,'1982-12-09','3000.00',NULL,20);
INSERT INTO emp VALUES (7839,'KING','PRESIDENT',NULL,'1981-11-17','5000.00',NULL,10);
INSERT INTO emp VALUES (7844,'TURNER','SALESMAN',7698,'1981-09-08','1500.00','0.00',30);
INSERT INTO emp VALUES (7876,'ADAMS','CLERK',7788,'1983-01-12','1100.00',NULL,20);
INSERT INTO emp VALUES (7900,'JAMES','CLERK',7698,'1981-12-03','950.00',NULL,30);
INSERT INTO emp VALUES (7902,'FORD','ANALYST',7566,'1981-12-03','3000.00',NULL,20);
INSERT INTO emp VALUES (7934,'MILLER','CLERK',7782,'1982-01-23','1300.00',NULL,10);

SELECT * FROM emp;
SELECT DISTINCT job FROM emp;

SELECT DISTINCT SAL FROM EMP;

SELECT *FROM EMP;
SELECT EMPNO,ENAME AS EMPLOYEE_NAME, SAL AS SALARY, COMM AS COMMISIION FROM EMP;
select  EMPNO,SAL, SALARY * 12 AS ANNUAL_SALARY FROM EMP;
USE ecommerce_sales_db;

SELECT COUNT(*) AS total_rows
FROM ecommerce_sales_staging;

SELECT COUNT(*) AS missing_customer_ids
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NULL;
SELECT
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM ecommerce_sales_staging;
SELECT
    COUNT(DISTINCT `Customer ID`) AS Total_Unique_Customers
FROM ecommerce_sales_staging;

SELECT
    COUNT(DISTINCT StockCode) AS Total_Unique_Products
FROM ecommerce_sales_staging;

SELECT
    StockCode,
    COUNT(DISTINCT Description) AS Description_Count
FROM ecommerce_sales_staging
GROUP BY StockCode
HAVING COUNT(DISTINCT Description) > 1
ORDER BY Description_Count DESC
LIMIT 10;

SELECT
    StockCode,
    Description,
    COUNT(*) AS Transaction_Rows
FROM ecommerce_sales_staging
WHERE StockCode IN ('20685', '21955', '22344')
GROUP BY StockCode, Description
ORDER BY StockCode, Description;
USE ecommerce_sales_db;

CREATE TABLE ecommerce_products AS
SELECT DISTINCT
    StockCode,
    Description
FROM ecommerce_sales_staging;

SELECT COUNT(*) AS Total_Product_Description_Combinations
FROM ecommerce_products;
SELECT *
FROM ecommerce_products
LIMIT 10;

CREATE TABLE ecommerce_customers AS
SELECT DISTINCT
    `Customer ID`
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL;

SELECT COUNT(*) AS Total_Customers
FROM ecommerce_customers;

SELECT *
FROM ecommerce_customers
LIMIT 10;

SELECT
    s.Invoice,
    s.`Customer ID`,
    s.Country,
    s.Revenue
FROM ecommerce_sales_staging AS s
INNER JOIN ecommerce_customers AS c
    ON s.`Customer ID` = c.`Customer ID`
LIMIT 10;

SELECT
    s.Invoice,
    s.`Customer ID`,
    s.Country,
    s.Revenue,
    c.`Customer ID` AS Matched_Customer
FROM ecommerce_sales_staging AS s
LEFT JOIN ecommerce_customers AS c
    ON s.`Customer ID` = c.`Customer ID`
LIMIT 20;

SELECT COUNT(*) AS Sales_Without_Customer_ID
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NULL;

# What is the total sales revenue?
SELECT
    ROUND(SUM(Revenue), 2) AS Total_Sales_Revenue
FROM ecommerce_sales_staging;

#Which 10 products generate the most revenue?
SELECT
    StockCode,
    Description,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    SUM(Quantity) AS Total_Quantity_Sold
FROM ecommerce_sales_staging
GROUP BY StockCode, Description
ORDER BY Total_Revenue DESC
LIMIT 10;

#Which countries generate the most revenue?
SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM ecommerce_sales_staging
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 10;

# How does revenue change monthly?
SELECT
    YearMonth,
    ROUND(SUM(Revenue), 2) AS Monthly_Revenue
FROM ecommerce_sales_staging
GROUP BY YearMonth
ORDER BY YearMonth;

# Which 10 customers spend the most?
SELECT
    `Customer ID`,
    ROUND(SUM(Revenue), 2) AS Total_Spent,
    COUNT(DISTINCT Invoice) AS Total_Invoices
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`
ORDER BY Total_Spent DESC
LIMIT 10;


SELECT
    StockCode,
    Description,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM ecommerce_sales_staging
WHERE StockCode IN ('M', 'DOT', 'POST')
GROUP BY StockCode, Description
ORDER BY Total_Revenue DESC;

SELECT
    StockCode,
    Description,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    SUM(Quantity) AS Total_Quantity_Sold
FROM ecommerce_sales_staging
WHERE StockCode NOT IN ('M', 'DOT', 'POST')
GROUP BY StockCode, Description
ORDER BY Total_Revenue DESC
LIMIT 10;


SELECT
    YearMonth,
    ROUND(SUM(Revenue), 2) AS Monthly_Revenue
FROM ecommerce_sales_staging
GROUP BY YearMonth
ORDER BY Monthly_Revenue DESC
LIMIT 10;


SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(
        SUM(Revenue) * 100 /
        (SELECT SUM(Revenue)
         FROM ecommerce_sales_staging),
        2
    ) AS Revenue_Percentage
FROM ecommerce_sales_staging
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 10;


SELECT
    `Customer ID`,
    ROUND(SUM(Revenue), 2) AS Total_Spent,
    COUNT(DISTINCT Invoice) AS Total_Invoices,
    SUM(Quantity) AS Total_Quantity_Purchased
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`
ORDER BY Total_Spent DESC
LIMIT 10;

use ecommerce_sales_db


SELECT
    `Customer ID`,
    CAST(`Customer ID` AS DECIMAL(15,2)) AS Customer_ID_Check
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL
LIMIT 10;


SELECT COUNT(*) AS Non_Whole_Number_IDs
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL
  AND CAST(`Customer ID` AS DECIMAL(15,2))
      <> FLOOR(CAST(`Customer ID` AS DECIMAL(15,2)));


CREATE TABLE ecommerce_customers_clean AS
SELECT DISTINCT
    CAST(
        CAST(`Customer ID` AS UNSIGNED)
        AS CHAR(30)
    ) AS Customer_ID
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL;

SHOW TABLES LIKE 'ecommerce_customers_clean';
SELECT COUNT(*) AS Total_Customers
FROM ecommerce_customers_clean;

USE ecommerce_sales_db;

CREATE TABLE ecommerce_customers_clean AS
SELECT DISTINCT
    CAST(
        CAST(
            CAST(`Customer ID` AS DECIMAL(15,2))
            AS UNSIGNED
        ) AS CHAR(30)
    ) AS Customer_ID
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL;


SELECT COUNT(*) AS Total_Customers
FROM ecommerce_customers_clean;

   SELECT *
FROM ecommerce_customers_clean
LIMIT 10; 

SELECT
    s.Invoice,
    s.`Customer ID`,
    c.Customer_ID AS Clean_Customer_ID,
    s.Country,
    s.Revenue
FROM ecommerce_sales_staging AS s
INNER JOIN ecommerce_customers_clean AS c
    ON CAST(
        CAST(s.`Customer ID` AS DECIMAL(15,2))
        AS UNSIGNED
    ) = CAST(c.Customer_ID AS UNSIGNED)
LIMIT 10;

SELECT
    s.Invoice,
    s.`Customer ID`,
    s.Country,
    s.Revenue,
    c.Customer_ID AS Clean_Customer_ID
FROM ecommerce_sales_staging AS s
LEFT JOIN ecommerce_customers_clean AS c
    ON CAST(
        CAST(s.`Customer ID` AS DECIMAL(15,2))
        AS UNSIGNED
    ) = CAST(c.Customer_ID AS UNSIGNED)
WHERE s.`Customer ID` IS NULL
LIMIT 10;

SELECT
    COUNT(*) AS Sales_Without_Customer_ID
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NULL;


USE ecommerce_sales_db;

-- 1. Total Sales Revenue
SELECT
    ROUND(SUM(Revenue), 2) AS Total_Sales_Revenue
FROM ecommerce_sales_staging;


-- 2. Total Quantity Sold
SELECT
    SUM(Quantity) AS Total_Quantity_Sold
FROM ecommerce_sales_staging;


-- 3. Total Number of Transactions (Rows)
SELECT
    COUNT(*) AS Total_Transaction_Rows
FROM ecommerce_sales_staging;


-- 4. Top 10 Products by Revenue
SELECT
    StockCode,
    Description,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM ecommerce_sales_staging
GROUP BY StockCode, Description
ORDER BY Total_Revenue DESC
LIMIT 10;


-- 5. Revenue by Country
SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM ecommerce_sales_staging
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 10;


-- 6. Monthly Revenue Trend
SELECT
    YearMonth,
    ROUND(SUM(Revenue), 2) AS Monthly_Revenue
FROM ecommerce_sales_staging
GROUP BY YearMonth
ORDER BY YearMonth;


-- 7. Top 10 Customers by Revenue
SELECT
    `Customer ID`,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM ecommerce_sales_staging
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`
ORDER BY Total_Revenue DESC
LIMIT 10;


-- 8. Revenue by Year
SELECT
    YEAR(InvoiceDate) AS Sales_Year,
    ROUND(SUM(Revenue), 2) AS Annual_Revenue
FROM ecommerce_sales_staging
GROUP BY YEAR(InvoiceDate)
ORDER BY Sales_Year;
