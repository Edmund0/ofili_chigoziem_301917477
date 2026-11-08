-- SQL QUERIES:
-- EXECUTE low_stock takes no parameters.

BEGIN;

-- Q4: LOW-STOCK REPORT:
-- Lists products at or below their reorder level.
PREPARE low_stock AS
SELECT 
    prod.sku            AS item,
    prod.name           AS name,
    prod.stock_qty      AS stock_qty,
    prod.reorder_level  AS reorder_level
FROM public.product AS prod
WHERE prod.stock_qty <= prod.reorder_level;

END;
