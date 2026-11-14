# Retail POS and Inventory System ER Diagram

Author: Chigoziem Edmund Ofili (301917477)

## Glossary

- **PK (primary key):** identifies each record and is unique.
- **FK (foreign key):** links to a record in another table.
- **UK (unique key):** values cannot repeat.
- **REQ (required):** required; cannot be NULL.
- **OPT (optional):** optional; may be NULL.
- **UK1:** sale_item.sale_id and product_id are unique together, not individually.

PK, FK and UK markers can be combined.

## Keys and relationships

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
        bigint staff_id FK
        bigint terminal_id FK
    }
    PRODUCT {
        bigint id PK
    }
    SALE {
        bigint id PK
        bigint shift_id FK
    }
    SALE_ITEM {
        bigint id PK
        bigint sale_id FK
        bigint product_id FK
        bigint tax_id FK
        bigint discount_id FK
    }
    TAX {
        bigint id PK
    }
    DISCOUNT {
        bigint id PK
    }
```

## Full tables

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
        bigint id PK "REQ"
        varchar(20) staff_code UK "REQ"
        varchar(254) email UK "REQ"
        varchar(60) first_name "REQ"
        varchar(60) last_name "REQ"
        bigint role_id FK "REQ"
        boolean active_status "REQ"
    }
    ROLE {
        bigint id PK "REQ"
        varchar(30) name UK "REQ"
        boolean can_operate_till "REQ"
        boolean can_manage_products "REQ"
        boolean can_manage_staff "REQ"
        boolean can_manage_terminals "REQ"
        boolean can_view_reports "REQ"
    }
    TERMINAL {
        bigint id PK "REQ"
        varchar(20) terminal_code UK "REQ"
        varchar(80) name "REQ"
    }
    SHIFT {
        bigint id PK "REQ"
        bigint staff_id FK "REQ"
        bigint terminal_id FK "REQ"
        timestamptz opened_at "REQ"
        timestamptz closed_at "OPT"
    }
    PRODUCT {
        bigint id PK "REQ"
        varchar(30) sku UK "REQ"
        varchar(150) name "REQ"
        numeric unit_price "REQ"
        integer stock_qty "REQ"
        integer reorder_level "REQ"
    }
    SALE {
        bigint id PK "REQ"
        varchar(30) receipt_number UK "REQ"
        bigint shift_id FK "REQ"
        timestamptz sold_at "REQ"
        varchar(10) payment_method "REQ"
    }
    SALE_ITEM {
        bigint id PK "REQ"
        bigint sale_id FK "REQ; UK1"
        bigint product_id FK "REQ; UK1"
        numeric unit_price_at_sale "REQ"
        integer paid_qty "REQ"
        integer giveaway_qty "REQ"
        varchar(80) giveaway_reason "OPT"
        bigint tax_id FK "REQ"
        numeric tax_percentage_at_sale "REQ"
        bigint discount_id FK "REQ"
        numeric discount_percentage_at_sale "REQ"
    }
    TAX {
        bigint id PK "REQ"
        varchar(60) name "REQ"
        numeric percentage "REQ"
    }
    DISCOUNT {
        bigint id PK "REQ"
        varchar(60) name "REQ"
        numeric percentage "REQ"
    }
```

See [Design.md](Design.md) for the attribute requirements and constraints.

**UK1:** In `sale_item`, `(sale_id, product_id)` is unique; neither column is unique on its own.
