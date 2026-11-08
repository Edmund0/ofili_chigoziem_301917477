-- SQL QUERIES:
-- EXECUTE takes a start date (inclusive) and end date (exclusive); NULL leaves a bound open.

BEGIN;

-- Q4: LOW-STOCK REPORT:
-- Lists products at or below their reorder level.
SELECT 
    prod.sku            AS item,
    prod.name           AS name,
    prod.stock_qty      AS stock_qty,
    prod.reorder_level  AS reorder_level
FROM public.product AS prod
WHERE prod.stock_qty <= prod.reorder_level;

END;