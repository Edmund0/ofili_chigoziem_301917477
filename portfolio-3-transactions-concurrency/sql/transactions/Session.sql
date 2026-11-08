-- TRANSACTION SESSION:
\set ON_ERROR_STOP off

-- 1. CLOSE T03 AND COMMIT:
--== Start the transaction.
BEGIN;

--== Close T03's open shift.
UPDATE public.shift
SET closed_at = CURRENT_TIMESTAMP
WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T03')
    AND closed_at IS NULL;

COMMIT;

-- 2. TRY TO CLOSE T03 AGAIN:
--== Confirm the closed shift is not updated.
UPDATE public.shift
SET closed_at = CURRENT_TIMESTAMP
WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T03')
    AND closed_at IS NULL;

-- 3. ROLL BACK AN INVALID SHIFT:
BEGIN;

--== Open a new shift.
INSERT INTO public.shift (
    staff_id,
    terminal_id,
    opened_at
)
VALUES ((SELECT id FROM public.staff WHERE staff_code = 'C001'),
        (SELECT id FROM public.terminal WHERE terminal_code = 'T03'),
        CURRENT_TIMESTAMP);

--== Try closing the shift at its opening time.
UPDATE public.shift
SET closed_at = opened_at
WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T03')
    AND closed_at IS NULL;

ROLLBACK;

-- 4. CHECK SAVED AND OPEN SHIFTS:
--== Check the committed closing time.
SELECT
    opened_at,
    closed_at
FROM public.shift
WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T03');

--== Check that the rolled-back shift is absent.
SELECT COUNT(*) AS open_shifts
FROM public.shift
WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T03')
    AND closed_at IS NULL;
