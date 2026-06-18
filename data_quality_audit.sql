-- ============================================================================
-- 1. DATABASE SCHEMA SETUP & MESST INGESTION SIMULATION
-- ============================================================================

CREATE TABLE raw_ingested_transactions (
    transaction_id INT,
    order_date VARCHAR(50),
    product_category VARCHAR(50),
    revenue DECIMAL(10, 2),
    shipping_status VARCHAR(50)
);

-- Insert realistic "dirty" enterprise corporate logs
INSERT INTO raw_ingested_transactions VALUES 
(1001, '2026-01-15', 'Technology', 1500.00, 'Delivered'),
(1002, '2026-01-16', 'Furniture', -50.00, 'Shipped'),      -- ERROR: Negative Revenue!
(NULL, '2026-01-16', 'Office Supplies', 45.00, 'Delivered'), -- ERROR: Missing Primary Key!
(1004, 'Invalid_Date_Format', 'Technology', 300.00, 'Pending'), -- ERROR: Corrupted Date!
(1005, '2026-01-17', '  tech  ', 850.00, 'Delivered');       -- ANOMALY: Whitespace formatting error.

-- ============================================================================
-- 2. THE EXCEPTION AUDIT LAYER (Diagnostic Log View)
-- ============================================================================
-- This view functions as an automated health check to surface pipeline failures.
CREATE VIEW v_data_quality_exception_report AS
SELECT 
    transaction_id,
    order_date,
    product_category,
    revenue,
    CASE 
        WHEN transaction_id IS NULL THEN 'FAIL: Missing Transaction ID (Primary Key Violation)'
        WHEN revenue <= 0 THEN 'FAIL: Negative or Zero Revenue Flagged'
        WHEN order_date NOT LIKE '2026-%' THEN 'FAIL: Corrupted or Invalid ISO Date Format'
        ELSE 'PASS'
    END AS data_quality_status
FROM raw_ingested_transactions;

-- ============================================================================
-- 3. THE CLEAN PRODUCTION LAYER (Tableau/Power BI Ingestion View)
-- ============================================================================
-- Filters out corrupted rows into quarantine and formats the rest perfectly.
CREATE VIEW v_clean_production_transactions AS
SELECT 
    transaction_id,
    CAST(order_date AS DATE) AS standardized_order_date,
    TRIM(UPPER(product_category)) AS polished_product_category,
    revenue
FROM raw_ingested_transactions
WHERE transaction_id IS NOT NULL 
  AND revenue > 0 
  AND order_date LIKE '2026-%';
