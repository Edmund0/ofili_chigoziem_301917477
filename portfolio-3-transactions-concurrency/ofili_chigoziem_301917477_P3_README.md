# Portfolio 3 Transactions and Concurrency

Author: Chigoziem Edmund Ofili (301917477)

## Files

| File | Contents |
| --- | --- |
| [PostgreSQL environment setup](../portfolio-1-database-design/design/Setup.md) | Shared PostgreSQL installation, startup and connection steps. |
| [Test record](sql/Test.md) | Transaction and concurrency steps, results and reflection. |
| [Transaction setup](sql/transactions/Setup.sql) | Create and populate pos_portfolio_transactions. |
| [Transactions](sql/transactions/Transactions.sql) | Setup, session and cleanup order guide. |
| [Transaction session](sql/transactions/Session.sql) | Commit a shift closure and roll back an invalid shift. |
| [Transaction cleanup](sql/transactions/Cleanup.sql) | Drop the transaction practice database. |
| [Concurrency setup](sql/concurrency/Setup.sql) | Create and populate pos_portfolio_concurrency. |
| [Concurrency](sql/concurrency/Concurrency.sql) | Session order guide. |
| [Session A](sql/concurrency/SessionA.sql) | Open a shift and hold the transaction. |
| [Session B](sql/concurrency/SessionB.sql) | Try to open the same terminal concurrently. |
| [Concurrency cleanup](sql/concurrency/Cleanup.sql) | Drop the concurrency practice database. |

## References

Reference: [PostgreSQL transaction examples: BEGIN, COMMIT and ROLLBACK](https://www.postgresql.org/docs/16/tutorial-transactions.html).

Reference: [PostgreSQL READ COMMITTED isolation](https://www.postgresql.org/docs/16/transaction-iso.html#XACT-READ-COMMITTED).

Reference: [PostgreSQL BEGIN ISOLATION LEVEL syntax](https://www.postgresql.org/docs/16/sql-begin.html).

Reference: [PostgreSQL SET syntax](https://www.postgresql.org/docs/16/sql-set.html).

Reference: [PostgreSQL application_name setting](https://www.postgresql.org/docs/16/runtime-config-logging.html#GUC-APPLICATION-NAME).

Reference: [PostgreSQL SHOW syntax](https://www.postgresql.org/docs/16/sql-show.html).

Reference: [PostgreSQL locks and concurrent transactions](https://www.postgresql.org/docs/16/explicit-locking.html).
