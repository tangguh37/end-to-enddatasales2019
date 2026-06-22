-- Run in MotherDuck after Streamkap is streaming data
-- These views power the Power BI dashboards

USE DATABASE sales_analytics;
USE SCHEMA analytics;

-- Monthly sales summary
CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(DISTINCT order_id)        AS total_orders,
    SUM(quantity_ordered)           AS total_quantity,
    ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM streamkap.sales
GROUP BY month
ORDER BY month;

-- Top products by revenue
CREATE OR REPLACE VIEW v_top_products AS
SELECT
    product,
    COUNT(DISTINCT order_id)        AS times_ordered,
    SUM(quantity_ordered)           AS total_quantity,
    ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM streamkap.sales
GROUP BY product
ORDER BY total_revenue DESC;

-- Daily sales trend
CREATE OR REPLACE VIEW v_daily_sales AS
SELECT
    order_date::DATE                AS day,
    COUNT(DISTINCT order_id)        AS total_orders,
    SUM(quantity_ordered)           AS total_quantity,
    ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM streamkap.sales
GROUP BY day
ORDER BY day;

-- Sales by city (extracted from purchase_address)
CREATE OR REPLACE VIEW v_sales_by_city AS
SELECT
    SPLIT_PART(purchase_address, ', ', 2) AS city,
    SPLIT_PART(purchase_address, ', ', 3) AS state,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(quantity_ordered * price_each), 2) AS total_revenue
FROM streamkap.sales
GROUP BY city, state
ORDER BY total_revenue DESC;
