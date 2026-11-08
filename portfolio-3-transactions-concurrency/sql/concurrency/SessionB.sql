-- SESSION B:
-- Run B1 after A1; run B2 after A2.

-- B1. TRY TO OPEN T03:
--== Name Session B and start a READ COMMITTED transaction.
SET application_name = 'p3_session_b';
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;

--== Check whether Session A's uncommitted shift is visible.
SELECT COUNT(*) AS visible_open_shifts
FROM public.shift
WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T03')
    AND closed_at IS NULL;

--== Create Second Shift in terminal T03
INSERT INTO public.shift (
    staff_id,
    terminal_id,
    opened_at
)
VALUES ((SELECT id FROM public.staff WHERE staff_code = 'C002'),
        (SELECT id FROM public.terminal WHERE terminal_code = 'T03'),
        CURRENT_TIMESTAMP);


-- B2. ROLLBACK AFTER THE ERROR:
--== Clear the failed transaction.
ROLLBACK;

--== Check the Saved Shift
SELECT
    sf.staff_code,
    tm.terminal_code,
    sh.opened_at
FROM public.shift AS sh
    JOIN public.staff    AS sf ON sf.id = sh.staff_id
    JOIN public.terminal AS tm ON tm.id = sh.terminal_id
WHERE tm.terminal_code = 'T03'
    AND sh.closed_at IS NULL;
