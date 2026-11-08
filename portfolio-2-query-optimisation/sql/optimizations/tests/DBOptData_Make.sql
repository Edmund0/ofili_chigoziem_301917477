-- BENCHMARK DATABASE:
\set ON_ERROR_STOP on   \\ -- halts if an error occurs

-- CREATE BENCHMARK DATABASE:
SELECT 'CREATE DATABASE pos_portfolio_benchmark'
WHERE NOT EXISTS (
    SELECT 1            -- returns a row if pos_portfolio_benchmark exists
    FROM pg_database    -- list of databases
    WHERE datname = 'pos_portfolio_benchmark'
)
\gexec               \\ -- executes 'CREATE DATABASE pos_portfolio_benchmark' if it does not exist

-- connects to database
\connect pos_portfolio_benchmark

-- creates database tables
\ir ../../../../portfolio-1-database-design/sql/tables/DBSchema.sql
