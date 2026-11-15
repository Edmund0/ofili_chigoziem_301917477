# Portfolio 2 SQL Tests

Author: Chigoziem Edmund Ofili (301917477)

## Test methodology

**Query Test**: Ran Q1 to Q4 tests queries on the same portfolio 1 database. This was to establish that the tests worked before doing the optimization tests.

**Optimization Test**: Compare Q2 query before and after adding an index on the sale date to demonstrate the effects of adding an index to query optimization. The first test used the much smaller portfolio 1 database. The second test used a much larger benchmark database. In both test, I ran one warm-up and then three runs before and after adding the index. The median value is used for the comparison.

## Steps to reproduce

1. Prepared PostgreSQL using the [PostgreSQL environment setup](../../portfolio-1-database-design/design/Setup.md).

2. Completed the [Portfolio 1 test steps](../../portfolio-1-database-design/sql/Test.md) before running these tests.

3. Ran the four reports:

   ```text
   \i portfolio-2-query-optimisation/sql/queries/q0_test.sql
   ```

   Evidence: [Query results](outputs/QueryTest.png).

4. Ran the comparison test (effects of index) on the Portfolio 1 database. The script used the existing database and tested it before and after an index was created:

   ```text
   \i portfolio-2-query-optimisation/sql/optimizations/optimization_1.sql
   ```

   Evidence: [Original database plans](outputs/optimization_1).

5. Ran the same comparison test on the benchmark database. The script built the database and tested it before and after and index was created:

   ```text
   \i portfolio-2-query-optimisation/sql/optimizations/optimization.sql
   ```

   Evidence: [Benchmark database plans](outputs/optimization).

6. Saved the [screenshots](outputs).

## Results

1. Q1 returned three sales with amounts paid of 2490.00, 1100.00 and 1000.00.
2. Q2 returned revenue of 4400.00 and giveaway value of 1500.00, excluding tax.
3. Q3 returned cash revenue of 3400.00 and card revenue of 1000.00. 
4. Q3 returned giveaway value of 1500.00 for cash and 0.00 for card.
4. Q4 returned no products at or below their reorder level.
5. The date index gave no measured improvement on the much smaller Portfolio 1 records.
6. On the benchmark records, the median execution time decreased from 5.434 ms to 1.798 ms.

The detailed optimisation results are in [Optimisation.md](Optimisation.md).
