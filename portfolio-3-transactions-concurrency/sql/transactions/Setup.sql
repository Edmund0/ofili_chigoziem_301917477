-- TRANSACTIONS SETUP:

-- 1. CREATE TEST DATABASE:
--== Creates a throwaway database
\set ON_ERROR_STOP on
\connect postgres
CREATE DATABASE pos_portfolio_transactions;
\connect pos_portfolio_transactions

-- 2. LOAD PORTFOLIO 1 TABLES AND TEST DATA:
--== Creates the same setup as portfolio 1
\ir ../../../portfolio-1-database-design/sql/tables/DBSchema.sql
\ir ../../../portfolio-1-database-design/sql/tests/DBTestData.sql


-- 3. ADD TERMINAL T03:
--== Keep the P1 terminals unchanged.
INSERT INTO public.terminal (
    terminal_code,
    name
)
VALUES ('T03', 'Practice checkout');

-- 4. OPEN T03 FOR THE TRANSACTION TEST:
--== Prepare an open shift for commit test.
INSERT INTO public.shift (
    staff_id,
    terminal_id,
    opened_at
)
VALUES ((SELECT id FROM public.staff WHERE staff_code = 'C001'),
        (SELECT id FROM public.terminal WHERE terminal_code = 'T03'),
        CURRENT_TIMESTAMP);
