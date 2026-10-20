-- COMPLETE MYSQL ASSIGNMENT: ONE SCRIPT
-- Run in MySQL Workbench. This script creates the database, tables,
-- inserts the sample data provided in the assignment, and runs the queries.
-- Note: The assignment does not provide sample rows for Orders or Students,
-- so those queries will return empty results until you insert data.

CREATE DATABASE IF NOT EXISTS AssignmentDB;
USE AssignmentDB;

-- =========================================================
-- PART 1: BANKING SCENARIO
-- =========================================================
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    account_type VARCHAR(20),
    balance DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (name, city) VALUES
('Janani','Chennai'),
('Arun','Coimbatore'),
('Priya','Madurai'),
('Karthik','Salem');

INSERT INTO accounts (customer_id, account_type, balance) VALUES
(1,'Savings',50000),
(1,'Current',20000),
(2,'Savings',30000),
(3,'Savings',15000),
(4,'Current',40000);

-- Banking Q1-Q15: WHERE and operators
-- Q1
SELECT * FROM accounts WHERE balance > 20000;
-- Q2
SELECT * FROM customers WHERE city = 'Chennai';
-- Q3
SELECT * FROM accounts WHERE balance BETWEEN 20000 AND 50000;
-- Q4
SELECT * FROM customers WHERE name LIKE 'J%';
-- Q5
SELECT * FROM accounts WHERE account_type IN ('Savings','Current');
-- Q6
SELECT * FROM accounts WHERE account_type <> 'Savings';
-- Q7
SELECT * FROM customers WHERE name LIKE '%a%';
-- Q8
SELECT * FROM accounts WHERE balance <= 30000;
-- Q9
SELECT * FROM customers WHERE city <> 'Madurai';
-- Q10
SELECT * FROM accounts WHERE balance NOT BETWEEN 10000 AND 40000;
-- Q11
SELECT * FROM customers WHERE name LIKE '%i';
-- Q12
SELECT * FROM accounts WHERE balance = 50000;
-- Q13
SELECT * FROM customers WHERE city IN ('Chennai','Salem');
-- Q14
SELECT * FROM accounts WHERE balance > 10000 AND balance < 40000;
-- Q15
SELECT * FROM accounts WHERE account_type NOT IN ('Current');

-- Banking Q16-Q18: ORDER BY
-- Q16
SELECT * FROM accounts ORDER BY balance DESC;
-- Q17
SELECT * FROM customers ORDER BY name ASC;
-- Q18
SELECT * FROM accounts ORDER BY account_type ASC, balance DESC;

-- Banking Q19-Q23: Aggregate functions
-- Q19
SELECT SUM(balance) AS total_balance FROM accounts;
-- Q20
SELECT AVG(balance) AS average_balance FROM accounts;
-- Q21
SELECT MAX(balance) AS maximum_balance FROM accounts;
-- Q22
SELECT MIN(balance) AS minimum_balance FROM accounts;
-- Q23
SELECT COUNT(*) AS total_customers FROM customers;

-- Banking Q24-Q28: GROUP BY and HAVING
-- Q24
SELECT account_type, SUM(balance) AS total_balance
FROM accounts GROUP BY account_type;
-- Q25
SELECT account_type, AVG(balance) AS average_balance
FROM accounts GROUP BY account_type;
-- Q26
SELECT account_type, AVG(balance) AS average_balance
FROM accounts GROUP BY account_type HAVING AVG(balance) > 20000;
-- Q27
SELECT c.customer_id, c.name, COUNT(a.account_id) AS total_accounts
FROM customers c LEFT JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.name;
-- Q28
SELECT c.customer_id, c.name, COUNT(a.account_id) AS total_accounts
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.name HAVING COUNT(a.account_id) > 1;

-- Banking Q29-Q35: JOINs
-- Q29
SELECT c.name, a.balance
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id;
-- Q30
SELECT c.name, a.account_type, a.balance
FROM customers c LEFT JOIN accounts a ON c.customer_id = a.customer_id;
-- Q31
SELECT a.*, c.name, c.city
FROM accounts a JOIN customers c ON a.customer_id = c.customer_id;
-- Q32
SELECT c.name, a.account_type
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.balance > 20000;
-- Q33
SELECT c.name, SUM(a.balance) AS total_balance
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.name;
-- Q34
SELECT c.name, a.balance
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id
ORDER BY a.balance ASC;
-- Q35
SELECT c.city, COUNT(a.account_id) AS total_accounts
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.city;

-- Banking Q36-Q40: Subqueries
-- Q36
SELECT * FROM accounts
WHERE balance > (SELECT AVG(balance) FROM accounts);
-- Q37
SELECT * FROM customers
WHERE customer_id IN (SELECT customer_id FROM accounts);
-- Q38
SELECT * FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM accounts);
-- Q39
SELECT * FROM accounts
WHERE balance = (SELECT MAX(balance) FROM accounts);
-- Q40
SELECT c.name, SUM(a.balance) AS total_balance
FROM customers c JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(a.balance) > 40000;

-- =========================================================
-- PART 2: RAILWAY RESERVATION
-- =========================================================
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS trains;

CREATE TABLE trains (
    train_id INT PRIMARY KEY AUTO_INCREMENT,
    train_name VARCHAR(50),
    source VARCHAR(50),
    destination VARCHAR(50)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    train_id INT,
    passenger_name VARCHAR(50),
    fare DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (train_id) REFERENCES trains(train_id)
);

INSERT INTO trains (train_name, source, destination) VALUES
('Express1','Chennai','Madurai'),
('Express2','Coimbatore','Salem'),
('Express3','Madurai','Chennai');

INSERT INTO bookings (train_id, passenger_name, fare, status) VALUES
(1,'Janani',500,'Confirmed'),
(1,'Arun',500,'Waiting'),
(2,'Priya',300,'Confirmed'),
(3,'Karthik',450,'Cancelled'),
(2,'Meena',300,'Confirmed');

-- Railway Q41-Q45
-- Q41
SELECT * FROM bookings WHERE fare > 400;
-- Q42
SELECT * FROM bookings WHERE status <> 'Confirmed';
-- Q43
SELECT * FROM trains WHERE source = 'Chennai';
-- Q44
SELECT * FROM bookings WHERE fare BETWEEN 300 AND 500;
-- Q45
SELECT * FROM bookings WHERE passenger_name LIKE 'A%';

-- Railway Q46-Q48
-- Q46
SELECT t.train_name, b.passenger_name
FROM trains t JOIN bookings b ON t.train_id = b.train_id;
-- Q47
SELECT t.train_name, COUNT(b.booking_id) AS total_bookings
FROM trains t LEFT JOIN bookings b ON t.train_id = b.train_id
GROUP BY t.train_id, t.train_name;
-- Q48
SELECT t.train_name,
       COALESCE(SUM(CASE WHEN b.status = 'Confirmed' THEN b.fare ELSE 0 END),0)
       AS total_fare_collected
FROM trains t LEFT JOIN bookings b ON t.train_id = b.train_id
GROUP BY t.train_id, t.train_name;

-- Railway Q49-Q50
-- Q49
SELECT * FROM bookings
WHERE fare = (SELECT MAX(fare) FROM bookings);
-- Q50
SELECT t.train_name, COUNT(b.booking_id) AS total_bookings
FROM trains t JOIN bookings b ON t.train_id = b.train_id
GROUP BY t.train_id, t.train_name
HAVING COUNT(b.booking_id) > 1;

-- =========================================================
-- PART 3: EMPLOYEE MANAGEMENT
-- =========================================================
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    city VARCHAR(30),
    joining_date DATE
);

INSERT INTO Employee VALUES
(101,'John','IT',60000,'Chennai','2022-01-15'),
(102,'David','HR',45000,'Bangalore','2021-03-10'),
(103,'Smith','IT',70000,'Chennai','2020-07-12'),
(104,'Mary','Finance',55000,'Mumbai','2023-01-20'),
(105,'James','HR',48000,'Delhi','2022-05-05'),
(106,'Linda','Finance',65000,'Mumbai','2021-08-18');

-- Employee Q1-Q15
-- Q1
SELECT department, COUNT(*) AS total_employees
FROM Employee GROUP BY department;
-- Q2
SELECT department, AVG(salary) AS average_salary
FROM Employee GROUP BY department;
-- Q3
SELECT department, COUNT(*) AS total_employees
FROM Employee GROUP BY department HAVING COUNT(*) > 1;
-- Q4
SELECT department, MAX(salary) AS highest_salary
FROM Employee GROUP BY department;
-- Q5
SELECT department, MIN(salary) AS lowest_salary
FROM Employee GROUP BY department;
-- Q6
SELECT department, AVG(salary) AS average_salary
FROM Employee GROUP BY department HAVING AVG(salary) > 50000;
-- Q7
SELECT department, SUM(salary) AS total_salary
FROM Employee GROUP BY department;
-- Q8
SELECT * FROM Employee ORDER BY salary DESC;
-- Q9
SELECT * FROM Employee ORDER BY department ASC, salary DESC;
-- Q10
SELECT city, COUNT(*) AS total_employees
FROM Employee GROUP BY city HAVING COUNT(*) > 1;
-- Q11
SELECT city, SUM(salary) AS total_salary
FROM Employee GROUP BY city;
-- Q12
SELECT department, SUM(salary) AS total_salary
FROM Employee GROUP BY department ORDER BY total_salary DESC;
-- Q13
SELECT department, COUNT(*) AS employees_over_50000
FROM Employee WHERE salary > 50000 GROUP BY department;
-- Q14
SELECT department, MAX(salary) - MIN(salary) AS salary_difference
FROM Employee GROUP BY department;
-- Q15
SELECT * FROM Employee ORDER BY salary DESC LIMIT 3;

-- =========================================================
-- PART 4: CUSTOMERS AND ORDERS
-- The assignment gives table definitions but no sample rows.
-- Insert your own data before running these queries to see results.
-- =========================================================
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(30)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Optional sample data so the queries produce output
INSERT INTO Customers VALUES
(1,'Janani','Chennai'),
(2,'Arun','Coimbatore'),
(3,'Priya','Madurai'),
(4,'Karthik','Salem'),
(5,'Meena','Chennai');

INSERT INTO Orders VALUES
(101,1,3500,'2026-01-05'),
(102,1,4200,'2026-02-10'),
(103,1,2800,'2026-03-12'),
(104,1,1500,'2026-04-15'),
(105,2,6000,'2026-01-20'),
(106,2,3500,'2026-02-25'),
(107,3,2500,'2026-03-01'),
(108,3,1800,'2026-04-02'),
(109,4,9000,'2026-05-08'),
(110,5,1200,'2026-06-11');

-- Customers & Orders Q16-Q30
-- Q16
SELECT c.customer_name, COALESCE(SUM(o.amount),0) AS total_order_amount
FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
-- Q17
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name HAVING COUNT(o.order_id) > 3;
-- Q18
SELECT c.customer_name, AVG(o.amount) AS average_order_amount
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
-- Q19
SELECT c.customer_name, MAX(o.amount) AS highest_order_amount
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
-- Q20
SELECT c.customer_name, COALESCE(SUM(o.amount),0) AS total_purchase
FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name ORDER BY total_purchase DESC;
-- Q21
SELECT c.customer_name, SUM(o.amount) AS total_purchase
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name HAVING SUM(o.amount) > 10000;
-- Q22
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
-- Q23
SELECT c.customer_name, SUM(o.amount) AS total_purchase
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_purchase DESC LIMIT 1;
-- Q24
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC LIMIT 1;
-- Q25
SELECT c.customer_name, AVG(o.amount) AS average_order_amount
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name HAVING AVG(o.amount) > 2000;
-- Q26
SELECT c.customer_name, SUM(o.amount) AS total_purchase
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name ORDER BY total_purchase DESC LIMIT 5;
-- Q27
SELECT c.customer_name, MIN(o.amount) AS minimum_order_amount
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
-- Q28
SELECT c.customer_name, SUM(o.amount) AS total_purchase
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name HAVING SUM(o.amount) > 5000;
-- Q29
SELECT c.customer_name, COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.amount),0) AS total_purchase
FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
-- Q30
SELECT c.customer_name, COUNT(o.order_id) AS total_orders,
       SUM(o.amount) AS total_purchase
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 2 AND SUM(o.amount) > 8000;

-- =========================================================
-- PART 5: STUDENTS
-- Assignment provides the table definition but no sample rows.
-- Optional sample data included below.
-- =========================================================
DROP TABLE IF EXISTS Students;

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(30),
    marks INT
);

INSERT INTO Students VALUES
(1,'Anu','CSE',88),
(2,'Bala','CSE',76),
(3,'Charan','CSE',92),
(4,'Divya','ECE',81),
(5,'Ezhil','ECE',69),
(6,'Farhan','ECE',95),
(7,'Gita','IT',78),
(8,'Hari','IT',84),
(9,'Indu','IT',72),
(10,'Jeeva','IT',91),
(11,'Kavin','CSE',67),
(12,'Latha','ECE',87);

-- Students Q31-Q45
-- Q31
SELECT department, AVG(marks) AS average_marks
FROM Students GROUP BY department;
-- Q32
SELECT department, AVG(marks) AS average_marks
FROM Students GROUP BY department HAVING AVG(marks) > 75;
-- Q33
SELECT department, MAX(marks) AS highest_mark
FROM Students GROUP BY department;
-- Q34
SELECT department, COUNT(*) AS total_students
FROM Students GROUP BY department;
-- Q35
SELECT department, COUNT(*) AS total_students
FROM Students GROUP BY department HAVING COUNT(*) > 5;
-- Q36
SELECT department, AVG(marks) AS average_marks
FROM Students GROUP BY department ORDER BY average_marks DESC;
-- Q37
SELECT department, AVG(marks) AS average_marks
FROM Students GROUP BY department ORDER BY average_marks DESC LIMIT 3;
-- Q38
SELECT department, AVG(marks) AS average_marks
FROM Students GROUP BY department
HAVING AVG(marks) BETWEEN 70 AND 90;
-- Q39
SELECT department, SUM(marks) AS total_marks
FROM Students GROUP BY department;
-- Q40
SELECT department, COUNT(*) AS total_students
FROM Students GROUP BY department ORDER BY total_students DESC;
-- Q41
SELECT department, MIN(marks) AS lowest_mark
FROM Students GROUP BY department;
-- Q42
SELECT department, MAX(marks) AS highest_mark
FROM Students GROUP BY department HAVING MAX(marks) > 90;
-- Q43
SELECT department, COUNT(*) AS students_above_80
FROM Students WHERE marks > 80 GROUP BY department;
-- Q44
SELECT department, COUNT(*) AS students_above_75
FROM Students WHERE marks > 75 GROUP BY department
HAVING COUNT(*) > 3;
-- Q45
SELECT department, MAX(marks) AS highest_mark
FROM Students GROUP BY department ORDER BY highest_mark DESC;
