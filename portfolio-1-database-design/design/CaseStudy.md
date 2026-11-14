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

## Main operations

1. The system can open/close a shift on a terminal.
2. The system can record a sale with multiple items.
3. The system can accept different payment methods (ex. cash, card or transfer).
4. The system can accept new stock and view a receipt total.
5. The system can list products at or below their reorder level.
6. The system can report revenue by day and payment method.
7. The system can cashiers can give items away as part of a sale and report giveaways.

## Business Rules and Constraints

#### 1. Staff and roles

- Each staff member has a unique staff code and email address.
- Each role lists the actions staff can perform.

#### 2. Terminals

- Each terminal has a unique terminal code.

#### 3. Products

- Each product has a unique SKU and a price above zero.
- Each product can never have a stock quantity below zero.

#### 4. Shifts

- Each till shift belongs to one existing terminal and one existing cashier.
- A shift can only close after its opening time.
- A terminal can have at most one open shift at a time.

#### 5. Sales

- Each sale has a unique receipt number.
- Each sale belongs to one existing shift.
- Each sale is paid by cash, card or transfer.
- Sales revenue uses paid_qty after discounts and excludes tax.
- Only completed sales are saved.
- Each sale must have at least one sale item.

#### 6. Sale items

- Each sale item refers to one existing product.
- A product appears at most once per sale.
- Each item records paid_qty and giveaway_qty. Both are zero or above, and at least one is above zero.
- Each item keeps the product's shelf price at the time of sale.
- The paid and giveaway quantities use the same saved shelf price.

#### 7. Giveaways

- A reason is required when giveaway_qty is above zero and must otherwise be NULL.
- Stock is reduced by paid_qty + giveaway_qty.
- giveaway_qty is not charged, has no tax charge and does not count as sales revenue.

#### 8. Taxes

- Each sale item uses one valid tax record.
- The default tax is 0%.
- Each sale item keeps the tax percentage used at the time of sale.
- Tax records can be updated without changing past receipts.
- Tax records used on sale items cannot be deleted.

#### 9. Discounts

- Each sale item uses one valid discount record, including the 0% default.
- Discounts are percentages applied per item.
- No discount uses the default 0% discount record.
- Discount is applied before tax to the paid quantity.
- Each sale item keeps the discount percentage used at the time of sale.
- Discount records can be updated without changing past receipts.
- Discount records used on sale items cannot be deleted.

#### 10. Transactions

- A sale, its lines and its stock changes are saved together in one transaction.
- If any sale line would make stock negative, the whole sale is rejected.
- If any part fails, no part of the sale is saved.

## Design Scope

One store, two terminals and fictional records.

**In scope**: staff, roles, terminals, shifts, products, sales, sale items, taxes, and discounts. Giveaways are recorded as quantities on sale items.

**Out of scope**: suppliers as a table, refunds, loyalty points, card processing, user login, standalone giveaways, fixed-amount discounts, receipt-level discounts and multiple taxes or discounts on one line.
