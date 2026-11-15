# Portfolio 1 SQL Tests

Author: Chigoziem Edmund Ofili (301917477)

## Steps to reproduce

This test was conducted on GitHub codespace using `psql`. The test involved 5 invalid sql queries (data inserts) which violated the database contraints and 2 valid sql queries (test cases) which should work based on the design.

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

## **Results:**

1. The five invalid inserts were correctly rejected by the db constraints as evidence by the row counts remaining unchanged.
2. For the first positive tests, the saved tax/discount rates on the sales items remained unchanged after the rates on the tax/discount tables where changed.
3. For the second positive test, the committed sale recorded 2 paid Beans and 1 giveaway which reduced the beans' stock qty from 50 to 47, and charged 1000.00 (each bean cost 500).

