-- RUN SETUP ON TERMINAL A:
--== Run Setup.sql before A0.

-- RUN A0 (ON TERMINAL A):
--== Name Session A and begin its transaction.

-- RUN B0 (ON TERMINAL B):
--== Connect to the concurrency database, then name Session B and begin its transaction.

-- RUN A1 (ON TERMINAL A):
--== Open T03 and leave the transaction uncommitted.

-- RUN B1 (ON TERMINAL B):
--== While the INSERT waits, switch to A2.

-- RUN A2 (ON TERMINAL A):
--== Capture B's Lock result, then commit and switch to B2.

-- RUN B2 (ON TERMINAL B):
--== Roll back after the duplicate-key error and check the saved shift.

-- RUN CLEANUP ON TERMINAL A:
--== Save results and exit Session B with \q, then run Cleanup.sql.
