# Portfolio 1 Database Design and Modelling

## Implementation Files

| File | Contents |
| --- | --- |
| [Case study](design/CaseStudy.md) | Users, operations, business rules and scope. |
| [Design](design/Design.md) | Entities, attributes, keys, relationships and constraints. |
| [ER diagram](design/ERDiagram.md) | Key relationships and the full attribute diagram. |
| [Normalisation](design/Normalisation.md) | Starting record, 1NF, 2NF and 3NF. |
| [Schema](sql/tables/DBSchema.sql) | Nine tables, constraints, open-shift index and default tax/discount records. |
| [Test data](sql/tests/DBTestData.sql) | Fictional records for the tests. |
| [Negative tests](sql/tests/DBNegativeTest.sql) | Invalid inserts and row counts before and after testing. |
| [Positive tests](sql/tests/DBPositiveTest.sql) | Historical rates and a sale with paid and giveaway quantities. |

## Steps to reproduce

Worked from the repository root in GitHub Codespaces. Commands after step 3 were run inside `psql`.

1. Opened the repository in a Codespace.

2. Installed PostgreSQL:

   ```bash
   sudo apt-get update
   sudo apt-get install -y postgresql
   ```

3. Started the server and opened `psql`:

   ```bash
   sudo service postgresql start
   sudo runuser -u postgres -- psql
   ```

4. Created the database and tables:

   ```text
   \i portfolio-1-database-design/sql/tables/DBMake.sql
   ```

   Evidence: [Database setup](sql/outputs/DBMake.png).

5. Loaded the test data:

   ```text
   \set ON_ERROR_STOP on
   \ir portfolio-1-database-design/sql/tests/DBTestData.sql
   ```

   Evidence: [Test data](sql/outputs/DBTestData.png).

6. Ran the sections in [DBNegativeTest.sql](sql/tests/DBNegativeTest.sql) individually, including the before/after counts:

   ```text
   \set ON_ERROR_STOP off
   ```

   Evidence: [Baseline and stock](<sql/outputs/NegTest 0,1.png>), [shift, quantities and reason](<sql/outputs/NegTest 2,3,4.png>), [duplicate product and final counts](<sql/outputs/NegTest 5,6.png>).

7. Ran both sections in [DBPositiveTest.sql](sql/tests/DBPositiveTest.sql): historical rates with `ROLLBACK`, then the successful sale with `COMMIT`:

   ```text
   \set ON_ERROR_STOP on
   ```

   Evidence: [Historical rates](<sql/outputs/PosTest 1.png>), [sale commands](<sql/outputs/PosTest 2 Query.png>), [sale results](<sql/outputs/PosTest 2 Result.png>).

8. Saved the [screenshots](sql/outputs/) and checked the results.

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
