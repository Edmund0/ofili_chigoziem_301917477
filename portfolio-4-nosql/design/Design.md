# Retail POS MongoDB Design

Author: Chigoziem Edmund Ofili (301917477)

## Document model

Database: `pos_events`. 

Collection: `inventory_events`.

The supermarket's POS and inventory system could be implemented using a document database, a type of not-only-SQL (noSQL). Each document records only one delivery, sale, or giveaway. Product and staff details are embedded in each document. The `details` fields depends on the event type.

| Field | Contents |
| --- | --- |
| _id | Unique event ID. |
| event_type | Delivery, sale, or giveaway. |
| occurred_at | Event date and time. |
| product | Product SKU and name. |
| staff | Staff code and name. |
| quantity_change | Positive for deliveries; negative for sales and giveaways. |
| details | Delivery reference, receipt number or giveaway reason. |


## Suitability

A document model suits inventory events because each event can keep all related information together. A sales event retains its product and staff information together, while deliveries and giveaways store different details. Nested fields can be queried without joining separate collections.

**Limitations**: This collection does not enforce the PostgreSQL foreign keys, permissions or non-negative stock rule. It demonstrates event storage rather than replacing the complete POS database.
