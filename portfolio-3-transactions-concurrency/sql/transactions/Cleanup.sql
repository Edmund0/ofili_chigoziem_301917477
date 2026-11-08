-- TRANSACTIONS CLEANUP:
--== Drop throwaway database
\set ON_ERROR_STOP on
\connect postgres
DROP DATABASE IF EXISTS pos_portfolio_transactions;
