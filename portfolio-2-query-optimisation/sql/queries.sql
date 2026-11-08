BEGIN;

-- Q1: Sales Report
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
    (($1 IS NULL) OR (sale.sold_at >= $1::timestamptz)) 
    AND 
    (($2 IS NULL) OR (sale.sold_at < $2::timestamptz))
GROUP BY sale.id, tm.id, sf.id;

-- Q2: Total Revenue for a Period
SELECT
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
    (($1 IS NULL) OR (sale.sold_at >= $1::timestamptz)) 
    AND 
    (($2 IS NULL) OR (sale.sold_at < $2::timestamptz));

-- Q3: Revenue by Payment Method
SELECT 
    sale.payment_method                         AS payment_method,
    SUM((si.unit_price_at_sale) * 
     (1-(si.discount_percentage_at_sale/100)) * 
     (si.paid_qty)
    )                                           AS amount_paid,
    SUM((si.unit_price_at_sale) * 
     (si.giveaway_qty)
    )                                           AS amount_gifted
FROM public.sale AS sale 
    INNER JOIN public.sale_item AS si ON si.sale_id = sale.id
WHERE 
    (($1 IS NULL) OR (sale.sold_at >= $1::timestamptz)) 
    AND 
    (($2 IS NULL) OR (sale.sold_at < $2::timestamptz))
GROUP BY sale.payment_method;

-- Q4: Low-stock report
SELECT 
    prod.sku            AS item,
    prod.name           AS name,
    prod.stock_qty      AS stock_qty,
    prod.reorder_level  AS mim_qty
FROM public.product AS prod
WHERE prod.stock_qty <= prod.reorder_level;

END;