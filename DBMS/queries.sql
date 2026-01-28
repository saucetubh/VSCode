SELECT name FROM Students WHERE age >=20;

SELECT title FROM Courses WHERE credits !=3;

SELECT credits, count(title) AS course_count FROM Courses GROUP BY credits; /*when using group by, columns listed in select must either be in group by or in an aggregate function like count(), max() etc*/

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
                AS credit_description /*creates new column in the output of the query*/
FROM Courses WHERE dept='CSE';

SELECT 
  count(*) AS professor_count,
  dept 
FROM 
  Professors
GROUP BY
  dept
HAVING /*WHERE comes after from but since we are grouping, we use HAVING. In short, WHERE works on rows, HAVING works on groups*/
  count(*) > 1;

Select * from professors order by joined ASC LIMIT 3; /*gives first 3 rows after sorting in ascending order of joined date*/

select name, dept from professors where joined > '2016-10-10';

SELECT age,dept,count(name) as student_count FROM Students GROUP BY age,dept HAVING age>19 and student_count>1; /*can use the column name that we defined earlier as well instead of count(name)*/

select dept,min(age) as youngest_student from students group by dept;

/*Practice concepts of JOIN, Foreign Key and Relational Tables*/

SELECT 
    s.id,
    s.name,
    s.dept,
    c.title AS course_name
FROM Enrollments e
JOIN Students s
    ON e.student_id = s.id
JOIN Courses c
    ON e.course_id = c.id
WHERE c.id = 101;

SELECT 
    s.id,
    s.name,
    c.id AS course_id,
    c.title
FROM Enrollments e
JOIN Students s ON e.student_id = s.id
JOIN Courses c ON e.course_id = c.id
WHERE s.id = 1;

