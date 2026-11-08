-- NEGATIVE TESTS:

-- Count rows before the tests.
SELECT *
FROM (
    VALUES
        ('role',      (SELECT COUNT(*) FROM public.role)),
        ('staff',     (SELECT COUNT(*) FROM public.staff)),
        ('terminal',  (SELECT COUNT(*) FROM public.terminal)),
        ('shift',     (SELECT COUNT(*) FROM public.shift)),
        ('product',   (SELECT COUNT(*) FROM public.product)),
        ('tax',       (SELECT COUNT(*) FROM public.tax)),
        ('discount',  (SELECT COUNT(*) FROM public.discount)),
        ('sale',      (SELECT COUNT(*) FROM public.sale)),
        ('sale_item', (SELECT COUNT(*) FROM public.sale_item))
) AS counts(table_name, row_count);

-- 1. Product stock cannot be negative.
INSERT INTO public.product (
    sku, 
    name, 
    unit_price, 
    stock_qty, 
    reorder_level
)
VALUES ('TEST_STOCK', 'Test product', 100.00, -1, 5);

-- 2. T01 already has an open shift, so another one must be rejected.
INSERT INTO public.shift (
    staff_id, 
    terminal_id, 
    opened_at, 
    closed_at
)
VALUES ((SELECT id FROM public.staff WHERE staff_code = 'C002'),
        (SELECT id FROM public.terminal WHERE terminal_code = 'T01'),
        '2026-11-01 09:00+00', NULL);

-- 3. Both quantities cannot be zero 
INSERT INTO public.sale_item (
    sale_id, 
    product_id, 
    unit_price_at_sale, 
    paid_qty, 
    giveaway_qty,
    tax_percentage_at_sale
)
VALUES ((SELECT id FROM public.sale WHERE receipt_number = 'R-101'),
        (SELECT id FROM public.product WHERE sku = 'BEANS'),
        500.00, 0, 0, 0.00);

-- 4. Giving Beans away requires a reason.
INSERT INTO public.sale_item (
    sale_id, 
    product_id, 
    unit_price_at_sale, 
    paid_qty, 
    giveaway_qty,
    giveaway_reason, 
    tax_percentage_at_sale
)
VALUES ((SELECT id FROM public.sale WHERE receipt_number = 'R-101'),
        (SELECT id FROM public.product WHERE sku = 'BEANS'),
        500.00, 0, 1, NULL, 0.00);

-- 5. Rice is already on R-101, so another Rice item must be rejected.
INSERT INTO public.sale_item (
    sale_id, 
    product_id, 
    unit_price_at_sale, 
    paid_qty, 
    tax_percentage_at_sale
)
VALUES ((SELECT id FROM public.sale WHERE receipt_number = 'R-101'),
        (SELECT id FROM public.product WHERE sku = 'RICE'),
        1000.00, 1, 0.00);

-- Count rows after the tests; the counts must match.
SELECT *
FROM (
    VALUES
        ('role',      (SELECT COUNT(*) FROM public.role)),
        ('staff',     (SELECT COUNT(*) FROM public.staff)),
        ('terminal',  (SELECT COUNT(*) FROM public.terminal)),
        ('shift',     (SELECT COUNT(*) FROM public.shift)),
        ('product',   (SELECT COUNT(*) FROM public.product)),
        ('tax',       (SELECT COUNT(*) FROM public.tax)),
        ('discount',  (SELECT COUNT(*) FROM public.discount)),
        ('sale',      (SELECT COUNT(*) FROM public.sale)),
        ('sale_item', (SELECT COUNT(*) FROM public.sale_item))
) AS counts(table_name, row_count);
