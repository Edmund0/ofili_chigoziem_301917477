# MIT 8103 Advanced Database Systems: Portfolio Summary

**Author:** Chigoziem Edmund Ofili (301917477)<br>
**Case study:** Retail POS and Inventory System<br>
**Repository:** https://github.com/Edmund0/advanced-database-portfolio

## Case study

GoodNaija, a growing supermarket in downtown Lagos, is in need of a point-of-sale (POS) and inventory tracking system. The supermarket has two main checkout terminals, two cashiers, and one supervisor. The cashiers can open and close their shifts, record sales and giveaways, and accept cash, card or transfer payments. The supervisors maintain staff, products, prices, and receive stocks. The design excludes refunds, partial payments, user authentication and card processing.

## Portfolio 1: Database Design and Modelling

GoodNaija's PostgreSQL database system was designed around its normal daily operations: opening and closing till shifts for staff, recording sales and giveaways, and keeping track of inventory. The design has nine tables: `role`, `staff`, `terminal`, `shift`, `product`, `sale`, `sale_item`, `tax` and `discount`. The [ER diagrams](portfolio-1-database-design/design/ERDiagram.md) shows the attributes, keys, and relations of the nine tables.

**Normalization**: In order to minimize data redundancies and maintain data integrity, the database schema was designed to satisfy the the requirements of the third normal form. The [normalization examples](portfolio-1-database-design/design/Normalisation.md) demonstrates the process used to develope the schema through the first, second, and third normal forms (1NF, 2NF and 3NF).

In the normalization example:

- **1NF**: A receipt's items column had a list of purchased items. Each item became a separate sales-item row. The 1NF requires all fields to be **atomic**.
- **2NF**: A sales item was identified by receipt number and product SKU. However, receipt details depended only on receipt number, while product names depended only on the SKU. Products was moved to a separate table. 2NF requires non-key fields to depend on the whole key.
- **3NF**: The details of staff, role, terminal, and shift were moved to their own tables to remove transitive dependencies. A sale identified a shift, and a shift identified the cashier and terminal.

**Keys and Constraints**: Primary keys identify records, foreign keys keep related records connected, and unique and check constraints enforce rules such as preventing duplicate receipt numbers and negative stock [1]. A partial unique index prevents two shifts from being open on the same terminal at once.

**Test**: The [tests](portfolio-1-database-design/sql/Test.md) showed that:

- All five invalid inserts were rejected, with no change to the row counts.
- A successful sale of two paid units of Beans and one giveaway reduced stock from 50 to 47 and charged 1000.00.
- Changing current tax and discount rates left the percentages saved on existing sale items unchanged.

Two rules still need to be enforced by the operations that use the database: checking staff permissions and ensuring every sale contains at least one item. The foreign keys do not enforce either rule on their own.

![Retail POS keys and relationships](summary-assets/POS_ERDiagram.svg)

*Figure 1. The nine database tables, their keys and relationships.*

## Portfolio 2: Query Processing and Optimisation

Four queries cover receipt details, period revenue, revenue by payment method and low stock. Across the recorded POS data, revenue excluding tax was 4400.00 and giveaway value was 1500.00. This includes the sale added during Portfolio 1 testing.

Q2 was measured before and after adding an index on sale.sold_at, using EXPLAIN ANALYZE with BUFFERS [2]. Each phase included one warm-up followed by three measured runs; the table reports their medians.

| Measurement | Before index | After index |
| --- | --- | --- |
| Original data: median execution time | 0.040 ms | 0.047 ms |
| Original data: sale scan | Seq Scan | Seq Scan |
| Original data: revenue / giveaway value | 3400.00 / 1500.00 | 3400.00 / 1500.00 |
| Benchmark: median execution time | 5.434 ms | 1.798 ms |
| Benchmark: sale scan | Seq Scan | Bitmap Heap Scan and Bitmap Index Scan |

The original-data comparison covered November 1 only, explaining its lower revenue than the all-date query. Its small table did not benefit from the index. The benchmark contained 10,000 sales and 20,000 sale items, with 100 sales matching its date range.

The benchmark median decreased, but timings varied in Codespaces. The before plans used supplied parameter values, while the after plans used a generic prepared plan. These differences limit how much improvement can be attributed to the index alone. Indexes also require storage and maintenance.

The saved benchmark evidence records plans and timings but not the before/after aggregate totals. Result equivalence for that dataset remains unverified.

## Portfolio 3: Transactions and Concurrency

Separate practice databases reused the POS schema and data. COMMIT preserved a T03 shift closure. Closing it again affected zero rows. A later transaction inserted another shift, then deliberately set its closing time equal to its opening time. The check constraint rejected the update; ROLLBACK removed the new shift. One previously committed closed shift remained, with zero open shifts.

Two sessions then used READ COMMITTED [3]. Session A inserted an open T03 shift without committing. Session B saw zero visible open shifts, but its competing insert waited. Session A recorded p3_session_b with wait_event_type Lock. After A committed, B received a duplicate-key error from the open-shift index. B rolled back, leaving one open T03 shift belonging to C001. The result shows why an availability query alone cannot prevent conflicting inserts.

## Portfolio 4: NoSQL and Advanced Data Models

MongoDB 8.0.34 and mongosh 2.14.1 ran locally in Codespaces. The pos_events database stored four inventory_events documents. Each event embedded product and staff snapshots, with different details for deliveries, sales and giveaways.

The insertion was acknowledged and the document count increased from zero to four. Rice history returned a delivery, sale and giveaway in order. A nested-field filter found giveaway E003. Aggregation grouped quantity changes by product [4], returning RICE 7 and SOAP 5. These are net event movements, not current stock balances. The collection demonstrates flexible event records; it does not replace PostgreSQL constraints or synchronise stock automatically.

## Portfolio 5: Distributed and Cloud Database Exercise

The deployment discussion proposes managed PostgreSQL with a primary and standby in separate availability zones. Synchronous replication would add commit delay and could make writes wait if the required standby became unavailable. Failover would require promoting the standby, preventing conflicting writes from the old primary and reconnecting the application [5]. Backups would still be necessary.

The proposal favours consistency when a required standby cannot be reached. Access would use encrypted connections, authentication and role permissions. Cloud latency would need testing. Vertical scaling could add capacity; sharding would introduce complexity beyond the current single-store scope. No cloud deployment, replication or failover test has been performed.

## Evidence

The repository contains the scripts, screenshots and detailed test records: [P1](https://github.com/Edmund0/advanced-database-portfolio/blob/main/portfolio-1-database-design/sql/Test.md), [P2](https://github.com/Edmund0/advanced-database-portfolio/blob/main/portfolio-2-query-optimisation/sql/Test.md), [P3](https://github.com/Edmund0/advanced-database-portfolio/blob/main/portfolio-3-transactions-concurrency/sql/Test.md) and [P4](https://github.com/Edmund0/advanced-database-portfolio/blob/main/portfolio-4-nosql/db/Test.md). [P5](https://github.com/Edmund0/advanced-database-portfolio/blob/main/portfolio-5-distributed-cloud/ofili_chigoziem_301917477_P5_README.md) contains the proposed deployment discussion. The separate practice databases keep the transaction and concurrency exercises distinct from the original POS query results.

## Individual reflection

**Design choice:** Separate paid and giveaway rows initially repeated a shelf price that depended on only sale and product. Combining paid_qty and giveaway_qty on one row retained the giveaway value and shared price without adding another table.

**Difficulties and actions:** Indexing made the small-data median slightly worse, so both comparisons and their limitations were retained. The first concurrency monitoring query returned zero rows. Separating session initialisation into A0/B0 and rerunning the exercise produced the named-session Lock result. This corrected the missing evidence rather than treating the first output as successful.

These exercises show that design rules, database constraints and observed results need separate checks. Checking that a shift appears available does not prevent a competing insert; the unique index provides that protection. An added index also needs measured evidence rather than an assumption that it will improve performance.

## References

[1] PostgreSQL. [Constraints](https://www.postgresql.org/docs/16/ddl-constraints.html).

[2] PostgreSQL. [Using EXPLAIN](https://www.postgresql.org/docs/16/using-explain.html).

[3] PostgreSQL. [Transaction isolation](https://www.postgresql.org/docs/16/transaction-iso.html).

[4] MongoDB. [Aggregation with $sum](https://www.mongodb.com/docs/manual/reference/operator/aggregation/sum/).

[5] PostgreSQL. [Standby servers and replication](https://www.postgresql.org/docs/16/warm-standby.html).


