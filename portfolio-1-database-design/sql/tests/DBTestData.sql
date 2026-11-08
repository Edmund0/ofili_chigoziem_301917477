-- TEST CASE FIXTURE:

SELECT current_database() AS database;
BEGIN;

-- 1. Creating Roles
INSERT INTO public.role (
    name,
    can_operate_till,
    can_manage_products,
    can_manage_staff,
    can_manage_terminals,
    can_view_reports
)
VALUES ('Cashier', true, false, false, false, false),
       ('Supervisor', true, true, true, true, true);

-- 2. Adding Staff; 2 Cashiers and 1 Supervisor
INSERT INTO public.staff (
    staff_code,
    email,
    first_name,
    last_name,
    role_id
)
VALUES ('C001', 'john.bishop@example.com', 'John', 'Bishop',
        (SELECT id FROM public.role WHERE name = 'Cashier')),
       ('C002', 'ngozi.etufugh@example.com', 'Ngozi', 'Etufugh',
        (SELECT id FROM public.role WHERE name = 'Cashier')),
       ('C003', 'ayomide.kuti@example.com', 'Ayomide', 'Kuti',
        (SELECT id FROM public.role WHERE name = 'Supervisor'));

-- 3. Adding Terminals
INSERT INTO public.terminal (
    terminal_code,
    name
)
VALUES ('T01', 'Main checkout'),
       ('T02', 'Second checkout');

-- 4. Adding Products
INSERT INTO public.product (
    sku,
    name,
    unit_price,
    stock_qty,
    reorder_level
)
VALUES ('RICE', 'Rice', 1000.00, 20, 5),
       ('SOAP', 'Soap', 200.00, 12, 10),
       ('BEANS', 'Beans', 500.00, 50, 5),
       ('GARRI', 'Garri', 60.00, 20, 5);

-- 5. Adding Taxes
INSERT INTO public.tax (
    name,
    percentage
)
VALUES ('VAT10', 10.00),
       ('GST05', 5.00);

-- 6. Adding Discounts
INSERT INTO public.discount (
    name,
    percentage
)
VALUES ('RicePromotion2025', 15.00),
       ('MiVAStudentSpecial', 50.00);

-- 7. Opening Shifts
INSERT INTO public.shift (
    staff_id,
    terminal_id,
    opened_at,
    closed_at
)
VALUES ((SELECT id FROM public.staff WHERE staff_code = 'C001'),
        (SELECT id FROM public.terminal WHERE terminal_code = 'T01'),
        '2026-11-01 08:00+00', NULL),
       ((SELECT id FROM public.staff WHERE staff_code = 'C002'),
        (SELECT id FROM public.terminal WHERE terminal_code = 'T02'),
        '2026-11-02 08:00+00', NULL);

-- 8. Recording Sales
INSERT INTO public.sale (
    receipt_number,
    shift_id,
    sold_at,
    payment_method
)
VALUES ('R-101',
        (SELECT id FROM public.shift
         WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T01')
           AND closed_at IS NULL),
        '2026-11-01 10:00+00', 'cash'),
       ('R-102',
        (SELECT id FROM public.shift
         WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T02')
           AND closed_at IS NULL),
        '2026-11-02 10:00+00', 'card');

-- 9. Adding Sale Items
-- Saved percentages describe the old receipts, not today's lookup rates.
INSERT INTO public.sale_item (
    sale_id,
    product_id,
    unit_price_at_sale,
    paid_qty,
    giveaway_qty,
    giveaway_reason,
    tax_id,
    tax_percentage_at_sale,
    discount_id,
    discount_percentage_at_sale
)
VALUES ((SELECT id FROM public.sale WHERE receipt_number = 'R-101'),
        (SELECT id FROM public.product WHERE sku = 'RICE'),
        1000.00, 2, 1, 'Buy 2, get 1 free',
        (SELECT id FROM public.tax WHERE name = 'GST05'), 5.00,
        (SELECT id FROM public.discount WHERE name = 'RicePromotion2025'), 10.00),
       ((SELECT id FROM public.sale WHERE receipt_number = 'R-101'),
        (SELECT id FROM public.product WHERE sku = 'SOAP'),
        200.00, 3, 0, NULL,
        DEFAULT, 0.00, DEFAULT, DEFAULT),
       ((SELECT id FROM public.sale WHERE receipt_number = 'R-102'),
        (SELECT id FROM public.product WHERE sku = 'RICE'),
        1000.00, 1, 0, NULL,
        (SELECT id FROM public.tax WHERE name = 'VAT10'), 10.00,
        DEFAULT, DEFAULT);

COMMIT;
