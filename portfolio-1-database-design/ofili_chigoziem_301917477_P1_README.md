# Portfolio 1 Database Design and Modelling

## Case study

A retail point-of-sale (POS) and inventory system for one neighbourhood supermarket. Cashiers open a till shift on a checkout terminal, record sales made up of several line items, and close the shift at the end of the day. The system keeps product stock up to date as goods are sold and received.

## Users

### Cashiers

- Open and close shifts.
- Record sales.
- Record giveaways with a reason.

### Store supervisor

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

1. Each cashier has a unique staff code and email address.
2. Each terminal has a unique terminal code.
3. Each product has a unique SKU and a price above zero.
4. Each product can never have a stock quantity below zero.
5. Each till shift belongs to one existing terminal and one existing cashier.
6. A shift can only close after its opening time.
7. A terminal can have at most one open shift at a time.
8. Each sale has a unique receipt number.
9. Each sale belongs to one existing shift.
10. Each sale is paid by cash, card or transfer.
11. Each sale line refers to one existing product.
12. Each sale line has a quantity above zero.
13. A product appears at most once as a paid line and at most once as a giveaway line in a sale.
14. Each sale line keeps the product's shelf price at the time of sale, even if the price changes later.
15. Each sale line is either a paid line or a giveaway line.
16. A giveaway line is not charged and must record a reason.
17. A giveaway line still reduces stock.
18. A sale and its stock changes are saved together in one transaction.
19. If any sale line would make stock negative, the whole sale is rejected.

## Scope

One store, two terminals and fictional records. 

**Entities In-scope Included**: staff, terminals, shifts, products, sales, sale lines and giveaways recorded on a sale. 

**Out of scope**: suppliers as a table, discounts, tax, refunds, loyalty points, card processing and user login.
