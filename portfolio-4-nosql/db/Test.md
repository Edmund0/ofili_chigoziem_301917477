# Portfolio 4 MongoDB Tests

Author: Chigoziem Edmund Ofili (301917477)

## Steps

Run the tests from the repository root in GitHub Codespaces.

1. Start MongoDB in Terminal A and connect with mongosh in Terminal B, following [Setup.md](../design/Setup.md). Keep the server running while testing.
2. In Terminal B's mongosh session, run the script once:

   ```javascript
   load("portfolio-4-nosql/db/code/MongoDB.js")
   ```

3. Save the setup and test output. Evidence: [setup screenshot](outputs/MongoDBSetup.png), [test screenshot](outputs/Test.png) and [text output](outputs/Test.txt).

**MongoDB version and environment:** MongoDB 8.0.34, mongosh 2.14.1, running locally in GitHub Codespaces at `127.0.0.1:27017`. The database was `pos_events`, with collection `inventory_events`.

## Results

| Check | Observed result | Evidence |
| --- | --- | --- |
| Four events inserted | acknowledged was true; inserted IDs were E001, E002, E003 and E004. | [Text output](outputs/Test.txt) |
| Document count | 0 before loading the script; 4 afterward. | [Setup](outputs/MongoDBSetup.png), [text output](outputs/Test.txt) |
| Rice event history | E001 delivery, E002 sale and E003 giveaway, in that order. | [Text output](outputs/Test.txt) |
| Giveaway reason filter | Returned E003 with reason Buy 2, get 1 free. | [Screenshot](outputs/Test.png), [text output](outputs/Test.txt) |
| Quantity changes by product | RICE: 7; SOAP: 5. | [Screenshot](outputs/Test.png), [text output](outputs/Test.txt) |

**What the results showed:**

The collection stores deliveries, sales and giveaways with different details. The queries filter a nested giveaway reason and group quantity changes by product. The grouped totals describe these events, not current stock.
