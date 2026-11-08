-- SQL QUERIES:
-- EXECUTE takes a start date (inclusive) and end date (exclusive); NULL leaves a bound open.

BEGIN;

-- Q3: REVENUE BY PAYMENT METHOD:
-- Groups revenue and giveaway value by payment method.
PREPARE revenue_by_payment (TIMESTAMPTZ, TIMESTAMPTZ) AS
SELECT 
    sale.payment_method                         AS payment_method,
    SUM((si.unit_price_at_sale) * 
     (1-(si.discount_percentage_at_sale/100)) * 
     (si.paid_qty)
    )                                           AS amount_revenue,
    SUM((si.unit_price_at_sale) * 
     (si.giveaway_qty)
    )                                           AS amount_gifted
FROM public.sale AS sale 
    INNER JOIN public.sale_item AS si ON si.sale_id = sale.id
WHERE 
    sale.sold_at >= COALESCE($1, '-infinity'::timestamptz)
    AND 
    sale.sold_at < COALESCE($2, 'infinity'::timestamptz)
GROUP BY sale.payment_method;

END;