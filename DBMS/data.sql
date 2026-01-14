USE dbms_lab;

TRUNCATE TABLE Student; /*Truncating a table means removing all rows from the table, but the table structure and its columns, constraints, indexes etc. remain intact*/
TRUNCATE TABLE Course; /*Basically means everytime we source data.sql it rewrites all rows after truncating*/

INSERT INTO Student VALUES
(1, 'Aman', 19, 'CSE'),
(2, 'Riya', 20, 'ECE'),
(3, 'Karan', 21, 'ME'),
(4, 'Neha', 22, 'CSE'),
(5, 'Vikram', 20, 'ECE'),
(6, 'Pooja', 19, 'ME'),
(7, 'Rahul', 21, 'CSE'),
(8, 'Sneha', 22, 'ECE'),
(9, 'Aakash', 20, 'ME'),
(10, 'Tina', 19, 'CSE');


INSERT INTO Course VALUES
(101, 'Database Systems', 4, 'CDC', 'CSE'),
(102, 'Operating Systems', 3, 'DEL', 'CSE'),
(103, 'Data Structures and Algorithms', 4, 'CDC', 'CSE'),
(104, 'Computer Networks', 3, 'DEL', 'CSE'),
(106, 'Microprocessors and Interfacing', 4, 'CDC', 'CSE'),
(107, 'Digital Design', 4, 'CDC', 'CSE'),
(108, 'OOPS', 4, 'CDC', 'CSE'),
(109, 'DISCO', 3, 'DEL', 'CSE'),
(110, 'LCS', 3, 'DEL', 'CSE'), 
(201, 'Analog Circuits', 4, 'CDC', 'ECE'),
(202, 'Signals and Systems', 3, 'DEL', 'ECE'),
(203, 'Electromagnetic Theory', 4, 'CDC', 'ECE'),
(204, 'Digital Signal Processing', 3, 'DEL', 'ECE'),
(205, 'Microelectronics', 4, 'CDC', 'ECE'),
(301, 'Thermodynamics', 4, 'CDC', 'ME'),
(302, 'Fluid Mechanics', 3, 'DEL', 'ME'),
(303, 'Heat Transfer', 4, 'CDC', 'ME'),
(304, 'Manufacturing Processes', 3, 'DEL', 'ME');