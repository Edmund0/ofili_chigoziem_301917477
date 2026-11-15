# Retail POS and Inventory System Normalisation

Author: Chigoziem Edmund Ofili (301917477)

In order to explain the normalization process and why the database system satisfies the normal forms, we shall shart with an example where the requirements where normal forms are not met.

## Key terms

- **Primary key:** the candidate key chosen as the main identifier.
- **Candidate key:** a column (or combination of columns) that can uniquely identify a row.
- **Non-prime attribute:** a column that belongs to none of the candidate keys.

## Starting record

One row represents one receipt and contains all the information associated with that receipt.

| Receipt | SKU | Shift ID | Staff code | First name | Last name | Role | Terminal code | Product name | Paid qty | Giveaway qty | Unit price | Giveaway reason | Tax ID | Tax name | Current tax % | Saved tax % | Discount ID | Discount name | Current discount % | Saved discount % |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-101 | RICE; SOAP | 10 | C001 | Amina | Yusuf | Cashier | T01 | Rice; Soap | 2; 3 | 1; 0 | 1000; 200 | Buy 2, get 1 free; NULL | 2; 1 | Example tax; No tax | 10; 0 | 5; 0 | 2; 1 | Promotion; No discount | 15; 0 | 10; 0 |
| R-102 | RICE | 11 | C002 | Bala | Musa | Cashier | T02 | Rice | 1 | 0 | 1000 | NULL | 2 | Example tax | 10 | 10 | 1 | No discount | 0 | 0 |

### Current rates

The receipt keeps its saved rate even when tax/discount records changes.

| Type | ID | Name | Current rate |
| --- | --- | --- | --- |
| Tax | 1 | No tax | 0% |
| Tax | 2 | Example tax | 10% |
| Discount | 1 | No discount | 0% |
| Discount | 2 | Promotion | 15% |

## First normal form (1NF)

**Requirements**: Each field is **atomic**. It contains one value, not a list nor nested table.

**Example**:

- Each product on a receipt must have one row.

| Receipt | SKU | Shift ID | Staff code | First name | Last name | Role | Terminal code | Product name | Paid qty | Giveaway qty | Unit price | Giveaway reason | Tax ID | Tax name | Current tax % | Saved tax % | Discount ID | Discount name | Current discount % | Saved discount % |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 10 | C001 | Amina | Yusuf | Cashier | T01 | Rice | 2 | 1 | 1000 | Buy 2, get 1 free | 2 | Example tax | 10 | 5 | 2 | Promotion | 15 | 10 |
| R-101 | SOAP | 10 | C001 | Amina | Yusuf | Cashier | T01 | Soap | 3 | 0 | 200 | NULL | 1 | No tax | 0 | 0 | 1 | No discount | 0 | 0 |
| R-102 | RICE | 11 | C002 | Bala | Musa | Cashier | T02 | Rice | 1 | 0 | 1000 | NULL | 2 | Example tax | 10 | 10 | 1 | No discount | 0 | 0 |

**Key:** (Receipt, SKU). A product appears once per receipt, with paid and giveaway quantities in the same row.

**Result**:
- Item lists are gone.
- Some information are repeated on the rows.

## Second normal form (2NF)

**Requirements**: 1NF, with every **non-prime attribute** depending on the whole of every **candidate key**.

**Problem During the Design Phase**: I initially stored paid items and giveaway items on separate rows in the same table, using `quantity` and `Line type`.

- The candidate key was `(Sale ID, Product ID, Line type)`.
- The `Unit price` depended only on `(Sale ID, Product ID)` which violated 2NF.
- This was a partial dependency situation.
- I changed this to one row with `Paid qty` and `Giveaway qty` sharing one price.

This prevents conflicting shelf prices for the same product on one receipt, without adding a separate shared-price table that could make complex queries inefficient.

**Definition**: A **partial dependency** means a detail depends on only part of a combined **candidate key**.

- `Receipt` determines the shift, staff and terminal details.
- `SKU` determines `Product name`.
- Quantities, historical price, selected tax/discount and saved percentages describe the product on that particular receipt.

### Example: Sale

**Key:** Receipt.

| Receipt | Shift ID | Staff code | First name | Last name | Role | Terminal code |
| --- | --- | --- | --- | --- | --- | --- |
| R-101 | 10 | C001 | Amina | Yusuf | Cashier | T01 |
| R-102 | 11 | C002 | Bala | Musa | Cashier | T02 |

### Example: Product

**Key:** SKU.

| SKU | Product name |
| --- | --- |
| RICE | Rice |
| SOAP | Soap |

### Example: Sale item

**Key:** (Receipt, SKU). Receipt and SKU link to the two tables above.

| Receipt | SKU | Paid qty | Giveaway qty | Unit price | Giveaway reason | Tax ID | Tax name | Current tax % | Saved tax % | Discount ID | Discount name | Current discount % | Saved discount % |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-101 | RICE | 2 | 1 | 1000 | Buy 2, get 1 free | 2 | Example tax | 10 | 5 | 2 | Promotion | 15 | 10 |
| R-101 | SOAP | 3 | 0 | 200 | NULL | 1 | No tax | 0 | 0 | 1 | No discount | 0 | 0 |
| R-102 | RICE | 1 | 0 | 1000 | NULL | 2 | Example tax | 10 | 10 | 1 | No discount | 0 | 0 |

### Example: Result

- Receipt details are stored once per receipt.
- Product names are stored once per product.
- Renaming Rice changes one product row, not every receipt item.

**Historical price**: The sale item records the price of a product at the time of purchase because the product records may be changed later.

## Third normal form (3NF)

**Requirements**: 2NF. Every **non-prime attribute** must depend on a **candidate key**, without a transitive dependency through another non-prime attribute.

**Definition**: A **transitive dependency** means one detail determines another due to a third field.

**Example**:
- The receipt number determines the staff code.
- The staff code determines the staff name.
- The staff code and staff name should be separated from the table.

**Dependencies in the 2NF tables**:
- Receipt → Shift ID → Staff code and Terminal code.
- Staff code → First name, Last name and role.
- Staff code → role → role permissions.
- Tax ID → tax name and current tax percentage.
- Discount ID → discount name and current discount percentage.

**Changes**:
- Staff, role and terminal details move to their own tables.
- Shift links the cashier and terminal. Sale keeps `Shift ID` for those links.
- Tax and discount definitions move to their own tables.

**Result**: If we change a staff name or current tax/discount definition, we only change the one record rather than repeating the change across receipt items.

### Role

**PK:** id.<br>**UK:** name.

| ID | Role |
| --- | --- |
| 1 | Cashier |

### Staff

**PK:** id.<br>**UK:** Staff code and email, separately.<br>**FK:** Role ID → role.id.

| ID | Staff code | First name | Last name | Role ID |
| --- | --- | --- | --- | --- |
| 1 | C001 | Amina | Yusuf | 1 |
| 2 | C002 | Bala | Musa | 1 |

### Terminal

**PK:** id.<br>**UK:** Terminal code.

| ID | Terminal code |
| --- | --- |
| 1 | T01 |
| 2 | T02 |

### Shift

**PK:** id.<br>**FK:** Staff ID → staff.id; Terminal ID → terminal.id.

| ID | Staff ID | Terminal ID |
| --- | --- | --- |
| 10 | 1 | 1 |
| 11 | 2 | 2 |

### Sale

**PK:** id.<br>**UK:** Receipt.<br>**FK:** Shift ID → shift.id.

| ID | Receipt | Shift ID |
| --- | --- | --- |
| 1 | R-101 | 10 |
| 2 | R-102 | 11 |

### Product

**PK:** id.<br>**UK:** SKU.

| ID | SKU | Product name |
| --- | --- | --- |
| 1 | RICE | Rice |
| 2 | SOAP | Soap |

### Sale item

**PK:** id.<br>**UK:** (Sale ID, Product ID).<br>**FK:** Sale ID, Product ID, Tax ID and Discount ID → the corresponding tables' id fields.

| ID | Sale ID | Product ID | Paid qty | Giveaway qty | Unit price | Giveaway reason | Tax ID | Saved tax % | Discount ID | Saved discount % |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 2 | 1 | 1000 | Buy 2, get 1 free | 2 | 5 | 2 | 10 |
| 2 | 1 | 2 | 3 | 0 | 200 | NULL | 1 | 0 | 1 | 0 |
| 3 | 2 | 1 | 1 | 0 | 1000 | NULL | 2 | 10 | 1 | 0 |

### Tax

**PK:** id.

| ID | Tax name | Current tax % |
| --- | --- | --- |
| 1 | No tax | 0 |
| 2 | Example tax | 10 |

### Discount

**PK:** id.

| ID | Discount name | Current discount % |
| --- | --- | --- |
| 1 | No discount | 0 |
| 2 | Promotion | 15 |

**Saved percentages**:

The tax rates and the discount rates at the time of purchase may differ from the values stored in the tax table and the discount table. Including those columns in the sales items table does not create a **transitive dependency**.

## Match to the final design

The resulting tables are staff, role, terminal, shift, product, sale, sale item, tax and discount. The example omitted some columns, such as email and active status, for simplicity.