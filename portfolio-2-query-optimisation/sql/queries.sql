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

EXECUTE sales_report(NULL, NULL);
DEALLOCATE sales_report;

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

EXECUTE period_revenue(NULL, NULL);
DEALLOCATE period_revenue;

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

EXECUTE revenue_by_payment(NULL, NULL);
DEALLOCATE revenue_by_payment;

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