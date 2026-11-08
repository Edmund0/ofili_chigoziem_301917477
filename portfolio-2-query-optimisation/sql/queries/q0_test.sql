-- QUERY TESTS ON PORTFOLIO 1:
\set ON_ERROR_STOP on
\connect pos_portfolio
\pset pager off

-- 1. SALES REPORT:
\ir q1_sales_report.sql
EXECUTE sales_report(NULL, NULL);
DEALLOCATE sales_report;

-- 2. TOTAL REVENUE:
\ir q2_total_revenue.sql
EXECUTE period_revenue(NULL, NULL);
DEALLOCATE period_revenue;

-- 3. REVENUE BY PAYMENT METHOD:
\ir q3_revenue_by_method.sql
EXECUTE revenue_by_payment(NULL, NULL);
DEALLOCATE revenue_by_payment;

-- 4. LOW-STOCK REPORT:
\ir q4_low_stock.sql
EXECUTE low_stock;
DEALLOCATE low_stock;
