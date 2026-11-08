-- SQL QUERIES:
-- EXECUTE takes a start date (inclusive) and end date (exclusive); NULL leaves a bound open.

BEGIN;

-- Q2: TOTAL REVENUE FOR A PERIOD:
-- Totals revenue after discounts, excluding tax.
PREPARE period_revenue (TIMESTAMPTZ, TIMESTAMPTZ) AS
SELECT
    COALESCE(SUM((si.unit_price_at_sale) * 
     (1-(si.discount_percentage_at_sale/100)) * 
     (si.paid_qty)
    ), 0)                                       AS amount_revenue,
    COALESCE(SUM((si.unit_price_at_sale) * 
     (si.giveaway_qty)
    ), 0)                                       AS amount_gifted
FROM public.sale AS sale
    INNER JOIN public.sale_item AS si ON si.sale_id = sale.id
WHERE 
    sale.sold_at >= COALESCE($1, '-infinity'::timestamptz)
    AND 
    sale.sold_at < COALESCE($2, 'infinity'::timestamptz);

END;