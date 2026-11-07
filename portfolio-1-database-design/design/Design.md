# Retail POS and Inventory System Database Design

Author: Chigoziem Edmund Ofili (301917477)

## Entities

I have chosen the following entities for my project.

| Entity | Information stored | Why we need it |
| --- | --- | --- |
| staff | A cashier or supervisor | Keep track of staff. |
| role | A staff role and its allowed actions | Control what staff can do. |
| terminal | A checkout terminal | Identify the checkout used. |
| shift | A cashier's work session on a terminal | Link sales to a cashier and checkout. |
| product | A product, its price and stock quantity | Keep track of inventory. |
| sale | A receipt, its date, shift and payment method | Keep track of completed sales. |
| sale_item | A product on a receipt, its paid and giveaway quantities, shelf price, tax and discount | Record the items sold or given away. |
| tax | A valid tax name and percentage | Keep a list of valid tax rates. |
| discount | A valid discount name and percentage | Keep a list of valid discounts. |

## Attributes and keys

**Glossary**

- **PK:** primary key; identifies each record.
- **FK:** foreign key; links to a record in another table.
- **U:** unique; cannot repeat. Mermaid uses **UK** for this marker.
- **R:** required; cannot be `NULL`.
- **U1:** fields that are unique together, not individually.
- **Default:** used when no value is supplied.

### Staff

**Design Assumption**: Each staff member has one role. User login is outside scope.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| staff_code | VARCHAR(20) | Required; unique |
| email | VARCHAR(254) | Required; unique |
| first_name | VARCHAR(60) | Required |
| last_name | VARCHAR(60) | Required |
| role_id | BIGINT | Required; foreign key to role.id |
| active_status | BOOLEAN | Required; defaults to true |

### Role

**Design Assumption**: Access is role-based. Staff with the same role have the same permissions.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| name | VARCHAR(30) | Required; unique |
| can_operate_till | BOOLEAN | Required; defaults to false; open shifts and record sales or giveaways |
| can_manage_products | BOOLEAN | Required; defaults to false; maintain products and receive stock |
| can_manage_staff | BOOLEAN | Required; defaults to false |
| can_manage_terminals | BOOLEAN | Required; defaults to false |
| can_view_reports | BOOLEAN | Required; defaults to false |

### Terminal

**Design Assumption**: The system covers one store with two checkout terminals.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| terminal_code | VARCHAR(20) | Required; unique |
| name | VARCHAR(80) | Required |

### Shift

**Design Assumption**: Each shift has one cashier and one terminal.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| staff_id | BIGINT | Required; foreign key to staff.id |
| terminal_id | BIGINT | Required; foreign key to terminal.id |
| opened_at | TIMESTAMPTZ | Required |
| closed_at | TIMESTAMPTZ | Optional; after opened_at when present |

### Product

**Design Assumption**: Stock is counted in whole units.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| sku | VARCHAR(30) | Required; unique |
| name | VARCHAR(150) | Required |
| unit_price | NUMERIC(10,2) | Required; above zero |
| stock_qty | INTEGER | Required; zero or above |
| reorder_level | INTEGER | Required; zero or above |

### Sale

**Design Assumption**: Only completed, fully paid sales are saved. No drafts, partial payments or refunds.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| receipt_number | VARCHAR(30) | Required; unique |
| shift_id | BIGINT | Required; foreign key to shift.id |
| sold_at | TIMESTAMPTZ | Required |
| payment_method | VARCHAR(10) | Required; cash, card or transfer |

### Sale item

**Design Assumption**: One row per product on a receipt. Paid and giveaway quantities share one shelf price.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| sale_id | BIGINT | Required; foreign key to sale.id; unique with product_id |
| product_id | BIGINT | Required; foreign key to product.id |
| unit_price_at_sale | NUMERIC(10,2) | Required; shelf price at the time of sale; above zero |
| paid_qty | INTEGER | Required; defaults to 0; zero or above |
| giveaway_qty | INTEGER | Required; defaults to 0; zero or above |
| giveaway_reason | VARCHAR(80) | Required and not blank when giveaway_qty > 0; otherwise NULL |
| tax_id | BIGINT | Required; foreign key to tax.id; defaults to the 0% tax record |
| tax_percentage_at_sale | NUMERIC(5,2) | Required; keeps the tax percentage applied at the time of sale |
| discount_id | BIGINT | Required; foreign key to discount.id; defaults to the 0% discount record |
| discount_percentage_at_sale | NUMERIC(5,2) | Required; defaults to 0; keeps the percentage applied |

### Tax

**Design Assumption**: One seeded 0% tax record serves as the default. Tax rates can be edited; saved sale-line percentages do not change.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| name | VARCHAR(60) | Required |
| percentage | NUMERIC(5,2) | Required; 0 means no tax |

### Discount

**Design Assumption**: One seeded 0% discount record serves as the default. Discount rates can be edited; saved sale-line percentages do not change.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| name | VARCHAR(60) | Required |
| percentage | NUMERIC(5,2) | Required |

## Relationships

| Tables linked | Relationship | Meaning |
| --- | --- | --- |
| role → staff | One to many | A role can have zero or more staff. Each staff member has one role. |
| staff → shift | One to many | A staff member can work zero or more shifts. Each shift has one cashier. |
| terminal → shift | One to many over time | A terminal can have zero or more shifts. Each shift uses one terminal. |
| shift → sale | One to many | A shift can have zero or more sales. Each sale belongs to one shift. |
| sale → sale_item | One to many | A sale has at least one item. Each item belongs to one sale. |
| product → sale_item | One to many | A product can appear on zero or more receipts. Each item has one product. |
| tax → sale_item | One to many | A tax can be used on zero or more items. Each item has one tax, including the 0% default. |
| discount → sale_item | One to many | A discount can be used on zero or more items. Each item has one discount, including the 0% default. |

## Business rules and constraints

Business rules are listed in [CaseStudy.md](CaseStudy.md).

| Rule | Constraint or operation |
| --- | --- |
| 1. Staff identifiers | UNIQUE: staff_code; email.<br>Required FK: role_id → role.id. |
| 1. Role permissions | Check role flags before each action.<br>FK does not enforce permissions. |
| 2. Terminal code | UNIQUE: terminal_code. |
| 3. Products | UNIQUE: sku.<br>CHECK: unit_price > 0; stock_qty >= 0; reorder_level >= 0. |
| 4. Shift links | Required FKs:<br>staff_id → staff.id<br>terminal_id → terminal.id |
| 4. Shift closing time | CHECK: closed_at IS NULL OR closed_at > opened_at. |
| 4. One open shift | UNIQUE index on terminal_id WHERE closed_at IS NULL. |
| 5. Sale details | UNIQUE: receipt_number.<br>Required FK: shift_id → shift.id.<br>CHECK: payment_method IN ('cash', 'card', 'transfer'). |
| 5. Completed sales | Transaction validates completion and at least one sale_item.<br>FK cannot require child rows. |
| 6. Item links | Required FKs:<br>sale_id → sale.id<br>product_id → product.id<br>tax_id → tax.id<br>discount_id → discount.id |
| 6. Item values | CHECK: unit_price_at_sale > 0.<br>CHECK: paid_qty >= 0 AND giveaway_qty >= 0.<br>CHECK: paid_qty > 0 OR giveaway_qty > 0. |
| 6. One product per receipt | UNIQUE (sale_id, product_id).<br>One shelf price for both quantities. |
| 6, 8, 9. Historical values | Save shelf price and applied tax/discount rates on sale_item.<br>Lookup edits leave saved values unchanged. |
| 7. Giveaway reason | CHECK: reason NOT NULL and non-blank if giveaway_qty > 0;<br>reason IS NULL if giveaway_qty = 0. |
| 5, 7, 9. Receipt calculations | Paid value = paid_qty × unit_price_at_sale.<br>Apply discount, then tax.<br>Revenue excludes tax.<br>Giveaway revenue and tax = 0. |
| 8, 9. Default tax and discount | Seed one 0% tax and one 0% discount.<br>Default tax_id and discount_id to those record IDs. |
| 8, 9. Used lookup records | FKs with ON DELETE RESTRICT protect referenced tax/discount records. |
| 10. Stock and transactions | Stock reduction = paid_qty + giveaway_qty.<br>Save sale, items and stock changes in one transaction.<br>ROLLBACK if stock is insufficient or any step fails.<br>CHECK: stock_qty >= 0 as a safety net. |
