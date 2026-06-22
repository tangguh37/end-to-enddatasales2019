CREATE TABLE IF NOT EXISTS sales (
    id               BIGSERIAL PRIMARY KEY,
    order_id         BIGINT NOT NULL,
    product          VARCHAR(255) NOT NULL,
    quantity_ordered INTEGER NOT NULL,
    price_each       DECIMAL(10,2) NOT NULL,
    order_date       TIMESTAMP NOT NULL,
    purchase_address VARCHAR(500) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_sales_order_date ON sales (order_date);
CREATE INDEX IF NOT EXISTS idx_sales_product ON sales (product);

COMMENT ON TABLE sales IS 'Electronics store sales data (2019) - source for Streamkap CDC';
COMMENT ON COLUMN sales.id IS 'Auto-incrementing primary key';
COMMENT ON COLUMN sales.order_id IS 'Order identifier (non-unique, multiple products per order)';
COMMENT ON COLUMN sales.product IS 'Product name';
COMMENT ON COLUMN sales.quantity_ordered IS 'Quantity purchased';
COMMENT ON COLUMN sales.price_each IS 'Unit price in USD';
COMMENT ON COLUMN sales.order_date IS 'Order timestamp';
COMMENT ON COLUMN sales.purchase_address IS 'Customer delivery address';
