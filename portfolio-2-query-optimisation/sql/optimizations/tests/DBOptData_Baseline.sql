
-- 1 ROLE:
INSERT INTO public.role (
    name, 
    can_operate_till
) VALUES ('cashier', true);

-- 1 STAFF:
INSERT INTO public.staff (
    staff_code, 
    email, 
    first_name, 
    last_name, 
    role_id
) 
SELECT 
    'CASHIER', 
    'benchmark@example.test', 
    'Benchmark', 
    'Cashier', 
    id
FROM public.role 
WHERE name = 'cashier';

-- 1 TERMINAL:
INSERT INTO public.terminal (
    terminal_code, 
    name
) VALUES ('TERMINAL', 'terminal');

-- 1 TAX AND DISCOUNT:
INSERT INTO public.tax (
    name, 
    percentage
) VALUES ('tax', 5);

-- 1 DISCOUNT:
INSERT INTO public.discount (
    name, 
    percentage
) VALUES ('discount', 10);

-- 10 PRODUCTS:
INSERT INTO public.product (
    sku, 
    name, 
    unit_price, 
    stock_qty, 
    reorder_level
)
SELECT 
    'BENCH-' || g, 
    'product ' || g, 
    10 + g, 
    g % 20, 
    5
FROM generate_series(1, 10) AS g;
