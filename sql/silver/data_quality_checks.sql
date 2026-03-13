-- ============================================
-- File:    data_quality_checks.sql
-- Layer:   Silver
-- Purpose: Validation queries run after Silver
--          transformations to confirm data quality
-- ============================================

---- Check 1: Confirm no negative sales remain
SELECT COUNT(*) AS negative_sales_count
FROM Silver_sales
WHERE sales < 0;
--Result: 0

-- Check 2: Confirm no duplicate grain records
SELECT date, store_nbr, family, COUNT(*) AS row_count
FROM Silver_sales
GROUP BY date, store_nbr, family
HAVING COUNT(*) > 1;
-- Result: 0 rows returned

-- Check 3: Confirm date column is properly typed
SELECT MIN(date) AS earliest_date, MAX(date) AS latest_date
FROM Silver_sales;
-- Result: 2013-01-01 to 2017-08-15

-- Check 4: Confirm store count matches source
SELECT COUNT(DISTINCT store_nbr) AS store_count
FROM silver_store;
-- Result: 54
