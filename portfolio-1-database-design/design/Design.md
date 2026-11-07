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
| sale_product | A product on a receipt and its shelf price at the time of sale | Keep one shared price for paid and giveaway lines. |
| sale_item | A paid or giveaway line, its quantity, tax and discount | Record the items sold or given away. |
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

### Sale product

**Design Assumption**: Paid and giveaway lines for the same product on one receipt share one shelf price.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| sale_id | BIGINT | Required; foreign key to sale.id; unique with product_id |
| product_id | BIGINT | Required; foreign key to product.id |
| unit_price_at_sale | NUMERIC(10,2) | Required; shelf price at the time of sale; above zero |

### Sale item

**Design Assumption**: Each line has one tax and one percentage discount. A line is either paid or a giveaway.

| Attribute | PostgreSQL type | Key or requirement |
| --- | --- | --- |
| id | BIGINT | Primary key; generated automatically |
| sale_product_id | BIGINT | Required; foreign key to sale_product.id; unique with line_type |
| quantity | INTEGER | Required; above zero |
| line_type | VARCHAR(10) | Required; paid or giveaway |
| giveaway_reason | VARCHAR(80) | Required and not blank for giveaways; NULL for paid lines |
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
| sale → sale_product | One to many | A sale has one or more products. Each sale_product belongs to one sale. |
| product → sale_product | One to many | A product can appear on zero or more receipts. Each sale_product refers to one product. |
| sale_product → sale_item | One to many | Each receipt product has a paid line, a giveaway line or both. Each sale_item belongs to one sale_product. |
| tax → sale_item | One to many | A tax can be used on zero or more sale lines. Each line has one tax, including the 0% default. |
| discount → sale_item | One to many | A discount can be used on zero or more sale lines. Each line has one discount, including the 0% default. |

## Business rules and constraints

Business rules are listed in [CaseStudy.md](CaseStudy.md).

| Rule | Constraint or operation |
| --- | --- |
| 1. Staff identifiers | UNIQUE on staff_code and email. A required foreign key links staff.role_id to role.id. |
| 1. Role permissions | The operation checks the staff member's role flags before allowing the action. The foreign key alone does not check permissions. |
| 2. Terminal code | UNIQUE on terminal_code. |
| 3. Products | UNIQUE on sku. CHECK unit_price > 0, stock_qty >= 0 and reorder_level >= 0. |
| 4. Shift links | Required foreign keys link each shift to staff and terminal. |
| 4. Shift closing time | CHECK closed_at IS NULL OR closed_at > opened_at. |
| 4. One open shift | A unique index on terminal_id applies only where closed_at IS NULL. |
| 5. Sale details | UNIQUE on receipt_number. A required foreign key links the sale to its shift. CHECK payment_method is cash, card or transfer. |
| 5. Completed sales | The transaction checks that the sale is complete, has products and that each sale_product has at least one line. Foreign keys alone cannot require child records. |
| 6. Shared shelf price | Required foreign keys link sale_product to sale and product. UNIQUE on (sale_id, product_id). CHECK unit_price_at_sale > 0. |
| 6. Sale lines | Required foreign keys link each line to sale_product, tax and discount. CHECK quantity > 0. |
| 6. Paid or giveaway | CHECK line_type is paid or giveaway. UNIQUE on (sale_product_id, line_type). |
| 6, 8, 9. Historical values | Save the shelf price on sale_product and the applied tax and discount percentages on sale_item. Editing lookup rates does not change past receipts. |
| 7. Giveaway reason | CHECK the reason is not blank for a giveaway and is NULL for a paid line. |
| 5, 7, 9. Receipt calculations | Apply discount before tax on paid lines. Revenue excludes tax. Giveaway lines have zero revenue and zero tax charge. |
| 8, 9. Default tax and discount | Seed one 0% record in each table. The foreign-key defaults use those records' IDs. |
| 8, 9. Used lookup records | Foreign keys with ON DELETE RESTRICT prevent deleting tax or discount records used on sale lines. |
| 10. Stock and transactions | Save the sale, sale products, lines and stock changes in one transaction. Reject the whole sale if stock is insufficient or any part fails. CHECK stock_qty >= 0 is the safety net. |
