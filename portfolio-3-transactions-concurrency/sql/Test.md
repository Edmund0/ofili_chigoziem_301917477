# Portfolio 3 SQL Tests

Author: Chigoziem Edmund Ofili (301917477)

## Test setup

I ran the tests from the repository root in Codespaces.

I loaded the Portfolio 1 schema and test data into separate practice databases, then added T03.

| Test | Database | Starting state |
| --- | --- | --- |
| Transactions | pos_portfolio_transactions | T03 has one open shift. |
| Concurrency | pos_portfolio_concurrency | T03 has no shifts. |

To reproduce the tests, complete the [PostgreSQL environment setup](../../portfolio-1-database-design/design/Setup.md) and leave psql open in Terminal A. Run the following commands from the repository root.

Evidence: [Concurrency setup](outputs/ConcurrentSetup.png).

## Transaction test

I ran setup, then the transaction session in the same psql terminal. To reproduce this, run:

```text
\i portfolio-3-transactions-concurrency/sql/transactions/Setup.sql
\i portfolio-3-transactions-concurrency/sql/transactions/Session.sql
```

I recorded the committed closing time, invalid-closing-time error and final open-shift count. Save those results before removing the transaction practice database with:

```text
\i portfolio-3-transactions-concurrency/sql/transactions/Cleanup.sql
```

## Concurrency test

I created and populated the concurrency database in Terminal A. To reproduce this, run:

```text
\i portfolio-3-transactions-concurrency/sql/concurrency/Setup.sql
```

Setup.sql connected Terminal A to the concurrency database automatically.

I connected Terminal B to the same database. If you are already inside psql at `postgres=#`, run this line on its own and press Enter:

```text
\connect pos_portfolio_concurrency
```

The prompt should change to `pos_portfolio_concurrency=#` before running B0.

If Terminal B is a new shell terminal, open psql connected to that database instead:

```bash
sudo runuser -u postgres -- psql -d pos_portfolio_concurrency
```

I ran the labelled sections from SessionA.sql and SessionB.sql in the order below. To reproduce the test, follow this order rather than running either whole file at once.

| Order | Session | Section | What I did |
| --- | --- | --- | --- |
| 1 | A | A0 | Named Session A and began the READ COMMITTED transaction. |
| 2 | B | B0 | Named Session B and began the READ COMMITTED transaction. |
| 3 | A | A1 | Opened T03 and left the transaction uncommitted. |
| 4 | B | B1 | Checked visibility, then attempted the competing shift. Switched to A while the INSERT waited. |
| 5 | A | A2 | Captured p3_session_b with Lock, then committed and switched back to B. |
| 6 | B | B2 | Rolled back after the duplicate-key error and checked the saved shift. |

I saved B's visibility count, its lock wait before A committed, the duplicate-key error and the final shift.

After saving the results, I exited Session B with `\q` and ran Cleanup.sql in Session A. To reproduce the cleanup, exit B first, then run in A:

```text
\i portfolio-3-transactions-concurrency/sql/concurrency/Cleanup.sql
```

Cleanup drops only the matching practice database. Close other connections to that database first. To repeat a test, clean up before running its setup again. The original pos_portfolio database is unchanged.

Evidence: [Concurrency cleanup](outputs/ConcurrentCleanup.png). The concurrency practice database was dropped after the test.

## Results

In section 3, I deliberately set `closed_at = opened_at`.

This violated `ck_shift_close_after_open`, which requires closing after opening.

`ROLLBACK` removed the new shift; the earlier committed closure remained.

| Check | Observed result | Evidence |
| --- | --- | --- |
| COMMIT preserves the shift closure | One closed T03 shift remained. | [Screenshot](outputs/TransactionTest.png), [text output](outputs/Transactions.txt) |
| Closing the same shift again changes no rows | UPDATE 0. | [Transaction test](outputs/TransactionTest.png) |
| ROLLBACK removes the invalid shift | The new shift was removed; one closed shift remained and open_shifts was 0. | [Screenshot](outputs/TransactionTest.png), [text output](outputs/Transactions.txt) |
| READ COMMITTED hides A's uncommitted shift from B | Both sessions showed read committed. B's visible_open_shifts was 0 before A committed. | [After A1 and B1](<outputs/After A0, A1, B0, B1.png>) |
| B waits while A holds the conflicting shift | A2 returned p3_session_b with wait_event_type Lock.<br>B's INSERT returned a duplicate-key error after A committed. | [Before commit](<outputs/After A0, A1, B0, B1.png>), [after A2](<outputs/After A2.png>) |
| The unique index leaves one open shift on T03 | B's INSERT was rejected by ux_shift_one_open_per_terminal.<br>After B rolled back, one open T03 shift remained, belonging to C001. | [After B2](<outputs/After B2.png>) |

## Reflection

**Why Session B waited and then failed:**

Both sessions tried to open T03. B's INSERT waited for A's transaction to finish. Once A committed, B's INSERT failed because the unique index allows only one open shift per terminal.

**What COMMIT, ROLLBACK and READ COMMITTED demonstrated:**

COMMIT kept the first shift closure. ROLLBACK removed the new shift from the failed transaction. READ COMMITTED hid A's uncommitted shift from B, while the unique index still prevented conflicting open shifts.

