-- =====================================================
-- Retail Sales Analysis Project
-- Dataset: Sample Superstore
-- Tool: MySQL Workbench
-- Author: Diya Rawade
-- =====================================================

USE ecommerce_project;
-- =====================================================
-- SECTION 1: OVERVIEW ANALYSIS
-- =====================================================


-- Query 1: Total Sales

SELECT
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales;


-- Query 2: Total Profit

SELECT
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales;


-- Query 3: Total Orders

SELECT
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM sales;
-- =====================================================
-- SECTION 2: REGIONAL ANALYSIS
-- =====================================================


-- Query 4: Sales by Region

SELECT
    `Region`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY `Region`
ORDER BY total_sales DESC;


-- Query 5: Loss-Making States

SELECT
    `State`,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `State`
HAVING SUM(Profit) < 0
ORDER BY total_profit;
-- =====================================================
-- SECTION 3: CATEGORY ANALYSIS
-- =====================================================


-- Query 6: Sales and Profit by Category

SELECT
    `Category`,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Category`
ORDER BY total_sales DESC;


-- Query 7: Technology Category Sales

SELECT
    ROUND(SUM(Sales), 2) AS technology_sales
FROM sales
WHERE `Category` = 'Technology';


-- Query 8: Technology Sales in West Region

SELECT
    ROUND(SUM(Sales), 2) AS west_technology_sales
FROM sales
WHERE `Category` = 'Technology'
  AND `Region` = 'West';


-- Query 9: Technology and Furniture Combined Sales

SELECT
    ROUND(SUM(Sales), 2) AS tech_furniture_sales
FROM sales
WHERE `Category` = 'Technology'
   OR `Category` = 'Furniture';
   -- =====================================================
-- SECTION 4: CUSTOMER ANALYSIS
-- =====================================================


-- Query 10: Top 10 Customers by Sales

SELECT
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;


-- Query 11: Top 10 Customers by Profit

SELECT
    `Customer Name`,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Customer Name`
ORDER BY total_profit DESC
LIMIT 10;


-- Query 12: Customers with Total Sales Greater Than 10000

SELECT
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY `Customer Name`
HAVING SUM(Sales) > 10000
ORDER BY total_sales DESC;


-- Query 13: Top Profitable Customers Using CTE

WITH customer_profit AS
(
    SELECT
        `Customer Name`,
        ROUND(SUM(Profit), 2) AS total_profit
    FROM sales
    GROUP BY `Customer Name`
)

SELECT *
FROM customer_profit
ORDER BY total_profit DESC
LIMIT 10;


-- Query 14: Customer Profit Ranking Using RANK()

WITH customer_profit AS
(
    SELECT
        `Customer Name`,
        ROUND(SUM(Profit), 2) AS total_profit
    FROM sales
    GROUP BY `Customer Name`
)

SELECT
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank,
    `Customer Name`,
    total_profit
FROM customer_profit
LIMIT 10;
-- =====================================================
-- SECTION 5: PRODUCT ANALYSIS
-- =====================================================


-- Query 15: Top 10 Products by Sales

SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 10;


-- Query 16: Top 10 Products by Profit

SELECT
    `Product Name`,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 10;


-- Query 17: Average Product Sales (Subquery)

SELECT ROUND(AVG(product_sales),2) AS avg_product_sales
FROM
(
    SELECT SUM(Sales) AS product_sales
    FROM sales
    GROUP BY `Product Name`
) AS product_totals;


-- Query 18: Products with Sales Above Average (Subquery)

SELECT
    `Product Name`,
    ROUND(SUM(Sales),2) AS total_sales
FROM sales
GROUP BY `Product Name`
HAVING SUM(Sales) >
(
    SELECT AVG(product_sales)
    FROM
    (
        SELECT SUM(Sales) AS product_sales
        FROM sales
        GROUP BY `Product Name`
    ) AS product_totals
)
ORDER BY total_sales DESC;


-- Query 19: Product Profit Classification Using CASE WHEN

SELECT
    `Product Name`,
    ROUND(SUM(Profit),2) AS total_profit,
    CASE
        WHEN SUM(Profit) > 5000 THEN 'High Profit'
        WHEN SUM(Profit) > 1000 THEN 'Medium Profit'
        WHEN SUM(Profit) > 0 THEN 'Low Profit'
        ELSE 'Loss Making'
    END AS profit_category
FROM sales
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 15;
-- =====================================================
-- SECTION 6: ADVANCED SQL & WINDOW FUNCTIONS
-- =====================================================


-- Query 20: Customer Profit Ranking Using ROW_NUMBER()

WITH customer_profit AS
(
    SELECT
        `Customer Name`,
        ROUND(SUM(Profit), 2) AS total_profit
    FROM sales
    GROUP BY `Customer Name`
)

SELECT
    ROW_NUMBER() OVER (ORDER BY total_profit DESC) AS row_num,
    `Customer Name`,
    total_profit
FROM customer_profit
LIMIT 10;


-- Query 21: Monthly Sales Trend Analysis

SELECT
    MONTH(`Order Date`) AS month_number,
    ROUND(SUM(Sales), 2) AS monthly_sales
FROM sales
GROUP BY MONTH(`Order Date`)
ORDER BY month_number;


-- Query 22: Monthly Profit Trend Analysis

SELECT
    MONTH(`Order Date`) AS month_number,
    ROUND(SUM(Profit), 2) AS monthly_profit
FROM sales
GROUP BY MONTH(`Order Date`)
ORDER BY month_number;