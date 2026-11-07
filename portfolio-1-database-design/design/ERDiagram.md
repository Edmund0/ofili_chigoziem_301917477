# Retail POS and Inventory System ER Diagram

Author: Chigoziem Edmund Ofili (301917477)

The basic entities and current relationships are shown below.

## Diagram

```mermaid
erDiagram
    direction LR

    ROLE ||--o{ STAFF : assigned_to
    STAFF ||--o{ SHIFT : works
    TERMINAL ||--o{ SHIFT : hosts
    SHIFT ||--o{ SALE : records
    SALE ||--|{ SALE_ITEM : contains
    PRODUCT ||--o{ SALE_ITEM : appears_on
    TAX ||--o{ SALE_ITEM : applies_to
    DISCOUNT ||--o{ SALE_ITEM : applies_to

    STAFF {
        bigint id PK
        bigint role_id FK
    }
    ROLE {
        bigint id PK
    }
    TERMINAL {
        bigint id PK
    }
    SHIFT {
        bigint id PK
    }
    PRODUCT {
        bigint id PK
    }
    SALE {
        bigint id PK
    }
    SALE_ITEM {
        bigint id PK
        bigint sale_id FK
        bigint product_id FK
        decimal unit_price_at_sale
        int paid_qty
        int giveaway_qty
        string giveaway_reason
        bigint tax_id FK
        decimal tax_percentage_at_sale
        bigint discount_id FK
        decimal discount_percentage_at_sale
    }
    TAX {
        bigint id PK
    }
    DISCOUNT {
        bigint id PK
    }
```

Each staff member has one role. The diagram shows selected fields; the full attribute list is in [Design.md](Design.md).

## Keys and symbols

| Key or relationship symbol used | Meaning | Example from this design |
| --- | --- | --- |
| [Key or symbol] | [Explain in plain words] | [Your example] |

## Optional fields

- 

## Rules beyond the diagram

- 

## Review

- 