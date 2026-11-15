# Retail POS and Inventory System Database Design

Author: Chigoziem Edmund Ofili (301917477)

## Entities

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

## Relationships

| Tables linked | Relationship | Meaning |
| --- | --- | --- |
| role → staff | One to many | A role can have zero or more staff. A staff member has one role. |
| staff → shift | One to many | A staff member can work zero or more shifts. Each shift has one cashier. |
| terminal → shift | One to many over time | A terminal can have zero or more shifts. Each shift uses one terminal. |
| shift → sale | One to many | A shift can have zero or more sales. Each sale belongs to one shift. |
| sale → sale_item | One to many | A sale has at least one item. Each item belongs to one sale. |
| product → sale_item | One to many | A product can appear on zero or more receipts. Each item has one product. |
| tax → sale_item | One to many | A tax can be used on zero or more items. Each item has one tax, including the 0% default. |
| discount → sale_item | One to many | A discount can be used on zero or more items. Each item has one discount, including the 0% default. |

