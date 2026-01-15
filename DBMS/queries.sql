SELECT name FROM Students WHERE age >=20;

SELECT title FROM Courses WHERE credits !=3;

SELECT credits, count(title) AS course_count FROM Courses GROUP BY credits;

SELECT dept, AVG(age) as avg_age from Students group by dept; 

SELECT dept, count(title) as cdc_count from Courses where type='CDC' group by dept; 

SELECT dept,
       COUNT(CASE WHEN type = 'CDC' THEN title END) AS cdc_count,
       COUNT(CASE WHEN type = 'DEL' THEN title END) AS del_count
FROM Courses
GROUP BY dept;

SELECT * FROM Students ORDER BY age;

SELECT * FROM Students ORDER BY age DESC, name ASC; /*first condition takes priority*/

SELECT * FROM Students WHERE name LIKE 'A%' ORDER BY name;

WITH ordered_table AS (SELECT * FROM Students ORDER BY age DESC, name ASC) SELECT id,name,age from ordered_table WHERE dept='CSE'; /*kind of like nesting queries?*/

Select title, CASE 
                WHEN credits = 3 THEN 'no lab'
                WHEN credits = 4 THEN 'lab'
              END 
                AS credit_description
FROM Courses WHERE dept='CSE';

SELECT 
  count(*),
  dept 
FROM 
  Professors
GROUP BY
  dept
HAVING
  count(*) > 1;