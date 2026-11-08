-- DATABASE DEFINITION CODE:

SELECT current_database() AS database;
BEGIN;

-- ROLE ENTITY:
-- Defines staff roles and their allowed actions.
CREATE TABLE IF NOT EXISTS public.role (
    -- attribute declaration
    id                   BIGINT      GENERATED ALWAYS AS IDENTITY NOT NULL,
    name                 VARCHAR(30) NOT NULL,
    can_operate_till     BOOLEAN     NOT NULL DEFAULT false,
    can_manage_products  BOOLEAN     NOT NULL DEFAULT false,
    can_manage_staff     BOOLEAN     NOT NULL DEFAULT false,
    can_manage_terminals BOOLEAN     NOT NULL DEFAULT false,
    can_view_reports     BOOLEAN     NOT NULL DEFAULT false,

    -- primary key constraint
    CONSTRAINT pk_role      PRIMARY KEY (id),

    -- unique constraints
    CONSTRAINT ux_role_name UNIQUE (name)
);

-- STAFF ENTITY:
-- Records staff and their assigned role.
CREATE TABLE IF NOT EXISTS public.staff (
    -- attribute declaration
    id            BIGINT       GENERATED ALWAYS AS IDENTITY NOT NULL,
    staff_code    VARCHAR(20)  NOT NULL,
    email         VARCHAR(254) NOT NULL,
    first_name    VARCHAR(60)  NOT NULL,
    last_name     VARCHAR(60)  NOT NULL,
    role_id       BIGINT       NOT NULL,
    active_status BOOLEAN      NOT NULL DEFAULT true,

    -- primary key constraint
    CONSTRAINT pk_staff            PRIMARY KEY (id),

    -- unique constraints
    CONSTRAINT ux_staff_staff_code UNIQUE (staff_code),
    CONSTRAINT ux_staff_email      UNIQUE (email),

    -- foreign key constraints
    CONSTRAINT fk_staff_role
        FOREIGN KEY (role_id) REFERENCES public.role (id)
);

-- TERMINAL ENTITY:
-- Lists the store's checkout terminals.
CREATE TABLE IF NOT EXISTS public.terminal (
    -- attribute declaration
    id            BIGINT      GENERATED ALWAYS AS IDENTITY NOT NULL,
    terminal_code VARCHAR(20) NOT NULL,
    name          VARCHAR(80) NOT NULL,

    -- primary key constraint
    CONSTRAINT pk_terminal               PRIMARY KEY (id),

    -- unique constraints
    CONSTRAINT ux_terminal_terminal_code UNIQUE (terminal_code)
);

-- SHIFT ENTITY:
-- Records till sessions; NULL closed_at means the session is still open.
CREATE TABLE IF NOT EXISTS public.shift (
    -- attribute declaration
    id          BIGINT      GENERATED ALWAYS AS IDENTITY NOT NULL,
    staff_id    BIGINT      NOT NULL,
    terminal_id BIGINT      NOT NULL,
    opened_at   TIMESTAMPTZ NOT NULL,
    closed_at   TIMESTAMPTZ NULL,

    -- primary key constraint
    CONSTRAINT pk_shift                  PRIMARY KEY (id),

    -- foreign key constraints
    CONSTRAINT fk_shift_staff
        FOREIGN KEY (staff_id)      REFERENCES public.staff (id),
    CONSTRAINT fk_shift_terminal
        FOREIGN KEY (terminal_id)   REFERENCES public.terminal (id),

    -- check constraints
    CONSTRAINT ck_shift_close_after_open
        CHECK (closed_at IS NULL OR closed_at > opened_at)
);

-- SHIFT INDEX:
-- Keep closed shift history while preventing two open shifts on the same terminal.
CREATE UNIQUE INDEX IF NOT EXISTS ux_shift_one_open_per_terminal
    ON public.shift (terminal_id)
    WHERE closed_at IS NULL;

-- PRODUCT ENTITY:
-- Keeps current product prices and stock.
CREATE TABLE IF NOT EXISTS public.product (
    -- attribute declaration
    id            BIGINT        GENERATED ALWAYS AS IDENTITY NOT NULL,
    sku           VARCHAR(30)   NOT NULL,
    name          VARCHAR(150)  NOT NULL,
    unit_price    NUMERIC(10,2) NOT NULL,
    stock_qty     INTEGER       NOT NULL,
    reorder_level INTEGER       NOT NULL,

    -- primary key constraint
    CONSTRAINT pk_product               PRIMARY KEY (id),

    -- unique constraints
    CONSTRAINT ux_product_sku           UNIQUE (sku),

    -- check constraints
    CONSTRAINT ck_product_unit_price    CHECK (unit_price > 0),
    CONSTRAINT ck_product_stock_qty     CHECK (stock_qty >= 0),
    CONSTRAINT ck_product_reorder_level CHECK (reorder_level >= 0)
);

-- TAX ENTITY:
-- Lists available tax rates.
CREATE TABLE IF NOT EXISTS public.tax (
    -- attribute declaration
    id         BIGINT       GENERATED ALWAYS AS IDENTITY NOT NULL,
    name       VARCHAR(60)  NOT NULL,
    percentage NUMERIC(5,2) NOT NULL,

    -- primary key constraint
    CONSTRAINT pk_tax PRIMARY KEY (id)
);

-- SEED DEFAULT TAX:
-- ID 0 is reserved for the no-tax defaults.
INSERT INTO public.tax (id, name, percentage)
    OVERRIDING SYSTEM VALUE
    VALUES (0, 'No tax', 0)
    ON CONFLICT (id) DO NOTHING;


-- DISCOUNT ENTITY:
-- Lists available percentage discounts.
CREATE TABLE IF NOT EXISTS public.discount (
    -- attribute declaration
    id         BIGINT       GENERATED ALWAYS AS IDENTITY NOT NULL,
    name       VARCHAR(60)  NOT NULL,
    percentage NUMERIC(5,2) NOT NULL,

    -- primary key constraint
    CONSTRAINT pk_discount PRIMARY KEY (id)
);

-- SEED DEFAULT DISCOUNT:
-- ID 0 is reserved for the no-discount defaults.
INSERT INTO public.discount (id, name, percentage)
    OVERRIDING SYSTEM VALUE
    VALUES (0, 'No discount', 0)
    ON CONFLICT (id) DO NOTHING;

-- SALE ENTITY:
-- Records each completed sale and its shift.
CREATE TABLE IF NOT EXISTS public.sale (
    -- attribute declaration
    id             BIGINT      GENERATED ALWAYS AS IDENTITY NOT NULL,
    receipt_number VARCHAR(30) NOT NULL,
    shift_id       BIGINT      NOT NULL,
    sold_at        TIMESTAMPTZ NOT NULL,
    payment_method VARCHAR(10) NOT NULL,

    -- primary key constraint
    CONSTRAINT pk_sale                PRIMARY KEY (id),

    -- unique constraints
    CONSTRAINT ux_sale_receipt_number UNIQUE (receipt_number),

    -- foreign key constraints
    CONSTRAINT fk_sale_shift
        FOREIGN KEY (shift_id) REFERENCES public.shift (id),

    -- check constraints
    CONSTRAINT ck_sale_payment_method
        CHECK (payment_method IN ('cash', 'card', 'transfer'))
);

-- SALES ITEM ENTITY:
-- Records paid and giveaway quantities for each product in a sale.
CREATE TABLE IF NOT EXISTS public.sale_item (
    -- attribute declaration
    id                          BIGINT        GENERATED ALWAYS AS IDENTITY NOT NULL,
    sale_id                     BIGINT        NOT NULL,
    product_id                  BIGINT        NOT NULL,
    unit_price_at_sale          NUMERIC(10,2) NOT NULL,
    paid_qty                    INTEGER       NOT NULL DEFAULT 0,
    giveaway_qty                INTEGER       NOT NULL DEFAULT 0,
    giveaway_reason             VARCHAR(80)   NULL,
    tax_id                      BIGINT        NOT NULL DEFAULT 0,
    tax_percentage_at_sale      NUMERIC(5,2)  NOT NULL,
    discount_id                 BIGINT        NOT NULL DEFAULT 0,
    discount_percentage_at_sale NUMERIC(5,2)  NOT NULL DEFAULT 0,

    -- primary key constraint
    CONSTRAINT pk_sale_item                 PRIMARY KEY (id),

    -- unique constraints
    CONSTRAINT ux_sale_item_sale_product    UNIQUE (sale_id, product_id),

    -- foreign key constraints
    CONSTRAINT fk_sale_item_sale
        FOREIGN KEY (sale_id)       REFERENCES public.sale (id),
    CONSTRAINT fk_sale_item_product
        FOREIGN KEY (product_id)    REFERENCES public.product (id),
    CONSTRAINT fk_sale_item_tax
        FOREIGN KEY (tax_id)        REFERENCES public.tax (id)      ON DELETE RESTRICT,
    CONSTRAINT fk_sale_item_discount
        FOREIGN KEY (discount_id)   REFERENCES public.discount (id) ON DELETE RESTRICT,

    -- check constraints
    CONSTRAINT ck_sale_item_unit_price      CHECK (unit_price_at_sale > 0),
    CONSTRAINT ck_sale_item_paid_qty        CHECK (paid_qty >= 0),
    CONSTRAINT ck_sale_item_giveaway_qty    CHECK (giveaway_qty >= 0),
    CONSTRAINT ck_sale_item_has_quantity    CHECK (paid_qty > 0 OR giveaway_qty > 0),
    CONSTRAINT ck_sale_item_giveaway_reason CHECK (
        (giveaway_qty > 0 AND giveaway_reason IS NOT NULL AND btrim(giveaway_reason) <> '')
        OR (giveaway_qty = 0 AND giveaway_reason IS NULL)
    )
);

COMMIT;
