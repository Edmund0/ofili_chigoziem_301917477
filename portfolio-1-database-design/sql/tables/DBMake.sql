-- CREATE DATABASE:
\set ON_ERROR_STOP on    \\ -- halts if an error occurs

-- Create pos_portfolio only if it doesn't already exist
SELECT 'CREATE DATABASE pos_portfolio'
WHERE NOT EXISTS (
    SELECT 1            -- returns a row if pos_portfolio exists
    FROM pg_database    -- list of databases
    WHERE datname = 'pos_portfolio'
)
\gexec                   \\ -- executes 'CREATE DATABASE pos_portfolio' if pos_portfolio does not exist

-- Creates database tables
\connect pos_portfolio   \\ -- connects to database
\ir DBSchema.sql         \\ -- creates database tables
