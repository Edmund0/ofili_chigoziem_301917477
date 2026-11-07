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
| sale_item | A paid or giveaway line, its product, quantity, price, tax and discount | Record the items sold or given away. |
| tax | A valid tax name and percentage | Keep a list of valid tax rates. |
| discount | A valid discount name and percentage | Keep a list of valid discounts. |

## Attributes and keys

- **Required:** cannot be `NULL`.
- **Unique:** cannot repeat.
- **Primary key:** identifies each record.
- **Foreign key:** links to a record in another table.
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

**Design Assumption**: Each line has one tax and one percentage discount. A line is either paid or a giveaway.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| sale_id | BIGINT | Required; foreign key to sale.id |
| product_id | BIGINT | Required; foreign key to product.id |
| quantity | INTEGER | Required; above zero |
| unit_price_at_sale | NUMERIC(10,2) | Required; shelf price at the time of sale; above zero |
| line_type | VARCHAR(10) | Required; paid or giveaway |
| giveaway_reason | VARCHAR(80) | Required and not blank for giveaways; NULL for paid lines |
| tax_id | BIGINT | Required; foreign key to tax.id; defaults to the 0% tax record |
| tax_percentage_at_sale | NUMERIC(5,2) | Required; keeps the tax percentage applied at the time of sale |
| discount_id | BIGINT | Required; foreign key to discount.id; defaults to the 0% discount record |
| discount_percentage_at_sale | NUMERIC(5,2) | Required; defaults to 0; keeps the percentage applied |

### Tax

**Design Assumption**: One seeded 0% tax record serves as the default.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| name | VARCHAR(60) | Required |
| percentage | NUMERIC(5,2) | Required; 0 means no tax |

### Discount

**Design Assumption**: One seeded 0% discount record serves as the default.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| name | VARCHAR(60) | Required |
| percentage | NUMERIC(5,2) | Required |

## Relationships

| Tables linked | Relationship | Meaning |
| --- | --- | --- |
| [Tables] | [One to one / one to many / many to many] | [How the records connect] |

## Business rules and constraints

Business rules are listed in [CaseStudy.md](CaseStudy.md).

| Rule | Constraint or operation |
| --- | --- |
| [Rule number] | [How it is enforced] |
