-- SESSION B:
-- Run B1 after A1; run B2 after A2.

-- B0. SET TERMINAL TO SESSION B
--== Name Session B and use READ COMMITTED.
SET application_name = 'p3_session_b';
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;

-- B1. TRY TO OPEN T03:
--== Check visibility before A commits.
SELECT COUNT(*) AS visible_open_shifts
FROM public.shift
WHERE terminal_id = (SELECT id FROM public.terminal WHERE terminal_code = 'T03')
    AND closed_at IS NULL;

--== Try opening T03 for C002.
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

--== Check the saved shift.
SELECT
    sf.staff_code,
    tm.terminal_code,
    sh.opened_at
FROM public.shift AS sh
    JOIN public.staff    AS sf ON sf.id = sh.staff_id
    JOIN public.terminal AS tm ON tm.id = sh.terminal_id
WHERE tm.terminal_code = 'T03'
    AND sh.closed_at IS NULL;
