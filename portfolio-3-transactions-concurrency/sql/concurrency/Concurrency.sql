
-- RUN A1 (ON BASH TERMINAL A):
--== Leave the transaction open. Run B1 in Session B.

-- RUN B1 (ON BASH TERMINAL B):
--== While this waits, run A2 in Session A.

-- RUN A2 (ON BASH TERMINAL A):
--== Check B's wait, then commit in Session A.

-- RUN B2 (ON BASH TERMINAL B):
--== After the duplicate-key error, roll back Session B and check the saved shift.