# Portfolio 2 SQL Tests

Author: Chigoziem Edmund Ofili (301917477)

## Steps to reproduce

Worked from the repository root in GitHub Codespaces. SQL files were run inside `psql`.

1. Completed the [PostgreSQL environment setup](../../portfolio-1-database-design/design/Setup.md), then connected to the existing Portfolio 1 database inside psql:

   ```text
   \connect pos_portfolio
   ```

2. Ran the four reports using all dates:

   ```text
   \i portfolio-2-query-optimisation/sql/queries/q0_test.sql
   ```

   Evidence: [Query results](outputs/QueryTest.png).

3. Compared Q2 on the original database:

   ```text
   \i portfolio-2-query-optimisation/sql/optimizations/optimization_1.sql
   ```

   The date range was November 1, 2026, inclusive, to November 2, exclusive.
   The script created `sale_sold_at_idx` on `sale.sold_at` and rolled it back after measurement.

   Evidence: [Before — first two plans](<outputs/optimization_1/Original BeforQ1,2.png>), [before — last two plans](<outputs/optimization_1/Original BeforeQ3,4.png>), [after — first two plans](<outputs/optimization_1/Original AfterQ1,2.png>), [after — last two plans](<outputs/optimization_1/Original AfterQ3,4.png>).

4. Compared Q2 on the separate benchmark database:

   ```text
   \i portfolio-2-query-optimisation/sql/optimizations/optimization.sql
   ```

   The script loaded `pos_portfolio_benchmark` and compared the same query before and after adding `sale_sold_at_idx`.
   
   The date range was January 15, 2000, inclusive, to January 16, exclusive.

   The plans show 10,000 sales and 20,000 items; 100 sales matched the date range.

   Evidence: [Before — first two plans](<outputs/optimization/BeforeQ1,2.png>), [before — last two plans](<outputs/optimization/BeforQ3,4.png>), [after — first two plans](<outputs/optimization/AfterQ1,2.png>), [after — last two plans](<outputs/optimization/AfterQ3,4.png>).

The benchmark runner calls its setup automatically. Setup replaces benchmark records but keeps existing indexes; the runner stops if sale_sold_at_idx already exists. The original Portfolio 1 records are unchanged.

For each comparison, the first plan in each phase was a warm-up. The next three execution times were measured. The median is the middle of those three values after sorting.

## Results

### Queries

| Query | Observed result |
| --- | --- |
| Q1 | Three sales. Amounts paid: R-101 = 2490.00; R-102 = 1100.00; TEST-SALE-001 = 1000.00. |
| Q2 | Revenue excluding tax = 4400.00; giveaway value = 1500.00. |
| Q3 | Cash revenue = 3400.00; card revenue = 1000.00. Cash giveaway value = 1500.00; card giveaway value = 0.00. |
| Q4 | No products at or below their reorder level. |

### Original database

| Measurement | Before index | After index |
| --- | --- | --- |
| Q2 revenue / giveaway value | 3400.00 / 1500.00 | 3400.00 / 1500.00 |
| Sale scan | Seq Scan | Seq Scan |
| Three execution times (ms) | 0.040, 0.039, 0.043 | 0.050, 0.047, 0.044 |
| Median execution time (ms) | 0.040 | 0.047 |
| Shared buffer hits, third measured run | 5 | 5 |

The date index was not used. The median increased slightly, but the table contained only three sales and the timings were very small. This run did not demonstrate an improvement.

### Benchmark database

| Measurement | Before index | After index |
| --- | --- | --- |
| Sale scan | Seq Scan | Bitmap Heap Scan with Bitmap Index Scan |
| Join | Hash Join | Nested Loop |
| Three execution times (ms) | 3.485, 5.434, 8.176 | 1.798, 3.055, 0.655 |
| Median execution time (ms) | 5.434 | 1.798 |
| Shared buffer hits, third measured run | 361 | 396 |
| Q2 revenue / giveaway value | | |

The benchmark revenue totals still need to be recorded; they are not visible in the saved plan screenshots.

## Performance analysis

On the larger dataset, PostgreSQL used the date index to find matching sales and the existing sale-item index to retrieve their items. Before indexing, it scanned both tables. The measured median fell from 5.434 ms to 1.798 ms, although shared buffer hits increased.

Timings varied between runs in Codespaces. The before plans also used supplied date values, while the after plans used a generic prepared plan with `$1` and `$2`. This limits how much of the timing change can be attributed to the index alone.

An index uses storage and adds maintenance work when indexed data is inserted, updated or deleted. The small-data test shows that adding an index does not guarantee a faster query.

