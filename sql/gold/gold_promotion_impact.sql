-- ============================================
-- View:    gold_promotion_impact
-- Layer:   Gold
-- Purpose: Calculates the impact of the promotion
-- Dependencies: gold_inventory_risk
-- Last updated: 2026-03-13
-- ============================================

-- Drop the view if it already exists, then recreate it
IF OBJECT_ID('gold_promotion_impact', 'V') IS NOT NULL
    DROP VIEW gold_promotion_impact;
GO

CREATE VIEW gold_promotion_impact AS
SELECT
    product_family,
    
    -- Sales when on promotion
    AVG(CASE WHEN onpromotion = 1 THEN sales END) AS avg_sales_on_promo,
    
    -- Sales when not on promotion  
    AVG(CASE WHEN onpromotion = 0 THEN sales END) AS avg_sales_off_promo,
    
    -- How many days was each product on promotion
    SUM(CASE WHEN onpromotion = 1 THEN 1 ELSE 0 END) AS promo_days,
    SUM(CASE WHEN onpromotion = 0 THEN 1 ELSE 0 END) AS non_promo_days,
    
    -- Uplift: how much more did it sell on promo vs off promo
    ROUND(
        (AVG(CASE WHEN onpromotion = 1 THEN sales END) - 
         AVG(CASE WHEN onpromotion = 0 THEN sales END)) 
        / NULLIF(AVG(CASE WHEN onpromotion = 0 THEN sales END), 0) 
        * 100, 
    2) AS promo_uplift_pct

FROM gold_daily_sales
GROUP BY product_family;