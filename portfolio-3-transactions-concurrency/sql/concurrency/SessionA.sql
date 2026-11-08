-- SESSION A:

-- A1. OPEN T03:
--== Name Session A and start a READ COMMITTED transaction.
SET application_name = 'p3_session_a';
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;

--== Create First Shift in terminal T03
INSERT INTO public.shift (
    staff_id,
    terminal_id,
    opened_at
)
VALUES ((SELECT id FROM public.staff WHERE staff_code = 'C001'),
        (SELECT id FROM public.terminal WHERE terminal_code = 'T03'),
        CURRENT_TIMESTAMP);
        

-- A2. CHECK THE WAIT AND COMMIT:
--== Check Session B's wait, then commit the shift.
SELECT 
    application_name, 
    wait_event_type
FROM pg_stat_activity
WHERE application_name = 'p3_session_b';

COMMIT;
