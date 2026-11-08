-- SQL QUERIES:
-- EXECUTE takes a start date (inclusive) and end date (exclusive); NULL leaves a bound open.

BEGIN;

-- Q1: SALES REPORT:
-- Shows each sale, including tax paid and giveaway value.
PREPARE sales_report (TIMESTAMPTZ, TIMESTAMPTZ) AS
SELECT 
    sale.id                                     AS sale,
    sale.receipt_number                         AS receipt_number,
    sale.shift_id                               AS shift,
    sf.staff_code                               AS staff,
    tm.terminal_code                            AS terminal,
    sale.sold_at                                AS sold_at,
    sale.payment_method                         AS payment_method,
    SUM((si.unit_price_at_sale) * 
     (1-(si.discount_percentage_at_sale/100)) * 
     (1+(si.tax_percentage_at_sale/100)) * 
     (si.paid_qty)
    )                                           AS amount_paid,
    SUM((si.unit_price_at_sale) * 
     (si.giveaway_qty)
    )                                           AS amount_gifted
FROM public.sale AS sale 
    INNER JOIN public.shift     AS sh ON sh.id = sale.shift_id
    INNER JOIN public.staff     AS sf ON sf.id = sh.staff_id
    INNER JOIN public.terminal  AS tm ON tm.id = sh.terminal_id
    INNER JOIN public.sale_item AS si ON si.sale_id = sale.id
WHERE 
    sale.sold_at >= COALESCE($1, '-infinity'::timestamptz)
    AND sale.sold_at < COALESCE($2, 'infinity'::timestamptz)
GROUP BY sale.id, tm.id, sf.id;

END;