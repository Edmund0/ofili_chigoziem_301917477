# Retail POS and Inventory System Normalisation

Author: Chigoziem Edmund Ofili (301917477)

R-101 and R-102 are fictional examples created to explain the design. They are not receipts from the database or reference dataset. Selected fields are shown.

## Key terms

- **Candidate key:** a column or combination that can uniquely identify a row, such as (receipt_number, sku) which uniquely identifies an item.
- **Primary key:** the candidate key chosen as the main identifier.
- **Non-prime attribute:** a column that belongs to none of the candidate keys, such as paid_qty or unit_price_at_sale.

## Starting record

One row represents one receipt. R-101 holds a list of values in each item column: Rice first, then Soap.

| Receipt | Shift | Staff code | First name | Last name | Role | Terminal | Items | Paid qty | Giveaway qty | Unit price | Tax ID | Saved tax % | Discount ID | Saved discount % | Giveaway reason |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-101 | 10 | C001 | Amina | Yusuf | Cashier | T01 | RICE: Rice; SOAP: Soap | 2; 3 | 1; 0 | 1000; 200 | 2; 1 | 5; 0 | 2; 1 | 10; 0 | Buy 2, get 1 free; NULL |
| R-102 | 11 | C002 | Bala | Musa | Cashier | T02 | RICE: Rice | 1 | 0 | 1000 | 2 | 10 | 1 | 0 | NULL |

### Current rates

The receipt keeps its saved rate even when the current rate changes.

| Type | ID | Name | Current rate |
| --- | --- | --- | --- |
| Tax | 1 | No tax | 0% |
| Tax | 2 | Example tax | 10% |
| Discount | 1 | No discount | 0% |
| Discount | 2 | Promotion | 15% |

## First normal form (1NF)

**Requirements**: Each field is **atomic** — it contains one value, not a list or nested table.

**Example**:

- Each product on a receipt has one row.
- The wide table is shown in four parts below.
- All four parts describe the same three rows. They are not separate tables yet.

### Receipt details

| Receipt | SKU | Shift | Staff code | First name | Last name | Role | Terminal |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 10 | C001 | Amina | Yusuf | Cashier | T01 |
| R-101 | SOAP | 10 | C001 | Amina | Yusuf | Cashier | T01 |
| R-102 | RICE | 11 | C002 | Bala | Musa | Cashier | T02 |

### Item details

| Receipt | SKU | Product name | paid_qty | giveaway_qty | unit_price_at_sale | giveaway_reason |
| --- | --- | --- | --- | --- | --- | --- |
| R-101 | RICE | Rice | 2 | 1 | 1000 | Buy 2, get 1 free |
| R-101 | SOAP | Soap | 3 | 0 | 200 | NULL |
| R-102 | RICE | Rice | 1 | 0 | 1000 | NULL |

### Tax details

| Receipt | SKU | tax_id | tax_name | current_tax_percentage | tax_percentage_at_sale |
| --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 2 | Example tax | 10 | 5 |
| R-101 | SOAP | 1 | No tax | 0 | 0 |
| R-102 | RICE | 2 | Example tax | 10 | 10 |

### Discount details

| Receipt | SKU | discount_id | discount_name | current_discount_percentage | discount_percentage_at_sale |
| --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 2 | Promotion | 15 | 10 |
| R-101 | SOAP | 1 | No discount | 0 | 0 |
| R-102 | RICE | 1 | No discount | 0 | 0 |

**Key:** (receipt_number, sku). A product appears once per receipt, with paid and giveaway quantities in the same row.

**Result**:
- Item lists are gone.
- Receipt details still repeat for each product.
- Product names still repeat across receipts.

## Second normal form (2NF)

**Requirements**: 1NF, with every **non-prime attribute** depending on the whole of every candidate key.

**Example**: I initially stored paid items and giveaway items on separate rows in the same table, using `quantity` and `line_type`.

- The key was `(sale_id, product_id, line_type)`, but `unit_price_at_sale` depended only on `(sale_id, product_id)`.
- The price did not depend on `line_type`, so it depended on only part of the key.
- This partial dependency violated 2NF.
- I changed this to one row with `paid_qty` and `giveaway_qty` sharing one price.
- This prevents conflicting shelf prices for the same product on one receipt, without adding a separate shared-price table that could make complex queries inefficient.

**Definition**: A **partial dependency** means a detail depends on only part of a combined key.

- `receipt_number` determines the shift, staff and terminal details.
- `sku` determines `product_name`.
- Quantities, historical price, selected tax/discount and saved percentages describe the product on that particular receipt.

### Sale

**Key:** receipt_number.

| Receipt | Shift | Staff code | First name | Last name | Role | Terminal |
| --- | --- | --- | --- | --- | --- | --- |
| R-101 | 10 | C001 | Amina | Yusuf | Cashier | T01 |
| R-102 | 11 | C002 | Bala | Musa | Cashier | T02 |

### Product

**Key:** sku.

| SKU | Product name |
| --- | --- |
| RICE | Rice |
| SOAP | Soap |

### Sale item

**Key:** (receipt_number, sku). Receipt and SKU link to the two tables above.

| Receipt | SKU | paid_qty | giveaway_qty | unit_price_at_sale | giveaway_reason |
| --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 2 | 1 | 1000 | Buy 2, get 1 free |
| R-101 | SOAP | 3 | 0 | 200 | NULL |
| R-102 | RICE | 1 | 0 | 1000 | NULL |

Tax and discount details are still columns of sale_item at this stage. They are shown separately to keep the table narrow.

#### Tax columns

| Receipt | SKU | tax_id | tax_name | current_tax_percentage | tax_percentage_at_sale |
| --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 2 | Example tax | 10 | 5 |
| R-101 | SOAP | 1 | No tax | 0 | 0 |
| R-102 | RICE | 2 | Example tax | 10 | 10 |

#### Discount columns

| Receipt | SKU | discount_id | discount_name | current_discount_percentage | discount_percentage_at_sale |
| --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 2 | Promotion | 15 | 10 |
| R-101 | SOAP | 1 | No discount | 0 | 0 |
| R-102 | RICE | 1 | No discount | 0 | 0 |

**Result**:
- Receipt details are stored once per receipt.
- Product names are stored once per product.
- Paid and giveaway quantities share one historical shelf price.
- Renaming Rice changes one product row, not every receipt item.

**Historical price**: It stays with the sale item because the same product can have a different price on a later receipt.

## Third normal form (3NF)

**Requirements**: 2NF. Fields that determine another **non-prime attribute** must also identify the whole row.

**Example**:
- The receipt identifies the staff code.
- The staff code identifies the staff name.
- The name belongs with staff, rather than being repeated on each receipt.

**Definition**: A **transitive dependency** means one detail leads to another through a third field.

**Dependencies in the 2NF tables**:
- receipt_number → shift_id → staff_code and terminal_code.
- staff_code → first_name, last_name and role.
- staff_code → role → role permissions.
- tax_id → tax name and current tax percentage.
- discount_id → discount name and current discount percentage.

**Changes**:
- Staff, role and terminal details move to their own tables.
- Shift links the cashier and terminal. Sale keeps `shift_id` for those links.
- Tax and discount definitions move to their own tables.
- Saved percentages stay on `sale_item` because they record what was applied to that item.

**Result**: Changing a staff name or current tax/discount definition changes one record, rather than repeating the change across receipt items.

### Role

**PK:** id.<br>**UK:** name.

| id | name |
| --- | --- |
| 1 | Cashier |

### Staff

**PK:** id.<br>**UK:** staff_code and email, separately.<br>**FK:** role_id → role.id.

| id | staff_code | first_name | last_name | role_id |
| --- | --- | --- | --- | --- |
| 1 | C001 | Amina | Yusuf | 1 |
| 2 | C002 | Bala | Musa | 1 |

### Terminal

**PK:** id.<br>**UK:** terminal_code.

| id | terminal_code |
| --- | --- |
| 1 | T01 |
| 2 | T02 |

### Shift

**PK:** id.<br>**FK:** staff_id → staff.id; terminal_id → terminal.id.

| id | staff_id | terminal_id |
| --- | --- | --- |
| 10 | 1 | 1 |
| 11 | 2 | 2 |

### Sale

**PK:** id.<br>**UK:** receipt_number.<br>**FK:** shift_id → shift.id.

| id | receipt_number | shift_id |
| --- | --- | --- |
| 1 | R-101 | 10 |
| 2 | R-102 | 11 |

### Product

**PK:** id.<br>**UK:** sku.

| id | sku | name |
| --- | --- | --- |
| 1 | RICE | Rice |
| 2 | SOAP | Soap |

### Sale item

**PK:** id.<br>**UK:** (sale_id, product_id).<br>**FK:** sale_id, product_id, tax_id and discount_id → the corresponding tables' id fields.

| id | sale_id | product_id | paid_qty | giveaway_qty | unit_price_at_sale | giveaway_reason |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 2 | 1 | 1000 | Buy 2, get 1 free |
| 2 | 1 | 2 | 3 | 0 | 200 | NULL |
| 3 | 2 | 1 | 1 | 0 | 1000 | NULL |

The following columns belong to the same sale_item rows. They are shown separately to avoid a wide table.

| id | tax_id | tax_percentage_at_sale | discount_id | discount_percentage_at_sale |
| --- | --- | --- | --- | --- |
| 1 | 2 | 5 | 2 | 10 |
| 2 | 1 | 0 | 1 | 0 |
| 3 | 2 | 10 | 1 | 0 |

### Tax

**PK:** id.

| id | name | percentage |
| --- | --- | --- |
| 1 | No tax | 0 |
| 2 | Example tax | 10 |

### Discount

**PK:** id.

| id | name | percentage |
| --- | --- | --- |
| 1 | No discount | 0 |
| 2 | Promotion | 15 |

**Saved percentages**:

- Tax ID 2: R-101 keeps 5%; R-102 keeps 10%. The current rate is 10%.
- Discount ID 2: R-101 keeps its 10% promotion discount. The current rate is 15%.
- Saved percentages are historical facts. Current names and rates stay in the lookup tables.

**Paid and giveaway quantities**:

- Paid quantities determine revenue.
- Giveaway quantities retain their shelf value but generate no revenue or tax charge.

## Match to the final design

The resulting tables are staff, role, terminal, shift, product, sale, sale_item, tax and discount. There is no separate giveaway or shared-price table.

- Generated `id` fields provide the PKs.
- Staff codes, receipt numbers and SKUs remain unique.
- In `sale_item`, `(sale_id, product_id)` remains a candidate key.
- Adding an `id` does not itself establish a normal form.

The examples omit staff email and active status, role permission flags, terminal names, shift times, current product price and stock fields, and sale date and payment method. Their full definitions are in [Design.md](Design.md).
