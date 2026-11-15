# Portfolio 2 Query Processing and Optimisation

Author: Chigoziem Edmund Ofili (301917477)

## Implementation Files

| File | Contents |
| --- | --- |
| [PostgreSQL environment setup](../portfolio-1-database-design/design/Setup.md) | Shared PostgreSQL installation, startup and connection steps. |
| [Test record](sql/Test.md) | Query and optimisation steps, evidence, recorded results and analysis. |
| [Query tests](sql/queries/q0_test.sql) | Run Q1–Q4 on Portfolio 1 data. |
| [Q1](sql/queries/q1_sales_report.sql) | Receipts with cashier, terminal, payment and giveaway values. |
| [Q2](sql/queries/q2_total_revenue.sql) | Revenue after discounts, excluding tax, for a date range. |
| [Q3](sql/queries/q3_revenue_by_method.sql) | Revenue and giveaway value grouped by payment method. |
| [Q4](sql/queries/q4_low_stock.sql) | Low-stock report. |
| [Original-data optimisation](sql/optimizations/optimization_1.sql) | Compare Q2 on Portfolio 1 data; roll back the test index. |
| [Benchmark optimisation](sql/optimizations/optimization.sql) | Compare Q2 on a larger dataset. |
| [Benchmark setup](sql/optimizations/tests/t0_setup.sql) | Create and load the benchmark database. |
| [Database creation](sql/optimizations/tests/DBOptData_Make.sql) | Create the benchmark database and tables. |
| [Baseline records](sql/optimizations/tests/DBOptData_Baseline.sql) | Staff, products, tax and discount records. |
| [Sales records](sql/optimizations/tests/DBOptData_Sales.sql) | Generate benchmark shifts, sales and items. |

## References

Reference: [PostgreSQL — Using EXPLAIN](https://www.postgresql.org/docs/16/using-explain.html).

Reference: [PostgreSQL — Prepared statement plans](https://www.postgresql.org/docs/16/sql-prepare.html).

