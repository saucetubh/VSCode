CREATE DATABASE IF NOT EXISTS dbms_lab;

USE dbms_lab;

DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;

CREATE TABLE IF NOT EXISTS Student (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 17),
    department VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS Course (
    id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0),
    type VARCHAR(20) NOT NULL,
    dept VARCHAR(20) NOT NULL
);