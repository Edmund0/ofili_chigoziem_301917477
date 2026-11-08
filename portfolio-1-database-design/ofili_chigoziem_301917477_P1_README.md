# Portfolio 1 Database Design and Modelling

## Implementation Files

| File | Contents |
| --- | --- |
| [PostgreSQL environment setup](design/Setup.md) | Shared PostgreSQL installation, startup and connection steps. |
| [Case study](design/CaseStudy.md) | Users, operations, business rules and scope. |
| [Design](design/Design.md) | POS records, their fields and the rules connecting them. |
| [ER diagram](design/ERDiagram.md) | Key relationships and the full attribute diagram. |
| [Normalisation](design/Normalisation.md) | Separate receipt, product and lookup details through 1NF–3NF. |
| [Schema](sql/tables/DBSchema.sql) | Nine tables, constraints, open-shift index and default tax/discount records. |
| [Test data](sql/tests/DBTestData.sql) | Fictional records for the tests. |
| [Negative tests](sql/tests/DBNegativeTest.sql) | Invalid inserts and row counts before and after testing. |
| [Positive tests](sql/tests/DBPositiveTest.sql) | Run the rate-history and completed-sale checks in order. |
| [Historical rates](sql/tests/DBHistoricalRatesTest.sql) | Change current rates and inspect saved sale percentages. |
| [Completed sale](sql/tests/DBSaleTest.sql) | Record paid and giveaway quantities and reduce stock. |

## Steps to reproduce

Worked from the repository root in GitHub Codespaces. Database commands were run inside `psql`.

1. Prepared PostgreSQL using the [PostgreSQL environment setup](design/Setup.md).

2. Created the database and tables:

   ```text
   \i portfolio-1-database-design/sql/tables/DBMake.sql
   ```

   Evidence: [Database setup](sql/outputs/DBMake.png).

3. Loaded the test data:

   ```text
   \set ON_ERROR_STOP on
   \ir portfolio-1-database-design/sql/tests/DBTestData.sql
   ```

   Evidence: [Test data](sql/outputs/DBTestData.png).

4. Ran the sections in [DBNegativeTest.sql](sql/tests/DBNegativeTest.sql) individually, including the before/after counts:

   ```text
   \set ON_ERROR_STOP off
   ```

   Evidence: [Baseline and stock](<sql/outputs/NegTest 0,1.png>), [shift, quantities and reason](<sql/outputs/NegTest 2,3,4.png>), [duplicate product and final counts](<sql/outputs/NegTest 5,6.png>).

5. Ran both sections in [DBPositiveTest.sql](sql/tests/DBPositiveTest.sql): historical rates with `ROLLBACK`, then the successful sale with `COMMIT`:

   ```text
   \set ON_ERROR_STOP on
   ```

   Evidence: [Historical rates](<sql/outputs/PosTest 1.png>), [sale commands](<sql/outputs/PosTest 2 Query.png>), [sale results](<sql/outputs/PosTest 2 Result.png>).

6. Saved the [screenshots](sql/outputs/) and checked the results.

**Results:**

1. All five invalid inserts were rejected by the intended constraints; row counts stayed unchanged.
2. Saved tax and discount rates remained unchanged when current rates changed.
3. The committed sale recorded two paid Beans and one giveaway, reduced stock from 50 to 47, and charged 1000.00.

## References

Reference: [SQL Tutorial cheat sheet (with downloadable PDF)](https://www.sqltutorial.org/sql-cheat-sheet/).

Reference: [W3Schools SQL quick reference](https://www.w3schools.com/sql/sql_quickref.asp).

Reference: [PostgreSQL 16 constraints](https://www.postgresql.org/docs/16/ddl-constraints.html).

Reference: [VALUES lists](https://www.postgresql.org/docs/16/queries-values.html).

Reference: [UPDATE with RETURNING](https://www.postgresql.org/docs/16/dml-returning.html).

Reference: [Transaction example](https://www.postgresql.org/docs/16/tutorial-transactions.html).

Reference: [Partial unique index, Example 11.3](https://www.postgresql.org/docs/16/indexes-partial.html).

Reference: [FOR UPDATE row locking](https://www.postgresql.org/docs/16/explicit-locking.html#LOCKING-ROWS).
