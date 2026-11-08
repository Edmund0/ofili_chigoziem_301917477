// RETAIL INVENTORY EVENTS:
db = db.getSiblingDB("pos_events");

// CHECK EXISTING DATA:
if (db.inventory_events.countDocuments() !== 0) {
    throw new Error("Inventory events already exist. Check the previous run before inserting again.");
}

// INSERT INVENTORY EVENTS:
printjson(db.inventory_events.insertMany([
    {
        _id: "E001", event_type: "delivery",
        occurred_at: ISODate("2026-11-01T08:30:00Z"),
        product: { sku: "RICE", name: "Rice" },
        staff: { staff_code: "C003", name: "Ayomide Kuti" },
        quantity_change: 10,
        details: { delivery_reference: "D001" }
    },
    {
        _id: "E002", event_type: "sale",
        occurred_at: ISODate("2026-11-01T10:00:00Z"),
        product: { sku: "RICE", name: "Rice" },
        staff: { staff_code: "C001", name: "John Bishop" },
        quantity_change: -2,
        details: { receipt_number: "R-101" }
    },
    {
        _id: "E003", event_type: "giveaway",
        occurred_at: ISODate("2026-11-01T10:00:00Z"),
        product: { sku: "RICE", name: "Rice" },
        staff: { staff_code: "C001", name: "John Bishop" },
        quantity_change: -1,
        details: { receipt_number: "R-101", reason: "Buy 2, get 1 free" }
    },
    {
        _id: "E004", event_type: "delivery",
        occurred_at: ISODate("2026-11-01T09:00:00Z"),
        product: { sku: "SOAP", name: "Soap" },
        staff: { staff_code: "C003", name: "Ayomide Kuti" },
        quantity_change: 5,
        details: { delivery_reference: "D002" }
    }
]));

// Q1: COUNT EVENTS:
printjson(db.inventory_events.countDocuments());

// Q2: RICE EVENT HISTORY:
printjson(db.inventory_events.find(
    { "product.sku": "RICE" },
    { _id: 1, event_type: 1, occurred_at: 1, quantity_change: 1, details: 1 }
).sort({ occurred_at: 1, _id: 1 }).toArray());

// Q3: GIVEAWAY REASON:
printjson(db.inventory_events.find(
    { event_type: "giveaway", "details.reason": "Buy 2, get 1 free" }
).toArray());

// Q4: QUANTITY CHANGES BY PRODUCT:
printjson(db.inventory_events.aggregate([
    { $group: { _id: "$product.sku", net_quantity_change: { $sum: "$quantity_change" } } },
    { $sort: { _id: 1 } }
]).toArray());
