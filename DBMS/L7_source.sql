-- Create and use the database
CREATE DATABASE IF NOT EXISTS lab_practice;
USE lab_practice;

-- Departments
CREATE TABLE departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location  VARCHAR(30)
);

INSERT INTO departments VALUES
(1, 'Engineering', 'Hyderabad'),
(2, 'IT',          'Bangalore'),
(3, 'Management',  'Chennai'),
(4, 'Operations',  'Mumbai');

-- Employees
CREATE TABLE employees (
    emp_id   INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id  INT,
    salary   DECIMAL(10,2),
    city     VARCHAR(30),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO employees VALUES
(1,  'Ravi Kumar',   1, 90000, 'Hyderabad'),
(2,  'Sneha Reddy',  2, 72000, 'Bangalore'),
(3,  'Karan Mehta',  1, 48000, 'Mumbai'),
(4,  'Priya Nair',   3, 85000, 'Chennai'),
(5,  'Ankit Sharma', 2, 55000, 'Delhi'),
(6,  'Divya Iyer',   4, 63000, 'Hyderabad'),
(7,  'Rahul Gupta',  3, 91000, 'Pune'),
(8,  'Meena Joshi',  4, 42000, 'Kolkata'),
(9,  'Suresh Babu',  1, 78000, 'Hyderabad'),
(10, 'Lakshmi Rao',  2, 68000, 'Bangalore');

-- Projects
CREATE TABLE projects (
    project_id   INT PRIMARY KEY,
    project_name VARCHAR(50),
    budget       DECIMAL(12,2)
);

INSERT INTO projects VALUES
(1, 'Alpha Platform', 500000),
(2, 'Beta Rollout',   300000),
(3, 'Gamma Suite',    750000),
(4, 'Delta Upgrade',  200000);

-- Orders
CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    emp_id     INT,
    project_id INT,
    amount     DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (emp_id)     REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO orders VALUES
(101, 1, 1, 15000, '2024-01-10'),
(102, 2, 2, 22000, '2024-01-15'),
(103, 1, 3, 18000, '2024-02-05'),
(104, 4, 1, 31000, '2024-02-18'),
(105, 3, 4,  9000, '2024-03-01'),
(106, 7, 3, 45000, '2024-03-12'),
(107, 2, 1, 12000, '2024-04-07'),
(108, 9, 2, 27000, '2024-04-20'),
(109, 6, 4,  8000, '2024-05-03'),
(110, 4, 3, 38000, '2024-05-22');