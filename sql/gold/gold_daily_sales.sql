-- ============================================
-- View:    gold_daily_sales
-- Layer:   Gold
-- Purpose: Joins Silver sales with store context,
--          holiday flags, and oil price.
-- Dependencies: silver_sales, silver_stores,
--               silver_holidays, silver_oil
-- Last updated: 2026-03-13
-- ============================================

IF OBJECT_ID('gold_daily_sales', 'V') IS NOT NULL
    DROP VIEW gold_daily_sales;
GO

CREATE VIEW gold_daily_sales AS
SELECT
    s.date,
    s.store_nbr,
    st.city,
    st.state,
    st.type AS store_type,
    s.family AS product_family,
    s.sales,
    s.onpromotion,
    COALESCE(h.is_holiday, 0) AS is_holiday,
    o.oil_price
FROM silver_sales s
LEFT JOIN silver_stores st ON s.store_nbr = st.store_nbr
LEFT JOIN silver_holidays h ON s.date = h.date
LEFT JOIN silver_oil o ON s.date = o.date;


