# Portfolio 3 Transactions and Concurrency

Author: Chigoziem Edmund Ofili (301917477)

## Files

| File | Contents |
| --- | --- |
| [PostgreSQL environment setup](../portfolio-1-database-design/design/Setup.md) | Shared PostgreSQL installation, startup and connection steps. |
| [Transaction setup](sql/transactions/Setup.sql) | Create and populate pos_portfolio_transactions. |
| [Transactions](sql/transactions/Transactions.sql) | Setup, session and cleanup order guide. |
| [Transaction session](sql/transactions/Session.sql) | Commit a shift closure and roll back an invalid shift. |
| [Transaction cleanup](sql/transactions/Cleanup.sql) | Drop the transaction practice database. |
| [Concurrency setup](sql/concurrency/Setup.sql) | Create and populate pos_portfolio_concurrency. |
| [Concurrency](sql/concurrency/Concurrency.sql) | Session order guide. |
| [Session A](sql/concurrency/SessionA.sql) | Open a shift and hold the transaction. |
| [Session B](sql/concurrency/SessionB.sql) | Try to open the same terminal concurrently. |
| [Concurrency cleanup](sql/concurrency/Cleanup.sql) | Drop the concurrency practice database. |

## Test setup

Run from the repository root in Codespaces. Both setups load the existing Portfolio 1 schema and test data into separate practice databases, then add T03.

| Test | Database | Starting state |
| --- | --- | --- |
| Transactions | pos_portfolio_transactions | T03 has one open shift. |
| Concurrency | pos_portfolio_concurrency | T03 has no shifts. |

Complete the [PostgreSQL environment setup](../portfolio-1-database-design/design/Setup.md) and leave psql open in Terminal A.

## Transaction test

Transactions.sql lists the order. Run setup, then the session in the same psql terminal:

```text
\i portfolio-3-transactions-concurrency/sql/transactions/Setup.sql
\i portfolio-3-transactions-concurrency/sql/transactions/Session.sql
```

Save the committed closing time, invalid-closing-time error and final open-shift count. Then drop the transaction practice database:

```text
\i portfolio-3-transactions-concurrency/sql/transactions/Cleanup.sql
```

## Concurrency test

In Terminal A's psql session, create and populate the concurrency database:

```text
\i portfolio-3-transactions-concurrency/sql/concurrency/Setup.sql
```

Open Terminal B and connect to the same database:

```bash
sudo runuser -u postgres -- psql -d pos_portfolio_concurrency
```

Copy and run the labelled sections from SessionA.sql and SessionB.sql in this order. Do not run either whole file at once.

| Order | Session | Section | Action |
| --- | --- | --- | --- |
| 1 | A | A1 | Open T03; leave the transaction uncommitted. |
| 2 | B | B1 | Check visibility, then attempt the competing shift. |
| 3 | A | A2 | Show B waiting, then commit. |
| 4 | B | B2 | After the duplicate-key error, roll back and check the saved shift. |

Save B's visibility count, the waiting state before A commits, the duplicate-key error and the final shift.

After saving results, exit Session B with `\q`. In Session A, run:

```text
\i portfolio-3-transactions-concurrency/sql/concurrency/Cleanup.sql
```

Cleanup drops only the matching practice database. Close other connections to that database first. To repeat a test, clean up before running its setup again. The original pos_portfolio database is unchanged.

## Results

| Check | Observed result | Evidence |
| --- | --- | --- |
| COMMIT preserves the shift closure | | |
| ROLLBACK removes the invalid shift | | |
| READ COMMITTED hides A's uncommitted shift from B | | |
| B waits while A holds the conflicting shift | | |
| The unique index leaves one open shift on T03 | | |

## Reflection

**Why Session B waited and then failed:**

**What COMMIT, ROLLBACK and READ COMMITTED demonstrated:**

## References



Reference: [PostgreSQL transaction examples: BEGIN, COMMIT and ROLLBACK](https://www.postgresql.org/docs/16/tutorial-transactions.html).

Reference: [PostgreSQL READ COMMITTED isolation](https://www.postgresql.org/docs/16/transaction-iso.html#XACT-READ-COMMITTED).

Reference: [PostgreSQL BEGIN ISOLATION LEVEL syntax](https://www.postgresql.org/docs/16/sql-begin.html).

Reference: [PostgreSQL SET syntax](https://www.postgresql.org/docs/16/sql-set.html).

Reference: [PostgreSQL application_name setting](https://www.postgresql.org/docs/16/runtime-config-logging.html#GUC-APPLICATION-NAME).

Reference: [PostgreSQL SHOW syntax](https://www.postgresql.org/docs/16/sql-show.html).

Reference: [PostgreSQL locks and concurrent transactions](https://www.postgresql.org/docs/16/explicit-locking.html).
