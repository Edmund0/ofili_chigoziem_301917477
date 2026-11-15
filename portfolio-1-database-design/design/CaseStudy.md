# Portfolio 1 Database Design and Modelling

## Case study

GoodNaija, a growing supermarket in downtown Lagos, is in need of a point-of-sale (POS) and inventory tracking system. They require cashiers to be able to open their shifts on their assigned terminal, record sales, and close their shift at the end of the day. The system keeps track of the inventory in stock as produce are sold and received. 

## Part 1: User Requirements

#### Store Cashiers

- Open and close shifts on a terminal.
- Record sales and giveaways.

#### Store Supervisors

- Add staff and terminals.
- Maintain products and prices.
- Receive deliveries.
- Review daily sales, giveaway, and low-stock reports.

## Part 2: Business Requirements

### Main operations

1. The system can open/close a shift on a terminal.
2. The system can record a sale with multiple items.
3. The system can accept different payment methods (ex. cash, card or transfer).
4. The system can accept new stock and view a receipt total.
5. The system can list products at or below their reorder level.
6. The system can report revenue by day and payment method.
7. The system can cashiers can give items away.

## Part 3: Business Rules and Constraints

#### 1. Roles

- Each role has a unique `name`.
- Each role lists the `actions` staff can perform.

#### 2. Staff

- Each staff member has a unique `staff code` and `email address`.
- Each staff member is assigned a `role` (RBAC),

#### 3. Terminals

- Each terminal has a unique `terminal code`.
- Each terminal can have at most one open `shift` at a time.

#### 4. Shifts

- Each `shift` belongs to one `terminal` and one `cashier`.
- Each `shift` can only close after its opening time.

#### 5. Sales

- Each sale has a unique `receipt number`.
- Each sale belongs to one existing `shift`.
- Each sale can be paid by cash, card or transfer.
- Each sale must have at least one `sale item`.
- Sales revenue uses `paid_qty` after `discounts` and excludes `tax`.
- Only completed sales are saved.

#### 6. Sale items and giveaways

- Each product can only appear once per `sale`.
- Each `sale item` records the `paid_qty` and `giveaway_qty` for that `product`.
- Each `sale item` can never have a `paid_qty` or `giveaway_qty` below zero.
- Each `sale item` must have a `paid_qty` or `giveaway_qty` above zero.
- The `paid_qty` and `giveaway_qty` use the same saved `price` for that `product`.
- If `giveaway_qty` is above zero, a `reason` is required, otherwise will be `NULL`.
- The product's stock level is reduced by `paid_qty` + `giveaway_qty`.
- The `giveaway_qty` is not charged, has no discount, has no tax, and is not counted in sales revenue.

#### 7. Products

- Each product has a unique `SKU` and a `price` above zero.
- Each product can never have a stock `quantity` below zero.
- Each `sale item` uses one valid product record.
- Each `sale item` keeps the product price used at the time of sale.
- Product records can be updated without changing past receipts.
- Product records cannot be deleted if they have been used on a `sale item`.

#### 8. Taxes

- The default tax is 0%.
- Each `sale item` uses one valid tax record, including the 0% default.
- Each `sale item` keeps the tax percentage used at the time of sale.
- Tax is applied **after discount** to the paid quantity.
- Tax is applied per `sale item`.
- Tax records can be updated without changing past receipts.
- Tax records cannot be deleted if it has been used on a `sale item`.

#### 9. Discounts

- The default discount is 0%.
- Each `sale item` uses one valid discount record, including the 0% default.
- Each `sale item` keeps the discount percentage used at the time of sale.
- Discount is applied **before tax** to the paid quantity.
- Discount is applied per `sale item`.
- Discount records can be updated without changing past receipts.
- Discount records cannot be deleted if it has been used on a `sale item`.

#### 10. Transactions

- A `sale`, its `sale item`, and its stock changes are saved in one transaction.
- If any `sale item` would make stock negative, the whole `sale` is rejected.
- If any part fails, no part of the `sale` is saved.

## Part 4: Design Scope

**In scope**: The entities identified in the requirements are: staff, roles, terminals, shifts, products, sales, sale items, taxes, and discounts. 

**Out of scope**: Features not in-scope include: suppliers as a table, refunds, loyalty points, card processing, user login, and fixed-amount discounts.
