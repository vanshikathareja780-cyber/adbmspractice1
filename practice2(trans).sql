-- Create table with unique constraint
USE college;
CREATE TABLE StudentEnrollments (
    enrollment_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE,
    CONSTRAINT unique_student_course UNIQUE (student_name, course_id)
);

-- Insert initial data
INSERT INTO StudentEnrollments (enrollment_id, student_name, course_id, enrollment_date)
VALUES 
(1, 'Ashish', 'CSE101', '2024-07-01'),
(2, 'Smaran', 'CSE102', '2024-07-01'),
(3, 'Vaibhav', 'CSE101', '2024-07-01');

-- Start Transaction for concurrent insert
START TRANSACTION;

-- Valid insert (new student+course pair)
INSERT INTO StudentEnrollments (enrollment_id, student_name, course_id, enrollment_date)
VALUES (4, 'Kiran', 'CSE103', '2024-07-02');

-- Invalid insert (duplicate student_name + course_id → error)
INSERT INTO StudentEnrollments (enrollment_id, student_name, course_id, enrollment_date)
VALUES (5, 'Ashish', 'CSE101', '2024-07-02');

-- Rollback on failure
ROLLBACK;


START TRANSACTION;
SELECT * 
FROM StudentEnrollments
WHERE student_name = 'Ashish' AND course_id = 'CSE101'
FOR UPDATE;

START TRANSACTION;

-- This will be blocked until User A finishes
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-10'
WHERE student_name = 'Ashish' AND course_id = 'CSE101';

-- Example initial data
INSERT INTO StudentEnrollments (enrollment_id, student_name, course_id, enrollment_date)
VALUES (6, 'Rohan', 'CSE104', '2024-07-05');

-- User A
START TRANSACTION;
SELECT * FROM StudentEnrollments 
WHERE student_name = 'Rohan' AND course_id = 'CSE104'
FOR UPDATE;

-- User A updates enrollment_date
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-15'
WHERE student_name = 'Rohan' AND course_id = 'CSE104';
-- Keep transaction open (not committed yet)

-- User B (runs at the same time)
START TRANSACTION;
-- This will be blocked until User A commits
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-20'
WHERE student_name = 'Rohan' AND course_id = 'CSE104';

-- Once User A COMMITs:
COMMIT;

-- Then User B executes its update and commits:
COMMIT;

-- Final check
SELECT enrollment_id, student_name, course_id, DATE(enrollment_date) AS enrollment_date
FROM StudentEnrollments;


