# Retail POS MongoDB Design

Author: Chigoziem Edmund Ofili (301917477)

## Document model

Database: `pos_events`. 

Collection: `inventory_events`.

Each document records one delivery, sale or giveaway. Product and staff details are embedded snapshots. The `details` fields vary by event type.

| Field | Contents |
| --- | --- |
| _id | Unique event ID. |
| event_type | Delivery, sale or giveaway. |
| occurred_at | Event date and time. |
| product | Product SKU and name. |
| staff | Staff code and name. |
| quantity_change | Positive for deliveries; negative for sales and giveaways. |
| details | Delivery reference, receipt number or giveaway reason. |

These are fictional examples using the POS products and staff. They do not update PostgreSQL. Summed changes describe these events, not current stock.

## Suitability

A document model suits inventory events because each event can keep its product and staff snapshot together, while deliveries and giveaways store different details. Nested fields can be queried without joining separate collections.

This collection does not enforce the PostgreSQL foreign keys, permissions or non-negative stock rule. It demonstrates event storage rather than replacing the complete POS database.
