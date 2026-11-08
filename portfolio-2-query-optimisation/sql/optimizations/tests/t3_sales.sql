

-- 100 DAILY SHIFTS:
INSERT INTO public.shift (
    staff_id, terminal_id, 
    opened_at, 
    closed_at
)
SELECT
    1, 1,
    TIMESTAMPTZ '2000-01-01 08:00:00+00' + g * INTERVAL '1 day',
    TIMESTAMPTZ '2000-01-01 16:00:00+00' + g * INTERVAL '1 day'
FROM generate_series(0, 99) AS g;

-- 100 SALES PER SHIFT:
INSERT INTO public.sale (
    receipt_number,
    shift_id,
    sold_at,
    payment_method
)
SELECT
    'BENCH-' || sh.id || '-' || g,
    sh.id,
    sh.opened_at + g * INTERVAL '1 minute',
    'cash'
FROM public.shift AS sh
CROSS JOIN generate_series(1, 100) AS g;

-- 2 ITEMS PER SALE:
INSERT INTO public.sale_item (
    sale_id,
    product_id,
    unit_price_at_sale,
    paid_qty,
    tax_id,
    tax_percentage_at_sale,
    discount_id,
    discount_percentage_at_sale
)
SELECT
    s.id,
    p.id,
    p.unit_price,
    1,
    1,
    5,
    1,
    10
FROM public.sale AS s
CROSS JOIN public.product AS p
WHERE p.sku IN ('BENCH-1', 'BENCH-2');
