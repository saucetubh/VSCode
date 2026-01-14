SELECT name FROM student WHERE age >=20;

SELECT title FROM course WHERE credits !=3;

SELECT credits, count(title) AS course_count FROM course GROUP BY credits;

SELECT department, AVG(age) as avg_age from student group by department; 

SELECT dept, count(title) as cdc_count from course where type='CDC' group by dept; 

SELECT dept,
       COUNT(CASE WHEN type = 'CDC' THEN title END) AS cdc_count,
       COUNT(CASE WHEN type = 'DEL' THEN title END) AS del_count
FROM course
GROUP BY dept;

SELECT * FROM student ORDER BY age;

SELECT * FROM student ORDER BY age DESC, name ASC; /*first condition takes priority*/

SELECT * FROM student WHERE name LIKE 'A%';