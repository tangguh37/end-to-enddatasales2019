-- Load CSV into sales table
-- Skips bogus header-as-data rows (where Order ID = 'Order ID')
-- Usage: psql $NEON_DATABASE_URL -f seed.sql

\COPY sales(order_id, product, quantity_ordered, price_each, order_date, purchase_address)
FROM 'data/all_data.csv'
DELIMITER ','
CSV HEADER;

-- Remove bogus rows where the CSV had duplicate headers as data
DELETE FROM sales WHERE order_id IS NULL OR order_id::TEXT = 'Order ID';

-- Verify
SELECT COUNT(*) AS total_rows FROM sales;
SELECT MIN(order_date) AS date_from, MAX(order_date) AS date_to FROM sales;
SELECT COUNT(DISTINCT product) AS unique_products FROM sales;
