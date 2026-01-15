CREATE DATABASE IF NOT EXISTS dbms_lab;

USE dbms_lab; /*sets the current working database to dbms_lab. All commands will be executed within this database*/

DROP TABLE IF EXISTS Students; /*deletes the entire table if it exists along with all it's data*/
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Professors;

CREATE TABLE IF NOT EXISTS Students (
    id INT PRIMARY KEY, /*id is the column name, INT is the column data type, Primary key implies - not null, unique and automatically indexed*/
    name VARCHAR(50) NOT NULL, /*VARCHAR(50) means variable length string with max 50 characters, NOT NULL means this field must always have a value, if left as null then it throws error*/
    age INT CHECK (age >= 17),
    department VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS Courses (
    id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0),
    type VARCHAR(20) NOT NULL,
    dept VARCHAR(20) NOT NULL
);

/*Primary Keys and Foreign Keys are used to establish relationships between tables in a database. 
A Primary Key uniquely identifies each record in a table, while a Foreign Key is a field in one table that refers to the Primary Key in another table. 
This ensures referential integrity and helps maintain consistent and accurate data across related tables.*/

ALTER Table Students
RENAME COLUMN department TO dept,
ADD CONSTRAINT chk_dept CHECK (dept IN ('CSE', 'ECE', 'ME', 'EEE', 'ENI'));

ALTER Table Courses
ADD COLUMN enrolled INT DEFAULT 0;

CREATE Table IF NOT EXISTS Professors (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, 
    dept VARCHAR(30) NOT NULL,
    joined date,
    in_time time DEFAULT '08:00:00'
);

