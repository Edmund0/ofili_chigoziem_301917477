-- POSITIVE TESTS:

-- 1. Preserve historical rates when current rates change
BEGIN;

-- update the current tax rate
UPDATE public.tax
SET percentage = 7.00
WHERE name = 'GST05'
RETURNING *;

-- update the current discount rate
UPDATE public.discount
SET percentage = 20.00
WHERE name = 'RicePromotion2025'
RETURNING *;

-- compare current rates with saved percentages
SELECT
    t.percentage AS current_tax_percentage,
    si.tax_percentage_at_sale,
    d.percentage AS current_discount_percentage,
    si.discount_percentage_at_sale
FROM public.sale_item AS si
    JOIN public.sale        AS s ON s.id = si.sale_id
    JOIN public.product     AS p ON p.id = si.product_id
    JOIN public.tax         AS t ON t.id = si.tax_id
    JOIN public.discount    AS d ON d.id = si.discount_id
WHERE s.receipt_number = 'R-101' AND p.sku = 'RICE';

ROLLBACK;

-- 2. Save a sale with two paid Beans and one giveaway
BEGIN;

-- check and lock stock before the sale
SELECT 
    sku, 
    stock_qty
FROM public.product
WHERE sku = 'BEANS'
FOR UPDATE;

-- record the sale
INSERT INTO public.sale (
    receipt_number, 
    shift_id, 
    sold_at, 
    payment_method
)
VALUES ('TEST-SALE-001',
        (SELECT id FROM public.shift
         WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T01')
           AND closed_at IS NULL),
        '2026-11-01 11:00+00', 'cash');

-- add the paid and giveaway items
INSERT INTO public.sale_item (
    sale_id, 
    product_id, 
    unit_price_at_sale, 
    paid_qty, 
    giveaway_qty,
    giveaway_reason, 
    tax_percentage_at_sale
)
VALUES ((SELECT id FROM public.sale WHERE receipt_number = 'TEST-SALE-001'),
        (SELECT id FROM public.product WHERE sku = 'BEANS'),
        (SELECT unit_price FROM public.product WHERE sku = 'BEANS'),
        2, 1, 'Buy 2, get 1 free', 0.00);

-- reduce stock by the paid and giveaway quantities
UPDATE public.product
SET stock_qty = stock_qty - 3
WHERE sku = 'BEANS'
RETURNING sku, stock_qty;

-- save the sale and stock changes
COMMIT;

-- view the saved quantities and amount charged
SELECT 
    unit_price_at_sale, 
    paid_qty, 
    giveaway_qty,
    paid_qty * unit_price_at_sale AS amount_charged
FROM public.sale_item
WHERE sale_id = (SELECT id FROM public.sale WHERE receipt_number = 'TEST-SALE-001');
