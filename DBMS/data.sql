USE dbms_lab;

TRUNCATE TABLE Students; /*Truncating a table means removing all rows from the table, but the table structure and its columns, constraints, indexes etc. remain intact*/
TRUNCATE TABLE Courses; /*Basically means everytime we source data.sql it rewrites all rows after truncating*/

INSERT INTO Students VALUES
(1, 'Aman', 19, 'CSE'),
(2, 'Riya', 20, 'ECE'),
(3, 'Karan', 21, 'ME'),
(4, 'Neha', 22, 'CSE'),
(5, 'Vikram', 20, 'ECE'),
(6, 'Pooja', 19, 'ME'),
(7, 'Rahul', 21, 'CSE'),
(8, 'Sneha', 22, 'ECE'),
(9, 'Aakash', 20, 'ME'),
(10, 'Tina', 19, 'CSE'),
(11, 'Sonal', 21, 'ECE'),
(12, 'Aditya', 22, 'ME');


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
(1, 'Dr. Sharma', 'CSE'),
(2, 'Dr. Verma', 'ECE'),
(3, 'Dr. Gupta', 'ME'),
(4, 'Dr. Singh', 'CSE'),
(5, 'Dr. Patel', 'ECE');