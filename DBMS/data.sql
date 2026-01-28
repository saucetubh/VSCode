USE dbms_lab;

/*
TRUNCATE TABLE Branch;
TRUNCATE TABLE Students; 
Truncating a table means removing all rows from the table, but the table structure and its columns, constraints, indexes etc. remain intact
TRUNCATE TABLE Courses; Basically means everytime we source data.sql it rewrites all rows after truncating
TRUNCATE TABLE Professors;
Truncating tables when foreign key constraints exists leads to errors. Nuances have to be dealt with. Hence dont truncate for now
*/

INSERT INTO Branch VALUES
('AA', 'ECE'),
('A7', 'CSE'),
('A4', 'ME'),
('A3', 'EEE'),
('A8', 'ENI'),
('B3', 'ECON'),
('B1', 'BIO');

INSERT INTO Students VALUES
(1, 'Aman', 19, 'CSE', 'A7'),
(2, 'Riya', 20, 'ECE', 'AA'),
(3, 'Karan', 21, 'ME', 'A4'),
(4, 'Neha', 22, 'CSE', 'A7'),
(5, 'Vikram', 20, 'ECE', 'AA'),
(6, 'Pooja', 19, 'ME', 'A4'),
(7, 'Rahul', 21, 'CSE', 'A7'),
(8, 'Sneha', 22, 'ECE', 'AA'),
(9, 'Aakash', 20, 'ME', 'A4'),
(10, 'Tina', 19, 'CSE', 'A7'),
(11, 'Sonal', 21, 'ECE', 'AA'),
(12, 'Aditya', 22, 'ME', 'A4'),
(13, 'Maya', 20, 'ECON', 'B3'),
(14, 'Rohan', 19, 'BIO', 'B1'),
(15, 'Isha', 21, 'ECON', 'B3'),
(16, 'Kabir', 22, 'BIO', 'B1');


INSERT INTO Courses VALUES
(101, 'Database Systems', 4, 'CDC', 'CSE', 23),
(102, 'Operating Systems', 3, 'DEL', 'CSE', 18),
(103, 'Data Structures and Algorithms', 4, 'CDC', 'CSE', 25),
(104, 'Computer Networks', 3, 'DEL', 'CSE', 20),
(106, 'Microprocessors and Interfacing', 4, 'CDC', 'CSE', 22),
(107, 'Digital Design', 4, 'CDC', 'CSE', 19),
(108, 'OOPS', 4, 'CDC', 'CSE', 21),
(109, 'DISCO', 3, 'DEL', 'CSE', 17),
(110, 'LCS', 3, 'DEL', 'CSE', 16), 
(201, 'Analog Circuits', 4, 'CDC', 'ECE', 24),
(202, 'Signals and Systems', 3, 'DEL', 'ECE', 20),
(203, 'Electromagnetic Theory', 4, 'CDC', 'ECE', 22),
(204, 'Digital Signal Processing', 3, 'DEL', 'ECE', 19),
(205, 'Microelectronics', 4, 'CDC', 'ECE', 21),
(301, 'Thermodynamics', 4, 'CDC', 'ME', 23),
(302, 'Fluid Mechanics', 3, 'DEL', 'ME', 18),
(303, 'Heat Transfer', 4, 'CDC', 'ME', 20),
(304, 'Manufacturing Processes', 3, 'DEL', 'ME', 17);

INSERT INTO Professors VALUES 
(1, 'Dr. Sharma', 'CSE', '2015-08-15', '09:00:05'),
(2, 'Dr. Verma', 'ECE', '2016-09-10', DEFAULT),
(3, 'Dr. Gupta', 'ME', '2017-07-20', '08:04:50'),
(4, 'Dr. Singh', 'CSE', '2020-01-01', '08:20:00'),
(5, 'Dr. Patel', 'ECE', '2019-05-30', '17:10:41');

INSERT INTO Enrollments VALUES
(0001, 101),
(0001, 102),
(0002, 201),
(0002, 202),
(0003, 301),
(0003, 302),
(0004, 103),
(0004, 104),
(0005, 203),
(0005, 204),
(0006, 303),
(0006, 304),
(0007, 203),
(0007, 106),
(0008, 205),
(0008, 101),
(0009, 107),
(0009, 102),
(0010, 108),
(0010, 103);