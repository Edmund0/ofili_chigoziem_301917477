-- RUN SETUP ON TERMINAL A:
--== Run Setup.sql before A1.


-- RUN A1 (ON TERMINAL A):
--== Leave the transaction open. Run B1 in Session B.

-- RUN B1 (ON TERMINAL B):
--== While this waits, run A2 in Session A.

-- RUN A2 (ON TERMINAL A):
--== Check B's wait, then commit in Session A.

-- RUN B2 (ON TERMINAL B):
--== After the duplicate-key error, roll back Session B and check the saved shift.


-- RUN CLEANUP ON TERMINAL A:
--== Exit Session B, then run Cleanup.sql after saving results.