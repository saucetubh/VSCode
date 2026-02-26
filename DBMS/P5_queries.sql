select location from Department where dept_id In (select distinct dept_id from Employee) AND dept_id In (select distinct dept_id from Project) order by location;

select proj_name from Project where proj_id NOT IN (select distinct proj_id from EmpProject) order by proj_name;

select name from Employee e where e.emp_id=(select ep.emp_id from EmpProject ep group by ep.emp_id order by sum(ep.hours_worked) desc limit 1);

select location from department where dept_id =(select dept_id from Employee where emp_id=(select manager_id from Employee where name='Ivan'));

select proj_name from Project where proj_id in (select proj_id from EmpProject where emp_id in (select emp_id from Employee where year(join_date)<2020 AND dept_id=(select dept_id from department where dept_name='Engineering'))) order by proj_name;

select distinct d.location from department d join employee e on d.dept_id=e.dept_id join project p on d.dept_id=p.dept_id order by location;

select distinct proj_name from project p left join EmpProject ep on p.proj_id=ep.proj_id where emp_id is null order by proj_name;

select e.name from Employee e join EmpProject ep on e.emp_id=ep.emp_id group by e.name order by sum(ep.hours_worked) desc limit 1;

select d.location from Employee e join Employee m on e.manager_id=m.emp_id join department d on m.dept_id=d.dept_id where e.name='Ivan';

select distinct p.proj_name from Employee e join EmpProject ep on e.emp_id=ep.emp_id join Project p on ep.proj_id=p.proj_id join Department d on e.dept_id=d.dept_id where year(join_date)<2020 and dept_name='Engineering' order by proj_name;


/*
select * from Employee e join EmpProject ep using(emp_id) join Project p using(proj_id); this uses natural join concept, merges column with same heading in the tables being joined
select * from Employee e join EmpProject ep on e.emp_id=ep.emp_id join Project p on ep.proj_id=p.proj_id; this retains duplicate columns, so resultant table has multiple id columns
*/

SELECT e1.name, e1.salary, e1.dept_id
FROM Employee e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e1.dept_id
);