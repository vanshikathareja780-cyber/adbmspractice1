USE college;
DROP TABLE IF EXISTS FeePayments;
CREATE TABLE FeePayments (
    payment_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_date DATE NOT NULL
);
START TRANSACTION;
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (1, 'Ashish', 5000.00, '2024-06-01');
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (2, 'Smaran', 4500.00, '2024-06-02');

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (3, 'Vaibhav', 5500.00, '2024-06-03');

COMMIT;
SELECT * FROM FeePayments;

 START TRANSACTION;

-- Valid insert
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (4, 'Kiran', 4000.00, '2024-06-04');


INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (1, 'Ashish', 2000.00, '2024-06-05');

-- Now rollback because of error
ROLLBACK;


SELECT * FROM FeePayments;

START TRANSACTION;

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (4, 'Kiran', 4000.00, '2024-06-04');


INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (1, 'Ashish', -2000.00, '2024-06-05');


ROLLBACK;


SELECT payment_id, student_name, amount, 
       DATE_FORMAT(payment_date, '%Y-%m-%d') AS payment_date
FROM FeePayments;



DROP TABLE IF EXISTS FeePayments;

CREATE TABLE FeePayments (
    payment_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    amount DECIMAL(10,2),
    payment_date TIMESTAMP
);



START TRANSACTION;

-- Valid insert
INSERT INTO FeePayments VALUES (1, 'Ashish', 5000.00, '2024-06-01');

-- Valid insert
INSERT INTO FeePayments VALUES (2, 'Smaran', 4500.00, '2024-06-02');

-- Invalid insert (duplicate payment_id = 2, will fail)
-- This will cause the entire transaction to ROLLBACK
INSERT INTO FeePayments VALUES (2, 'Duplicate', 3000.00, '2024-06-05');

COMMIT;

SELECT * FROM FeePayments

START TRANSACTION;
INSERT INTO FeePayments VALUES (3, 'Vaibhav', 5500.00, '2024-06-03');

SELECT * FROM FeePayments;
COMMIT;

SELECT * FROM FeePayments;


START TRANSACTION;

INSERT INTO FeePayments VALUES (7, 'Sneha', 4700.00, '2024-06-08');
INSERT INTO FeePayments VALUES (8, 'Arjun', 4900.00, '2024-06-09');

COMMIT;


SELECT * FROM FeePayments;
START TRANSACTION;

INSERT INTO FeePayments VALUES (7, 'Sneha', 4700.00, '2024-06-08');
INSERT INTO FeePayments VALUES (8, 'Arjun', 4900.00, '2024-06-09');

COMMIT;

SELECT * FROM FeePayments;



