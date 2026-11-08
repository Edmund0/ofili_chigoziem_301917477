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

## References

Reference: [SQL Tutorial cheat sheet (with downloadable PDF)](https://www.sqltutorial.org/sql-cheat-sheet/).

Reference: [W3Schools SQL quick reference](https://www.w3schools.com/sql/sql_quickref.asp).

Reference: [PostgreSQL 16 constraints](https://www.postgresql.org/docs/16/ddl-constraints.html).

Reference: [VALUES lists](https://www.postgresql.org/docs/16/queries-values.html).

Reference: [UPDATE with RETURNING](https://www.postgresql.org/docs/16/dml-returning.html).

Reference: [Transaction example](https://www.postgresql.org/docs/16/tutorial-transactions.html).

Reference: [Partial unique index, Example 11.3](https://www.postgresql.org/docs/16/indexes-partial.html).

Reference: [FOR UPDATE row locking](https://www.postgresql.org/docs/16/explicit-locking.html#LOCKING-ROWS).
