# Design Dictionary

Author: Chigoziem Edmund Ofili (301917477)

## Glossary

- **PK (primary key):** identifies each record.
- **FK (foreign key):** links to a record in another table.
- **U:** unique; cannot repeat. Mermaid uses **UK** for this marker.
- **R:** required; cannot be `NULL`.
- **U1:** fields that are unique together, not individually.
- **Default:** used when no value is supplied.

Business rules are listed in [CaseStudy.md](CaseStudy.md).

<br>

## 1. Role Entity

**Design Assumption**: The database system uses role-based accesss control (RBAC).

### Attributes and keys

| Attribute            | PostgreSQL type | Key or requirement |
| ---                  | ---             | --- |
| id                   | BIGINT          | Primary key; generated automatically |
| name                 | VARCHAR(30)     | Required; unique |
| can_operate_till     | BOOLEAN         | Required;<br>defaults to false;<br>open shifts and record sales or giveaways |
| can_manage_products  | BOOLEAN         | Required;<br>defaults to false;<br>maintain products and receive stock |
| can_manage_staff     | BOOLEAN         | Required; defaults to false |
| can_manage_terminals | BOOLEAN         | Required; defaults to false |
| can_view_reports     | BOOLEAN         | Required; defaults to false |

### Constraints and rules

| Rule                | Constraint or Business Rules |
| ---                 | --- |
| 1. Role permissions | Check role flags before each action.<br>FK does not enforce permissions. |

<br>

## 2. Staff Entity

**Design Assumption**: Each staff member has one role. User login is outside scope.

### Attributes and keys

| Attribute     | PostgreSQL type | Key or requirement |
| ---           | ---             | --- |
| id            | BIGINT          | Primary key; generated automatically |
| staff_code    | VARCHAR(20)     | Required; unique |
| email         | VARCHAR(254)    | Required; unique |
| first_name    | VARCHAR(60)     | Required |
| last_name     | VARCHAR(60)     | Required |
| role_id       | BIGINT          | Required; foreign key to role.id |
| active_status | BOOLEAN         | Required; defaults to true |

### Constraints and rules

| Rule                 | Constraint or Business Rules |
| ---                  | --- |
| 1. Staff identifiers | UNIQUE: staff_code;<br>email.<br>Required FK: role_id → role.id. |

<br>

## 3. Terminal Entity

**Design Assumption**: The system covers one store with two checkout terminals.

### Attributes and keys

| Attribute     | PostgreSQL type | Key or requirement |
| ---           | ---             | --- |
| id            | BIGINT          | Primary key; generated automatically |
| terminal_code | VARCHAR(20)     | Required; unique |
| name          | VARCHAR(80)     | Required |

### Constraints and rules

| Rule             | Constraint or Business Rules |
| ---              | --- |
| 2. Terminal code | UNIQUE: terminal_code. |

<br>

## 4. Shift Entity

**Design Assumption**: Each shift has one cashier and one terminal.

### Attributes and keys

| Attribute   | PostgreSQL type | Key or requirement |
| ---         | ---             | --- |
| id          | BIGINT          | Primary key; generated automatically |
| staff_id    | BIGINT          | Required; foreign key to staff.id |
| terminal_id | BIGINT          | Required; foreign key to terminal.id |
| opened_at   | TIMESTAMPTZ     | Required |
| closed_at   | TIMESTAMPTZ     | Optional; after opened_at when present |

### Constraints and rules

| Rule                  | Constraint or Business Rules |
| ---                   | --- |
| 4. Shift links        | Required FKs:<br>staff_id → staff.id<br>terminal_id → terminal.id |
| 4. Shift closing time | CHECK: closed_at IS NULL OR closed_at > opened_at. |
| 4. One open shift     | UNIQUE index on terminal_id WHERE closed_at IS NULL. |

<br>

## 5. Product Entity

**Design Assumption**: Stock is counted in whole units.

### Attributes and keys

| Attribute     | PostgreSQL type | Key or requirement |
| ---           | ---             | --- |
| id            | BIGINT          | Primary key; generated automatically |
| sku           | VARCHAR(30)     | Required; unique |
| name          | VARCHAR(150)    | Required |
| unit_price    | NUMERIC(10,2)   | Required; above zero |
| stock_qty     | INTEGER         | Required; zero or above |
| reorder_level | INTEGER         | Required; zero or above |

### Constraints and rules

| Rule        | Constraint or Business Rules |
| ---         | --- |
| 3. Products | UNIQUE: sku.<br>CHECK: unit_price > 0;<br>stock_qty >= 0;<br>reorder_level >= 0. |

<br>

## 6. Tax Entity

**Design Assumption**: One seeded 0% tax record serves as the default. Tax rates can be edited; saved sale-line percentages do not change.

### Attributes and keys

| Attribute  | PostgreSQL type | Key or requirement |
| ---        | ---             | --- |
| id         | BIGINT          | Primary key; generated automatically |
| name       | VARCHAR(60)     | Required |
| percentage | NUMERIC(5,2)    | Required; 0 means no tax |

### Constraints and rules

| Rule           | Constraint or Business Rules |
| ---            | --- |
| 8. Default tax | Seed one 0% tax. |

<br>

## 7. Discount Entity

**Design Assumption**: One seeded 0% discount record serves as the default. Discount rates can be edited; saved sale-line percentages do not change.

### Attributes and keys

| Attribute  | PostgreSQL type | Key or requirement |
| ---        | ---             | --- |
| id         | BIGINT          | Primary key; generated automatically |
| name       | VARCHAR(60)     | Required |
| percentage | NUMERIC(5,2)    | Required |

### Constraints and rules

| Rule                | Constraint or Business Rules |
| ---                 | --- |
| 9. Default discount | Seed one 0% discount. |

<br>

## 8. Sale Entity

**Design Assumption**: Only completed, fully paid sales are saved. No drafts, partial payments or refunds.

### Attributes and keys

| Attribute      | PostgreSQL type | Key or requirement |
| ---            | ---             | --- |
| id             | BIGINT          | Primary key; generated automatically |
| receipt_number | VARCHAR(30)     | Required; unique |
| shift_id       | BIGINT          | Required; foreign key to shift.id |
| sold_at        | TIMESTAMPTZ     | Required |
| payment_method | VARCHAR(10)     | Required; cash, card or transfer |

### Constraints and rules

| Rule            | Constraint or Business Rules |
| ---             | --- |
| 5. Sale details | UNIQUE: receipt_number.<br>Required FK: shift_id → shift.id.<br>CHECK: payment_method IN ('cash', 'card', 'transfer'). |

<br>

## 9. Sale item Entity

**Design Assumption**: One row per product on a receipt. Paid and giveaway quantities share one shelf price.

### Attributes and keys

| Attribute                   | PostgreSQL type | Key or requirement |
| ---                         | ---             | --- |
| id                          | BIGINT          | Primary key; generated automatically |
| sale_id                     | BIGINT          | Required; foreign key to sale.id; unique with product_id |
| product_id                  | BIGINT          | Required; foreign key to product.id |
| unit_price_at_sale          | NUMERIC(10,2)   | Required; shelf price at the time of sale; above zero |
| paid_qty                    | INTEGER         | Required; defaults to 0; zero or above |
| giveaway_qty                | INTEGER         | Required; defaults to 0; zero or above |
| giveaway_reason             | VARCHAR(80)     | Required and not blank when giveaway_qty > 0; otherwise NULL |
| tax_id                      | BIGINT          | Required;<br>foreign key to tax.id;<br>defaults to the 0% tax record |
| tax_percentage_at_sale      | NUMERIC(5,2)    | Required;<br>keeps the tax percentage applied at the time of sale |
| discount_id                 | BIGINT          | Required;<br>foreign key to discount.id;<br>defaults to the 0% discount record |
| discount_percentage_at_sale | NUMERIC(5,2)    | Required; defaults to 0; keeps the percentage applied |

### Constraints and rules

| Rule                          | Constraint or Business Rules |
| ---                           | --- |
| 6. Item links                 | Required FKs:<br>sale_id → sale.id<br>product_id → product.id<br>tax_id → tax.id ON DELETE RESTRICT<br>discount_id → discount.id ON DELETE RESTRICT |
| 6. Item values                | CHECK: unit_price_at_sale > 0.<br>CHECK: paid_qty >= 0 AND giveaway_qty >= 0.<br>CHECK: paid_qty > 0 OR giveaway_qty > 0. |
| 6. One product per receipt    | UNIQUE (sale_id, product_id).<br>One shelf price for both quantities. |
| 6, 8, 9. Historical values    | Save shelf price and applied tax/discount rates on sale_item.<br>Lookup edits leave saved values unchanged. |
| 7. Giveaway reason            | CHECK: reason NOT NULL and non-blank if giveaway_qty > 0;<br>reason IS NULL if giveaway_qty = 0. |
| 8. Default tax reference      | Default tax_id to the 0% tax record ID. |
| 9. Default discount reference | Default discount_id to the 0% discount record ID. |
| 5, 7, 9. Receipt calculations | Paid value = paid_qty × unit_price_at_sale.<br>Apply discount, then tax.<br>Revenue excludes tax.<br>Giveaway revenue and tax = 0. |
| 10. Stock reduction           | Stock reduction = paid_qty + giveaway_qty. |

<br>

## Transaction rules

| Rule                       | Constraint or Business Rules |
| ---                        | --- |
| 5. Completed sales         | Transaction validates completion and at least one sale_item.<br>FK cannot require child rows. |
| 10. Stock and transactions | Save sale, items and stock changes in one transaction.<br>ROLLBACK if stock is insufficient or any step fails. |
