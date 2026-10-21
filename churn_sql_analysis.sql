-- =====================================================================
-- Customer Churn Analysis - MySQL Queries & Results
-- Database : churndb
-- Table    : customer_churn  (loaded from Python using df.to_sql())
-- Tool     : MySQL 8.0 Command Line Client
-- =====================================================================


-- ---------------------------------------------------------------------
-- DATABASE SETUP
-- ---------------------------------------------------------------------
SHOW DATABASES;
-- Output (before): demo, information_schema, mysql, performance_schema,
--                  sakila, sys, world   (7 rows)

CREATE DATABASE churndb;
-- Output: Query OK, 1 row affected

USE churndb;
-- Output: Database changed

-- (Table is created and filled from Python: df.to_sql("customer_churn", ...))
SHOW TABLES;
-- +-----------------+
-- | Tables_in_churndb |
-- +-----------------+
-- | customer_churn  |
-- +-----------------+
-- 1 row in set


-- ---------------------------------------------------------------------
-- VIEW ALL DATA
-- ---------------------------------------------------------------------
SELECT * FROM customer_churn;
-- Output: 486 rows in set


-- ---------------------------------------------------------------------
-- 1. Total Customers
-- ---------------------------------------------------------------------
SELECT COUNT(*)
FROM customer_churn;
-- Output:
-- +----------+
-- | count(*) |
-- +----------+
-- |      486 |
-- +----------+


-- ---------------------------------------------------------------------
-- 2. Total Churn Customers
-- ---------------------------------------------------------------------
SELECT COUNT(*)
FROM customer_churn
WHERE Churn = 'Yes';
-- Output:
-- +----------+
-- | count(*) |
-- +----------+
-- |      115 |
-- +----------+


-- ---------------------------------------------------------------------
-- 3. Churn Rate (%)
-- ---------------------------------------------------------------------
SELECT
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100 /
        COUNT(*), 2)
    AS Churn_Rate
FROM customer_churn;
-- Output:
-- +------------+
-- | Churn_Rate |
-- +------------+
-- |      23.66 |
-- +------------+


-- ---------------------------------------------------------------------
-- 4. Average Monthly Charges
-- ---------------------------------------------------------------------
SELECT AVG(Monthly_Charges)
FROM customer_churn;
-- Output:
-- +----------------------+
-- | AVG(Monthly_Charges) |
-- +----------------------+
-- |      1359.7714403292184 |
-- +----------------------+


-- ---------------------------------------------------------------------
-- 5. Average Tenure
-- ---------------------------------------------------------------------
SELECT AVG(Tenure_Months)
FROM customer_churn;
-- Output:
-- +---------------------+
-- | AVG(Tenure_Months)  |
-- +---------------------+
-- |  35.95426195426196  |
-- +---------------------+


-- ---------------------------------------------------------------------
-- 6. Customers by Contract Type
-- ---------------------------------------------------------------------
SELECT Contract_Type,
       COUNT(*) AS Customers
FROM customer_churn
GROUP BY Contract_Type;
-- Output:
-- +----------------+-----------+
-- | Contract_Type  | Customers |
-- +----------------+-----------+
-- | One Year       |       155 |
-- | Month-To-Month |       179 |
-- | Two Year       |       150 |
-- | NULL           |         2 |
-- +----------------+-----------+
-- 4 rows in set


-- ---------------------------------------------------------------------
-- 7. Customers by Internet Service
-- ---------------------------------------------------------------------
SELECT Internet_Service,
       COUNT(*)
FROM customer_churn
GROUP BY Internet_Service;
-- Output:
-- +------------------+----------+
-- | Internet_Service | COUNT(*) |
-- +------------------+----------+
-- | Fiber            |      130 |
-- | 5G               |      116 |
-- | Cable            |      116 |
-- | DSL              |      118 |
-- | NULL             |        6 |
-- +------------------+----------+
-- 5 rows in set


-- ---------------------------------------------------------------------
-- 8. Churn by State
-- ---------------------------------------------------------------------
SELECT State,
       COUNT(*)
FROM customer_churn
WHERE Churn = 'Yes'
GROUP BY State
ORDER BY 2 DESC;
-- Output:
-- +-------------+----------+
-- | State       | COUNT(*) |
-- +-------------+----------+
-- | Up          |       28 |
-- | Delhi       |       24 |
-- | Karnataka   |       24 |
-- | Gujarat     |       24 |
-- | Maharashtra |       15 |
-- +-------------+----------+
-- 5 rows in set


-- ---------------------------------------------------------------------
-- 9. Payment Method Wise Customers
-- ---------------------------------------------------------------------
SELECT Payment_Method,
       COUNT(*)
FROM customer_churn
GROUP BY Payment_Method;
-- Output:
-- +----------------+----------+
-- | Payment_Method | COUNT(*) |
-- +----------------+----------+
-- | UPI            |      100 |
-- | Debit Card     |       96 |
-- | Cash           |       92 |
-- | Unknown        |       14 |
-- | Credit Card    |       93 |
-- | Net Banking    |       91 |
-- +----------------+----------+
-- 6 rows in set


-- ---------------------------------------------------------------------
-- 10. Subscription Type Wise Customers
-- ---------------------------------------------------------------------
SELECT Subscription_Type,
       COUNT(*)
FROM customer_churn
GROUP BY Subscription_Type;
-- Output:
-- +-------------------+----------+
-- | Subscription_Type | COUNT(*) |
-- +-------------------+----------+
-- | Basic             |      150 |
-- | Premium           |      169 |
-- | Standard          |      161 |
-- | NULL              |        6 |
-- +-------------------+----------+
-- 4 rows in set


-- ---------------------------------------------------------------------
-- 11. Highest Revenue States
-- ---------------------------------------------------------------------
SELECT State,
       SUM(Total_Charges) AS State_Charges
FROM customer_churn
GROUP BY State
ORDER BY 2 DESC;
-- Output:
-- +-------------+--------------------+
-- | State       | State_Charges      |
-- +-------------+--------------------+
-- | Delhi       |         5309197.38 |
-- | Up          |   4935339.700000001 |
-- | Gujarat     |   4931674.679999998 |
-- | Karnataka   |         4695955.54 |
-- | Maharashtra |   4045118.639999999 |
-- | NULL        |  418406.83999999997 |
-- +-------------+--------------------+
-- 6 rows in set


-- ---------------------------------------------------------------------
-- 12. Average Charges by Contract
-- ---------------------------------------------------------------------
SELECT Contract_Type,
       AVG(Monthly_Charges)
FROM customer_churn
GROUP BY Contract_Type;
-- Output: (run this query and paste the result here)


-- ---------------------------------------------------------------------
-- 13. Senior Citizens Churn
-- ---------------------------------------------------------------------
SELECT Senior_Flag,
       COUNT(*)
FROM customer_churn
WHERE Churn = 'Yes'
GROUP BY Senior_Flag;
-- Output: (run this query and paste the result here)
-- Note: the column created in Python is Senior_Flag (values: Senior / Adult)


-- ---------------------------------------------------------------------
-- 14. Top 10 High Value Customers
-- ---------------------------------------------------------------------
SELECT Customer_Name,
       Customer_Value
FROM customer_churn
ORDER BY Customer_Value DESC
LIMIT 10;
-- Output:
-- +---------------+--------------------+
-- | Customer_Name | Customer_Value     |
-- +---------------+--------------------+
-- | Anjali Mehta  |          171658.83 |
-- | Priya Gupta   |          164738.93 |
-- | Amit Sharma   | 164458.13999999998 |
-- | Neha Verma    |          159925.12 |
-- | Amit Sharma   |          158551.52 |
-- | Mohit Arora   |          157703.26 |
-- | Rahul Singh   |          157621.12 |
-- | Vikas Yadav   |          154889.82 |
-- | Mohit Arora   |          154598.22 |
-- | Mohit Arora   |             153188 |
-- +---------------+--------------------+
-- 10 rows in set (0.01 sec)


-- ---------------------------------------------------------------------
-- 15. Customers Without Tech Support
-- ---------------------------------------------------------------------
SELECT *
FROM customer_churn
WHERE Tech_Support = 'No';
-- Output (first row, truncated):
-- Customer_ID: C1002 | Customer_Name: Pooja Singh | Gender: Female | Age: 42
-- State: Up | City: Kanpur | Tenure_Months: 13 | Subscription_Type: Basic
-- Monthly_Charges: 555.03 | Churn: Yes | Last_Interaction_Date: 2025-08-10 12:00:00
-- Customer_Value: 7215.39 | Tenure_Group: 13-24 | Senior_Flag: Adult | Churn_Flag: 1
