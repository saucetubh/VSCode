CREATE DATABASE IF NOT EXISTS dbms_lab;

USE dbms_lab; /*sets the current working database to dbms_lab. All commands will be executed within this database*/
/*
Because of foreign key constraints, the order of dropping tables and creating tables matters. Must create parent tables first before child tables and drop child tables first before parent tables.
Otherwise u get error. Concept of Relational Integrity.
*/
DROP TABLE IF EXiSTS Enrollments; 
DROP TABLE IF EXISTS Students; /*deletes the entire table if it exists along with all it's data*/
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Professors;
DROP TABLE IF EXISTS Branch;


CREATE TABLE IF NOT EXISTS Branch (
    id VARCHAR(2) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
    /* CONSTRAINT id_chk CHECK (id like 'A%' OR id like 'B%') -> givees error not sure why (adding a constraint to ensure id column only contains values starting with A or B)*/
);

CREATE TABLE IF NOT EXISTS Students (
    id INT PRIMARY KEY, /*id is the column name, INT is the column data type, Primary key implies - not null, unique and automatically indexed*/
    name VARCHAR(50) NOT NULL, /*VARCHAR(50) means variable length string with max 50 characters, NOT NULL means this field must always have a value, if left as null then it throws error*/
    age INT CHECK (age >= 17),
    department VARCHAR(30),
    branch_id VARCHAR(2),
    FOREIGN KEY(branch_id) REFERENCES Branch(id) /*one to many relationship between Branch and Students table*/
    ON DELETE set null
) ENGINE = InnoDB; /*InnoDB is a storage engine that supports foreign key constraints and transactions*/

ALTER Table Students MODIFY id INT(4) ZEROFILL; /*INT(4) means id will have atleast 4 digits, ZEROFILL will allow the padding to be visible, modifies the id column to have leading zeros up to 4 digits e.g., 0001, 0002*/

ALTER TABLE Students DROP FOREIGN KEY Students_ibfk_1; /*drops the foreign key constraint previously added*/
ALTER TABLE Students ADD CONSTRAINT custom_fk_name FOREIGN KEY(branch_id) REFERENCES Branch(id) ON DELETE SET NULL ON UPDATE CASCADE; /*renames the foreign key constraint to custom_fk_name, also adds ON UPDATE CASCADE which means if the referenced Branch id is updated, it will automatically update in Students table*/

CREATE TABLE IF NOT EXISTS Courses (
    id INT,
    title VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0),
    type VARCHAR(20) NOT NULL,
    dept VARCHAR(20) NOT NULL,
    CONSTRAINT pk_course_id PRIMARY KEY (id)
);

/*Primary Keys and Foreign Keys are used to establish relationships between tables in a database. 
A Primary Key uniquely identifies each record in a table, while a Foreign Key is a field in one table that refers to the Primary Key in another table. 
This ensures referential integrity and helps maintain consistent and accurate data across related tables.*/

ALTER Table Students
RENAME COLUMN department TO dept,
ADD CONSTRAINT chk_dept CHECK (dept IN ('CSE', 'ECE', 'ME', 'EEE', 'ENI', 'ECON', 'BIO')); /*adding a constraint to ensure dept column only contains specified values*/

ALTER Table Courses
ADD COLUMN enrolled INT DEFAULT 0;

CREATE Table IF NOT EXISTS Professors (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, 
    dept VARCHAR(30) NOT NULL,
    joined date,
    in_time time DEFAULT '08:00:00'
);

CREATE TABLE IF NOT EXISTS Enrollments (
    student_id INT(4) ZEROFILL,
    course_id INT,
    PRIMARY KEY (student_id, course_id), /*composite primary key, many to many relationship*/
    FOREIGN KEY (student_id) REFERENCES Students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(id) ON DELETE CASCADE
);