# Portfolio 3 SQL Tests

Author: Chigoziem Edmund Ofili (301917477)

## Transaction test

### Test methodology

To demonstrate how transactions saved and undid changes, the first test closed a shift and saved it using `COMMIT`. The second test ran an invalide closing time and rolled back the changes using `ROLLBACK`.

### Steps to reproduce

1. Prepared PostgreSQL using the [PostgreSQL environment setup](../../portfolio-1-database-design/design/Setup.md).

2. Created the transaction database, loaded the test records, and opened a shift on terminal T03:

   ```text
   \i portfolio-3-transactions-concurrency/sql/transactions/Setup.sql
   ```

3. Ran the transaction test:

   ```text
   \i portfolio-3-transactions-concurrency/sql/transactions/Session.sql
   ```

   Evidence: [Transaction results](outputs/TransactionTest.png), [text output](outputs/Transactions.txt).

4. Recorded the commited closing time, the invalid-closing-time error, and the final numbe of fopen-shifts, then removed the transaction test database:

   ```text
   \i portfolio-3-transactions-concurrency/sql/transactions/Cleanup.sql
   ```

   Evidence: [Transaction cleanup](outputs/TransactionCleanup.png).

### Results

1. In the first test, `COMMIT` saved the shift's closing time. Trying to close the same shift again returned `UPDATE 0` because it was already closed.
2. In the second test, the test set a new shift's closing time equal to its opening time which violated the **closing-time constraint**. `ROLLBACK` removed that new shift. The final number of open shifts remained 0.


## Concurrency test

### Test methodology

To demonstrate isolation and concurrency control, two sessions tried to open a shift on the same terminal. This tested whether one session could see the other's uncommitted changes and whether both operations could be saved/committed.

### Steps to reproduce

1. Prepared PostgreSQL using the [PostgreSQL environment setup](../../portfolio-1-database-design/design/Setup.md). This terminal was my bash terminal A.

2. Created and loaded the concurrency database in Bash Terminal A. In this test, T03 had no shifts:

   ```text
   \i portfolio-3-transactions-concurrency/sql/concurrency/Setup.sql
   ```

   Evidence: [Concurrency setup](outputs/ConcurrentSetup.png).

3. Created Bash Terminal B and connected it to the same concurrency database.

   ```text
   \connect pos_portfolio_concurrency
   ```

4. Ran each section of [SessionA.sql](concurrency/SessionA.sql) and [SessionB.sql](concurrency/SessionB.sql) in the order below:

   | Order | Session | Section | What I did |
   | --- | --- | --- | --- |
   | 1 | A | A0 | Started transaction A. |
   | 2 | B | B0 | Started transaction B. |
   | 3 | A | A1 | Opened T03 without saving/committing. |
   | 4 | B | B1 | Checked if B could see A's shift, Tried to open T03 for another cashier. |
   | 5 | A | A2 | Confirmed B was waiting for a lock, then committed A's shift. Switched back to Terminal B, where the waiting insert returned a duplicate-shift error. |
   | 6 | B | B2 | Ran a ROLLBACK to end B's failed transaction, and then checked which shift was saved on T03. |

   Evidence: [Before A committed](<outputs/After A0, A1, B0, B1.png>), [after A committed](<outputs/After A2.png>), [final shift](<outputs/After B2.png>).

5. Saved the results and removed the test database:

   ```text
   \i portfolio-3-transactions-concurrency/sql/concurrency/Cleanup.sql
   ```

   Evidence: [Concurrency cleanup](outputs/ConcurrentCleanup.png).

### Results

1. Session B could not see A's uncommitted shift.
2. Session B had to wait for A to commit/save before its insert was rejected.
3. Only Session A's shift was commited/saved. The unique index prevented two open shifts on T03.
