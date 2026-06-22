-- Run in MotherDuck SQL editor (app.motherduck.com)
-- Creates the database that Streamkap will write into

CREATE DATABASE IF NOT EXISTS sales_analytics;
USE DATABASE sales_analytics;

CREATE SCHEMA IF NOT EXISTS streamkap;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Verify database exists
SELECT current_database();
