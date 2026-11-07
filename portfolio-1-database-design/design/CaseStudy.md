# Portfolio 1 Database Design and Modelling

## Case study

A retail point-of-sale (POS) and inventory system for one neighbourhood supermarket. Cashiers open a till shift on a checkout terminal, record sales made up of several line items, and close the shift at the end of the day. The system keeps product stock up to date as goods are sold and received.

## Users

#### Cashiers

- Open and close shifts.
- Record sales.
- Record giveaways with a reason.

#### Store supervisor

- Register staff and terminals.
- Maintain products and prices.
- Receive deliveries.
- Review daily sales, giveaway and low-stock reports.

## Main operations

1. Open and close a till shift.
2. Record a sale with one or more items.
3. Take payment by cash, card or transfer.
4. Receive new stock and view a receipt total.
5. List products at or below their reorder level.
6. Report revenue by day and payment method.
7. Give items away as part of a sale and report giveaways by product and reason.

## Business rules

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
- Sales revenue is the total of paid lines after discounts, excluding tax.
- Only completed sales are saved.
- Each sale must have at least one sale line.

#### 6. Sale items

- Each sale line refers to one existing product.
- Each sale line has a quantity above zero.
- A product appears at most once as a paid line and at most once as a giveaway line in a sale.
- Each product's shelf price at the time of sale is saved once per receipt in sale_product.
- Paid and giveaway lines use that shared price, even if the product price changes later.
- Each sale line is either a paid line or a giveaway line.

#### 7. Giveaways

- A giveaway line is not charged and must record a reason.
- A giveaway line still reduces stock.
- Giveaways have no tax charge and do not count as sales revenue.

#### 8. Taxes

- Each sale line uses one valid tax record.
- The default tax is 0%.
- Each sale line keeps the tax percentage used at the time of sale.
- Tax records can be updated without changing past receipts.
- Tax records used on sale lines cannot be deleted.

#### 9. Discounts

- Each sale line uses one valid discount record, including the 0% default.
- Discounts are percentages applied per item.
- No discount uses the default 0% discount record.
- Discount is applied before tax on paid lines.
- Each sale line keeps the discount percentage used at the time of sale.
- Discount records can be updated without changing past receipts.
- Discount records used on sale lines cannot be deleted.

#### 10. Transactions

- A sale, its lines and its stock changes are saved together in one transaction.
- If any sale line would make stock negative, the whole sale is rejected.
- If any part fails, no part of the sale is saved.

## Scope

One store, two terminals and fictional records.

**In scope**: staff, roles, terminals, shifts, products, sales, sale products, sale lines, taxes, and discounts. Giveaways are recorded on sale lines.

**Out of scope**: suppliers as a table, refunds, loyalty points, card processing, user login, standalone giveaways, fixed-amount discounts, receipt-level discounts and multiple taxes or discounts on one line.
