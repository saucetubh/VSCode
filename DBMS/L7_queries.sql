create or replace view emp_dept_view as 
select e.emp_id,e.emp_name,d.dept_name,e.salary from employees e join departments d on e.dept_id=d.dept_id; 

select * from emp_dept_view where dept_name  ='Engineering';

create or replace view high_salary_emp as
select * from employees where salary>70000;

select * from high_salary_emp;

create or replace view dept_summary as 
select d.dept_name,sum(e.salary) as total_salary from departments d join employees e on e.dept_id=d.dept_id group by dept_name;

create or replace view dept_summary2 as 
select dept_name,sum(salary) as total_salary from emp_dept_view group by dept_name;

select * from dept_summary order by total_salary desc limit 1;

create or replace view it_employees as
select * from employees where dept_id=2;

delimiter $$ 
create function get_salary (e_id INT) returns decimal(10,2)
deterministic 
begin
    DECLARE emp_salary decimal(10,2);
    select salary into emp_salary from employees where emp_id=e_id;
    return emp_salary;
end $$
delimiter ;

delimiter $$
create function annual_salary (e_id INT) returns decimal(10,2) 
deterministic 
begin
    DECLARE sal decimal(10,2);
    select salary into sal from employees where emp_id=e_id;
    return 12*sal;
end $$
delimiter ;

delimiter $$
create function performance_grade (e_id INT) returns char 
deterministic 
begin
    declare grade char;
    declare sal decimal(10,2);
    select salary into sal from employees where emp_id=e_id;
    if sal<55000 then set grade='C'; end if;
    if sal>80000 then set grade='A'; end if;
    if sal>55000 and sal<80000 then set grade='B'; end if;
    return grade;
end $$
delimiter ;

create view project_orders as 
select o.order_id,e.emp_name,p.project_name,o.amount from orders o join employees e on o.emp_id=e.emp_id 
join projects p on o.project_id=p.project_id;

delimiter $$
create function total_orders (e_name VARCHAR(50)) returns decimal(10,2)
deterministic 
begin
    declare total_order decimal(10,2);
    select sum(amount) into total_order from project_orders where emp_name=e_name;
    return total_order;
end $$
delimiter ;

select emp_name,total_orders(emp_name) as total_amount from employees where total_orders(emp_name) is NOT NULL; 

delimiter $$
create function total_orders2 (e_name VARCHAR(50)) returns decimal(10,2)
deterministic 
begin
    declare total_order decimal(10,2);
    select sum(amount) into total_order from project_orders where emp_name=e_name;
    return IFNULL(total_order,0);
end $$
delimiter ;

select emp_name,total_orders2(emp_name) as total_amount from employees;