-- CONCURRENCY SETUP:

-- 1. CREATE TEST DATABASE:
--== Creates a throwaway database
\set ON_ERROR_STOP on
\connect postgres
CREATE DATABASE pos_portfolio_concurrency;
\connect pos_portfolio_concurrency

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
VALUES ('T03', 'Concurrency Checkout');
