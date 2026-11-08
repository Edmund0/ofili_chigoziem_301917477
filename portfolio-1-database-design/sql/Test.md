# Portfolio 1 SQL Tests

Author: Chigoziem Edmund Ofili (301917477)

## Steps to reproduce

Worked from the repository root in GitHub Codespaces. Database commands were run inside `psql`.

1. Prepared PostgreSQL using the [PostgreSQL environment setup](../design/Setup.md).

2. Created the database and tables:

   ```text
   \i portfolio-1-database-design/sql/tables/DBMake.sql
   ```

   Evidence: [Database setup](outputs/DBMake.png).

3. Loaded the test data:

   ```text
   \set ON_ERROR_STOP on
   \ir portfolio-1-database-design/sql/tests/DBTestData.sql
   ```

   Evidence: [Test data](outputs/DBTestData.png).

4. Ran the sections in [DBNegativeTest.sql](tests/DBNegativeTest.sql) individually, including the before/after counts:

   ```text
   \set ON_ERROR_STOP off
   ```

   Evidence: [Baseline and stock](<outputs/NegTest 0,1.png>), [shift, quantities and reason](<outputs/NegTest 2,3,4.png>), [duplicate product and final counts](<outputs/NegTest 5,6.png>).

5. Ran both sections in [DBPositiveTest.sql](tests/DBPositiveTest.sql): historical rates with `ROLLBACK`, then the successful sale with `COMMIT`:

   ```text
   \set ON_ERROR_STOP on
   ```

   Evidence: [Historical rates](<outputs/PosTest 1.png>), [sale commands](<outputs/PosTest 2 Query.png>), [sale results](<outputs/PosTest 2 Result.png>).

6. Saved the [screenshots](outputs) and checked the results.

**Results:**

1. All five invalid inserts were rejected by the intended constraints; row counts stayed unchanged.
2. Saved tax and discount rates remained unchanged when current rates changed.
3. The committed sale recorded two paid Beans and one giveaway, reduced stock from 50 to 47, and charged 1000.00.

