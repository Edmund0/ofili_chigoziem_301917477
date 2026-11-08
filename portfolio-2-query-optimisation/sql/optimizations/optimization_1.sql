-- QUERY OPTIMISATION ON PORTFOLIO 1:
-- The test index is rolled back after measurement.
\set ON_ERROR_STOP on
\pset pager off

-- 1. CONNECT TO THE ORIGINAL DATABASE:
\connect pos_portfolio

-- 2. CHECK THE INDEX IS NOT ALREADY PRESENT:
DO $$
BEGIN
    IF to_regclass('public.sale_sold_at_idx') IS NOT NULL THEN
        RAISE EXCEPTION 'Index already exists; this is no longer a before-index test.';
    END IF;
END;
$$;

-- 3. LOAD Q2 AND SET THE DATE RANGE:
\ir ../queries/q2_total_revenue.sql
\set start_date '2026-11-01 00:00:00+00'
\set end_date   '2026-11-02 00:00:00+00'

BEGIN;

-- 4. RESULT BEFORE INDEX:
EXECUTE period_revenue(:'start_date', :'end_date');

-- 5. WARM-UP BEFORE INDEX:
EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

-- 6. THREE MEASURED RUNS BEFORE INDEX:
EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

-- 7. ADD THE DATE INDEX:
CREATE INDEX sale_sold_at_idx
    ON public.sale (sold_at);

-- 8. RESULT AFTER INDEX:
EXECUTE period_revenue(:'start_date', :'end_date');

-- 9. WARM-UP AFTER INDEX:
EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

-- 10. THREE MEASURED RUNS AFTER INDEX:
EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

EXPLAIN (ANALYZE, BUFFERS)
EXECUTE period_revenue(:'start_date', :'end_date');

ROLLBACK;
DEALLOCATE period_revenue;
