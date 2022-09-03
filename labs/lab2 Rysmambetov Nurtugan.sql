--1
--showing employees whose salary higher than avg salary
select * from  employees where salary > (select avg(salary) from EMPLOYEES where JOB_ID = 'IT_PROG')

--2
--names whose length of name more than avg
select full_name from EMPLOYEES where len(full_name) - 1 > (select avg(len(full_name) - 1) from employees)

--3
--employees with min slary in each department
select EMPLOYEE_ID, FULL_NAME, SALARY from EMPLOYEES e where e.SALARY in (select min(SALARY) from EMPLOYEES group by DEPARTMENT_ID) 










--4
--department with most experienced manager (hire date should be least)
select DEPARTMENT, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID from DEPARTMENTS inner join EMPLOYEES on DEPARTMENTS.MANAGER_ID = EMPLOYEES.EMPLOYEE_ID where HIRE_DAT = (select min(hire_dat) from DEPARTMENTS left join EMPLOYEES on DEPARTMENTS.MANAGER_ID = EMPLOYEES.EMPLOYEE_ID)

--5
-- most numerous department
select DEPARTMENT_NAME, avg(SALARY) as 'average' from EMPLOYEES inner join DEPARTMENTS on EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT group by DEPARTMENT_NAME having count(DEPARTMENT_NAME) = (select max(counts) from (select count(*) as counts from EMPLOYEES group by DEPARTMENT_ID) a)


--6
-- departments which min salary is higher than min salary of 50th department
SELECT department_name FROM departments inner join EMPLOYEES on DEPARTMENTS.MANAGER_ID = EMPLOYEES.EMPLOYEE_ID WHERE department_id IN (SELECT department_id FROM employees GROUP BY department_id HAVING MIN(salary) > (SELECT MIN(salary) FROM employees WHERE department_id = 50));

--7
-- showing which departments avg(salary) is most higher
select max(e.averagee) as 'max average'
from (select DEPARTMENT_NAME, avg(salary) as averagee 
from departments right join EMPLOYEES on DEPARTMENTS.MANAGER_ID = EMPLOYEES.EMPLOYEE_ID group by DEPARTMENT_NAME) e

select DEPARTMENT_NAME, avg(salary) as averagee 
from departments right join EMPLOYEES on DEPARTMENTS.MANAGER_ID = EMPLOYEES.EMPLOYEE_ID group by DEPARTMENT_NAME









--8
-- department name for each employee
select full_name,  DEPARTMENT_NAME from EMPLOYEES left join DEPARTMENTS on DEPARTMENTS.DEPARTMENT = EMPLOYEES.DEPARTMENT_ID


--9
-- departments that has no employees
SELECT DEPARTMENT FROM departments WHERE department NOT IN (select department_id FROM employees);


--10
--showing job grade for each employee
select full_name, GRA from EMPLOYEES left join JOB_GRADES on SALARY >= LOWEST_SAL and SALARY < HIGHEST_SAL

--11
-- showing number of employees and managers name for each department
select d.DEPARTMENT_NAME, e.full_name as managers_name, c.counts as number_of_employees from DEPARTMENTS d, EMPLOYEES e, (select DEPARTMENT_NAME, count(*) as counts from DEPARTMENTS left join EMPLOYEES on DEPARTMENT = DEPARTMENT_ID where DEPARTMENT in (select DEPARTMENT_ID from EMPLOYEES) group by DEPARTMENT_NAME) c 
where d.MANAGER_ID = e.EMPLOYEE_ID and d.DEPARTMENT_NAME = c.department_name 

--12
-- showing employees whose hire date > 01.01.1995  and grade is in (A,B,C)
select e.full_name, e.JOB_ID, d.department_name, e.hire_dat from EMPLOYEES e,DEPARTMENTS d, JOB_GRADES j 
where e.DEPARTMENT_ID = d.DEPARTMENT and e.HIRE_DAT > '01-01-95' and e.HIRE_DAT <= '11-02-21' and e.SALARY >= j.LOWEST_SAL 
and e.SALARY < j.HIGHEST_SAL and j.GRA in ('A','B','C')








--13
-- name of city of each employee
select e.FULL_NAME, l.loc_name as city from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID

--14
-- showing pension contribution, annual pension contribution, medicine contribution (just multplying by some coeficent)
select e.FULL_NAME, l.loc_name, e.SALARY / 10 as 'montly_pension_contribution' , e.SALARY * 1.2 as 'annual_pension_contribution', e.SALARY * 0.09 as 'medicine contribution' from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID

--15
-- selectin top 3 most earning cities
 select top 3 l.loc_name, ed.salary from (select d.location_id, avg(e.SALARY) as salary from DEPARTMENTS d, EMPLOYEES e where d.DEPARTMENT = e.DEPARTMENT_ID group by LOCATION_ID) ed, LOCATIONS l where  ed.LOCATION_ID = l.LOC_ID order by ed.salary desc;

--16
-- finding employyes whose manager earning less than him
select e1.EMPLOYEE_ID, e1.FULL_NAME, e1.EMAIL, e1.PHONE_NUMBER, e1.HIRE_DAT, e1.JOB_ID, e1.SALARY, e1.DEPARTMENT_ID, 'manager is loser' as 'about manager' from EMPLOYEES e1, EMPLOYEES e2, DEPARTMENTS d where e1.DEPARTMENT_ID = d.DEPARTMENT and d.MANAGER_ID = e2.EMPLOYEE_ID and e1.SALARY > e2.SALARY  

--17
-- finding employees who work with 142 and 144 wihjout manager
select * from EMPLOYEES e, DEPARTMENTS d where e.DEPARTMENT_ID = d.DEPARTMENT and
e.DEPARTMENT_ID = 50 and e.EMPLOYEE_ID not in (142,144) and e.EMPLOYEE_ID != d.MANAGER_ID





--18 (íàäî ñïðîñèòü)
-- companies ordered by abg salary, i cant select 3rd from bootom company but in 15th task it worked
/* it does not work*/	
/* select top 3 * from (select avg(e.salary) as avg_salary, department_name from EMPLOYEES e, DEPARTMENTS d where e.DEPARTMENT_ID = d.DEPARTMENT group by DEPARTMENT_NAME  order by avg_salary asc) e
select avg(e.salary) as avg_salary, department_name from EMPLOYEES e, DEPARTMENTS d where e.DEPARTMENT_ID = d.DEPARTMENT group by DEPARTMENT_NAME  order by avg_salary */
SELECT TOP 1 DEPARTMENT_NAME as 'serched' FROM (SELECT TOP 3 AVG(SALARY) AS 'AVG_SAL',Department_name FROM EMPLOYEES 
e INNER JOIN Departments d ON e.DEPARTMENT_ID=d.DEPARTMENT GROUP BY d.DEPARTMENT_NAME ORDER BY AVG(SALARY) ASC) AS TOP_TABLE ORDER BY AVG_SAL DESC
-- third query works coorectly





--19
-- findin all companies in <select any city from the table LOCATIONS at your discretion>.
select * from EMPLOYEES e where e.EMPLOYEE_ID in (select EMPLOYEE_ID from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.LOC_NAME = 'Nara')  

--20
-- employes who are not managers
select * from EMPLOYEES where EMPLOYEE_ID in 
( select EMPLOYEE_ID from EMPLOYEES e, DEPARTMENTS d where e.EMPLOYEE_ID != d.MANAGER_ID and e.DEPARTMENT_ID = d.DEPARTMENT)










--21
-- city of random employee
select l.loc_name from EMPLOYEES e,DEPARTMENTS d, LOCATIONS l where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and e.EMPLOYEE_ID = 178

--22
-- counts subordinates of each manager
select d.MANAGER_ID, count(*)-1 as subordinates from EMPLOYEES e, DEPARTMENTS d where e.DEPARTMENT_ID = d.DEPARTMENT group by d.MANAGER_ID

--23
-- Write a query to display all the information about a manager who is also a subordinate.
-- i understood that i should show managers who also has manager
-- there is no such managers
select * from DEPARTMENTS d1, EMPLOYEES e1, DEPARTMENTS d2 where d1.DEPARTMENT = e1.DEPARTMENT_ID 
and d1.MANAGER_ID = e1.EMPLOYEE_ID and e1.DEPARTMENT_ID = d2.DEPARTMENT and d2.MANAGER_ID != e1.EMPLOYEE_ID

--24 
/*Calculate and display average salary of the first 2 employees for Japan and Spain (2 from each mandatory). 
The first two people salary info must be from Japan and the rest from Spain. 
Sort employees by full name alphabetically internally (for each country separately). 
Finally display: The average salary is ‘average_salary’ of 2 employees in ‘country_name’. 
Finally must be 2 sentences (2 rows of output) in one your query.*/
-- i dont know how to ouput 2 rows in one query
select * from (select top 2 e.FULL_NAME, c.COUNTRY_NAME, e.SALARY from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c 
where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.COUNTRY_ID = c.COUNTRY_ID and c.COUNTRY_NAME = 'Japan') e order by e.FULL_NAME

select avg(e.salary) as 'average_salary of japan' from (select * from (select top 2 e.FULL_NAME, c.COUNTRY_NAME, e.SALARY 
from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID 
and l.COUNTRY_ID = c.COUNTRY_ID and c.COUNTRY_NAME = 'Japan') e /*order by e.FULL_NAME*/) e

select * from (select top 2 e.FULL_NAME, c.COUNTRY_NAME, e.SALARY from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c 
where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.COUNTRY_ID = c.COUNTRY_ID and c.COUNTRY_NAME = 'Spain') n order by n.full_name
select avg(e.salary) as 'average_salary of spain' from (select * from (select top 2 e.FULL_NAME, c.COUNTRY_NAME, e.SALARY 
from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID 
and l.COUNTRY_ID = c.COUNTRY_ID and c.COUNTRY_NAME = 'Spain') n /*order by n.full_name*/) e



--25
-- cities with companies at least 2 employees
select distinct(c.COUNTRY_NAME), l.LOC_NAME, count(d.department) as number_of_companies from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.COUNTRY_ID = c.COUNTRY_ID and d.DEPARTMENT in (select DEPARTMENT_ID from EMPLOYEES group by DEPARTMENT_ID having count(*) >= 2) group by c.COUNTRY_NAME, l.LOC_NAME

--26
--finding who is eaning most in each department
SELECT e.FULL_NAME, e.EMPLOYEE_ID FROM employees e WHERE e.salary IN (SELECT max(salary) FROM employees GROUP BY EMPLOYEE_ID);
