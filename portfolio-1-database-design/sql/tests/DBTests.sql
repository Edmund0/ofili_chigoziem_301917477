-- RUN DATABASE TESTS:
-- Run once after DBMake.sql.
\connect pos_portfolio   \\ -- connects to the POS database

-- TEST DATA:
\set ON_ERROR_STOP on    \\ -- halts on errors
\ir DBTestData.sql       \\ -- inserts the sample test data

-- NEGATIVE TESTS:
\set ON_ERROR_STOP off   \\ -- continues after each expected error
\ir DBNegativeTest.sql   \\ -- runs all negative tests

-- POSITIVE TESTS:
\set ON_ERROR_STOP on    \\ -- stops on error
\ir DBPositiveTest.sql   \\ -- runs all positive tests
