-- ============================================
-- View:    gold_inventory_risk
-- Layer:   Gold
-- Purpose: Calculates the inventory risk
-- Dependencies: gild_daily_sales
-- ============================================

IF OBJECT_ID('gold_inventory_risk', 'V') IS NOT NULL
    DROP VIEW gold_inventory_risk;
GO

CREATE VIEW gold_inventory_risk AS
SELECT
    store_nbr,
    product_family,
    SUM(sales) AS total_sales_28d,
    AVG(sales) AS avg_daily_sales,
    AVG(sales) * 7 AS weekly_demand_forecast,
    CASE
        WHEN AVG(sales) * 7 > 500 THEN 'HIGH RISK'
        WHEN AVG(sales) * 7 > 200 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS reorder_risk_level
    FROM gold_daily_sales
WHERE date >= DATEADD(day, -28, (SELECT MAX(date) FROM gold_daily_sales))
GROUP BY store_nbr, product_family;