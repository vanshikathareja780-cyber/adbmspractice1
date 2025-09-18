-- Drop if exists and create table fresh
USE college;
DROP TABLE IF EXISTS StudentEnrollments;

CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE
);

-- Insert sample data
INSERT INTO StudentEnrollments (student_id, student_name, course_id, enrollment_date)
VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');

START TRANSACTION;

-- Step 1: Lock row of Ashish
UPDATE StudentEnrollments
SET enrollment_date = '2024-06-05'
WHERE student_id = 1;

-- Step 2: Now try to lock Smaran (but User B already holds it → deadlock)
UPDATE StudentEnrollments
SET enrollment_date = '2024-06-06'
WHERE student_id = 2;
START TRANSACTION;

-- Step 1: Lock row of Smaran
UPDATE StudentEnrollments
SET enrollment_date = '2024-06-07'
WHERE student_id = 2;

-- Step 2: Now try to lock Ashish (but User A already holds it → deadlock)
UPDATE StudentEnrollments
SET enrollment_date = '2024-06-08'
WHERE student_id = 1;
START TRANSACTION;

-- Reads the old snapshot value
SELECT student_id, student_name, enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;

-- Keeps transaction open (does NOT commit yet)

START TRANSACTION;

-- Updates same row concurrently
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-10'
WHERE student_id = 1;

COMMIT;
-- Still sees the old value due to MVCC
SELECT student_id, student_name, enrollment_date
FROM StudentEnrollments
WHERE student_id = 1;

-- After commit, if queried again in new transaction, it will see updated value
COMMIT;
START TRANSACTION;

-- Lock row using SELECT FOR UPDATE
SELECT * FROM StudentEnrollments
WHERE student_id = 1
FOR UPDATE;

-- Keep transaction open
START TRANSACTION;

-- This will BLOCK until User A commits
SELECT * FROM StudentEnrollments
WHERE student_id = 1;


-- Still sees the old snapshot due to MVCC
SELECT * FROM StudentEnrollments
WHERE student_id = 1;

COMMIT;
