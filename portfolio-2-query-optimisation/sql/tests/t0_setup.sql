-- BENCHMARK TEST DATA:
-- Replaces test data in pos_portfolio_benchmark only. Existing indexes are kept.
\set ON_ERROR_STOP on   \\ -- halts if an error occurs
\set ECHO none          \\ -- hide commands read
\set QUIET on           \\ -- hide status messages
\o /dev/null            \\ -- discard query results; errors remain visible

-- CREATE TEST DATABASE [PORTFOLIO BENCHMARK]
\ir t1_make.sql

SET client_min_messages = warning;
SET TIME ZONE 'UTC';

BEGIN;

-- RESET TEST DATA:
TRUNCATE 
    public.sale_item, 
    public.sale, 
    public.shift, 
    public.staff,
    public.role, 
    public.terminal, 
    public.product, 
    public.tax, 
    public.discount
RESTART IDENTITY;

-- INSERT TEST DATA:
\ir t2_baseline.sql
\ir t3_sales.sql

COMMIT;

-- UPDATE PLANNER STATISTICS:
ANALYZE;

RESET client_min_messages;
\o
\set QUIET off

