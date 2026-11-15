# Portfolio 2 Optimisation Results

Author: Chigoziem Edmund Ofili (301917477)

The test methodology, steps, and evidence are in [Test.md](Test.md).

## Test 1: Portfolio 1 database

The first test compared Q2 before and after adding the date index. This database **only had 3 sales**.

### Results

| Measurement | Before index | After index |
| --- | --- | --- |
| Sale scan | Sequential scan | Sequential scan |
| Median execution time (ms) | 0.040 | 0.047 |
| Revenue | 3400.00 | 3400.00 |
| Giveaway value | 1500.00 | 1500.00 |

**Interpretation**: In both case, PostgreSQL scanned the sales table directly. The database management system's query planner determines and selects the fastest method to complete a query. Because the database was so small, it choose to scan the table rather than use the new index. The median time actually increased very slighly, so the index gave no measured improvement.

## Test 2: Benchmark database

The second test compared Q2 before and after adding the date index. This database used 10,000 sales and 20,000 sale items. 

### Results

| Measurement | Before index | After index |
| --- | --- | --- |
| Sale scan | Sequential scan | Bitmap index scan and bitmap heap scan |
| Join | Hash join | Nested loop |
| Median execution time (ms) | 5.434 | 1.798 |

**Interpretation**

**Before indexing**, PostgreSQL first scanned all the sales and sale items. It then joined the matching records. **After indexing**, PostgreSQL first used the date index to find the 100 matching sales. It then used the used the sale-item index to retrieve their 200 items, rather than scanning all 20000 items.

**Speed Boost**: The query become three times faster with the help of the index. Its execution time fell from 5.434 ms to 1.798 ms.
