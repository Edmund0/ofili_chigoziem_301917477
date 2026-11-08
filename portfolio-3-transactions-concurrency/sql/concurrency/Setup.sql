-- CONCURRENCY SETUP:
\set ON_ERROR_STOP on

-- 1. CREATE TEST DATABASE:
\connect postgres
CREATE DATABASE pos_portfolio_concurrency;
\connect pos_portfolio_concurrency

-- 2. LOAD PORTFOLIO 1 TABLES AND TEST DATA:
\ir ../../../portfolio-1-database-design/sql/tables/DBSchema.sql
\ir ../../../portfolio-1-database-design/sql/tests/DBTestData.sql

-- 4. ADD TERMINAL T03:
--== Require a terminal with no open shifts 
INSERT INTO public.terminal (
    terminal_code,
    name
)
VALUES ('T03', 'Concurrency Checkout');
