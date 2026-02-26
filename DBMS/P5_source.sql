CREATE DATABASE lab_db;
USE lab_db;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT,
    manager_id INT,
    join_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Project (
    proj_id INT PRIMARY KEY,
    proj_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL(12,2),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE EmpProject (
    emp_id INT,
    proj_id INT,
    hours_worked INT,
    PRIMARY KEY (emp_id, proj_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (proj_id) REFERENCES Project(proj_id)
);

-- Insert Departments
INSERT INTO Department VALUES
(1, 'HR', 'Hyderabad'),
(2, 'Engineering', 'Bangalore'),
(3, 'Marketing', 'Mumbai'),
(4, 'Finance', 'Delhi');

-- Insert Employees (some with NULL dept to test outer joins)
INSERT INTO Employee VALUES
(101, 'Alice',   90000, 2, NULL,  '2019-03-15'),
(102, 'Bob',     60000, 1, 101,   '2020-06-01'),
(103, 'Charlie', 75000, 2, 101,   '2021-01-10'),
(104, 'Diana',   85000, 3, NULL,  '2018-07-20'),
(105, 'Eve',     55000, 1, 102,   '2022-04-05'),
(106, 'Frank',   95000, 2, 101,   '2017-11-30'),
(107, 'Grace',   70000, 4, NULL,  '2020-09-12'),
(108, 'Heidi',   60000, 3, 104,   '2023-01-01'),
(109, 'Ivan',    50000, NULL, 107, '2023-06-15');  -- no department

-- Insert Projects
INSERT INTO Project VALUES
(201, 'Alpha', 2, 500000),
(202, 'Beta',  1, 200000),
(203, 'Gamma', 2, 750000),
(204, 'Delta', 3, 300000),
(205, 'Omega', NULL, 100000);  -- no department

-- Insert EmpProject
INSERT INTO EmpProject VALUES
(101, 201, 120),
(101, 203, 80),
(103, 201, 200),
(103, 203, 150),
(106, 201, 100),
(106, 203, 60),
(104, 204, 180),
(108, 204, 90),
(102, 202, 50),
(105, 202, 40);