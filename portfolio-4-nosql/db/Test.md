# Portfolio 4 MongoDB Tests

Author: Chigoziem Edmund Ofili (301917477)

## Test methodology

To demonstrate the document model's collections, nosql, as another database solution for GoodNaija supermarket, I ran 4 queries to:

- count the number of events,
- view a product's history,
- find a giveaway by its reason, and
- calculate the quantity changes by product.

## Steps to reproduce

1. Prepared MongoDB using the [MongoDB environment setup](../design/Setup.md). Kept the server running in Terminal A and mongosh open in Terminal B.

2. Loaded the test script in Terminal B. The script inserted four events into the inventory_events collection in the pos_events database, then ran four queries:

   ```javascript
   load("portfolio-4-nosql/db/code/MongoDB.js")
   ```

   Evidence: [Test results](outputs/Test.png), [text output](outputs/Test.txt).

3. Saved the [screenshots](outputs) and recorded the results.

**Test environment**: GitHub Codespaces, MongoDB 8.0.34 and mongosh 2.14.1, connected to `127.0.0.1:27017`.

## Results

1. MongoDB accepted all four events: E001, E002, E003 and E004.
2. Q1 returned 4 events, compared with 0 before loading the script.
3. Q2 returned the three Rice events in order: delivery, sale, and giveaway.
4. Q3 returned giveaway E003 with the reason Buy 2, get 1 free.
5. Q4 returned a net quantity change of 7 for Rice and 5 for Soap.