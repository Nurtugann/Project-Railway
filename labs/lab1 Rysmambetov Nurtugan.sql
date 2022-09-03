/*create database university
use university

CREATE TABLE EMPLOYEES
( EMPLOYEE_ID INT,
 FULL_NAME VARCHAR(max),
 EMAIL VARCHAR(max),
 PHONE_NUMBER VARCHAR(max),
 HIRE_DAT DATE ,
 JOB_ID VARCHAR(max),
 SALARY integer
); 


insert into EMPLOYEES values 
(100, 'Steven King', 'SKING', '515.123.4567', '17-06-87', 'AD_PRES', 24000 ),
(101, 'Neena Kochhar', 'NKOCHAR', '515.123.4568', '21-09-89', 'AD_VP', 17000 ),
(102, 'Lex De Haan', 'LDEHAA', '515.123.4569', '13-03-93', 'AD_VP', 17000 ),
(103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', '03-01-90', 'IT_PROG', 9000 ),
(104, 'Bruce Ernst', 'BENST', '590.423.4568', '21-05-91', 'IT_PROG', 6000 ),
(107, 'Diana Lorentz', 'DLORENTZ', '590.423.5565', '07-02-99', 'IT_PROG', 4000 ),
(124, 'Kevin Mourgos', 'KNOURGOS', '650.123.5234', '16-11-99', 'SH_MAN', 5800 ),
(141, 'Trenna Rajs', 'TRAJS', '650.121.8009', '17-10-95', 'SH_CLERK', 3500 ),
(142, 'Curtis Davies', 'CDAVIES', '650.121.2996', '29-01-97', 'SH_CLERK', 3100 ),
(143, 'Randall Matos', 'RMATOS', '650.121.2874', '15-03-98', 'SH_CLERK', 2600 ),
(144, 'Peter Vargas', 'PVARGAS', '650.121.2004', '09-07-98', 'SH_CLERK', 2500 ),
(149, 'Eleni Zlotkey', 'EZLOTKEY', '011.44.1344.429010', '29-01-00', 'SA_MAN', 7000 ),
(174, 'Ellen Abel', 'ABELL', '011.44.1644.429267', '11-05-96', 'SA_REP', 11000 ),
(176, 'Jonathon Taylor', 'JTAILOR', '011.44.1644.429265', '24-03-98', 'SA_REP', 8600 ),
(178, 'Kimberely Grant', 'KGRANT', '011.44.1644.429263', '24-05-99', 'SA_REP', 7000 ),
(200, 'Jennifer Whalen', 'JWHALEN', '515.123.4444', '17-09-87', 'AD_ASST', 4001 ),
(201, 'Michael Hartstein', 'MHARTSTE', '515.123.5555', '17-02-96', 'MK_MAN', 13000 ),
(202, 'Pat Fay', 'PFAY', '603.123.666', '17-08-97', 'MK_REP', 6000 ),
(205, 'Shelley Higgins', 'SHIGGIN', '515.123.8080', '07-06-94', 'AC_MGR', 12000 ),
(206, 'William Gietz', 'WGIE', '515.123.8181', '07-06-94', 'AC_ACCOUNT', 8300 );
*/


--2 
--showing whole table
select*from EMPLOYEES

--3
--showing unique JOB_ID
select distinct(JOB_ID) from EMPLOYEES;

--4
--showing all data about employee if he is earning more than 5000 per month
select*from EMPLOYEES where SALARY > 5000;

--5
--showing all data about employee if he is earning more than 4000 and less than 7000 per month
select*from EMPLOYEES where SALARY between 4000 and 7000;

--6
--showing all data about employee if he is earning more than 9000 and less than 3000 per month
select*from EMPLOYEES where SALARY not between 3000 and 9000;

--7
--showing some data about employee if he is earning less than 5000
--here i googled how to find name and surname if they are devided by space in one string
select EMPLOYEE_ID, Substring(FULL_NAME, Charindex(' ', FULL_NAME)+1, LEN(FULL_NAME)) as Surname, Substring(FULL_NAME, 1,Charindex(' ', FULL_NAME)-1) as Name,  SALARY  from EMPLOYEES where SALARY < 5000;

--8
--showing some data about employee if he is earning i range(4001,6999)
select EMPLOYEE_ID, FULL_NAME, SALARY  from EMPLOYEES where SALARY between 4001 and 6999;

--9
--showing some data of employees by their id
select EMPLOYEE_ID, FULL_NAME, SALARY, JOB_ID from EMPLOYEES where EMPLOYEE_ID in (144,102,200,205);

--10
--showing some data of employees by their id (same as previous)
select EMPLOYEE_ID, FULL_NAME, SALARY, JOB_ID from EMPLOYEES where EMPLOYEE_ID not in (144,102,200,205);

--11
--showing some data about employee if second letter in surname is "a"
select EMPLOYEE_ID, FULL_NAME, SALARY, JOB_ID from EMPLOYEES where substring(Substring(FULL_NAME, Charindex(' ', FULL_NAME)+1, LEN(FULL_NAME)), 2, 1) = 'a';

--12
--same as previous task but here name instead of surname
select EMPLOYEE_ID, FULL_NAME, SALARY, JOB_ID from EMPLOYEES where substring(Substring(FULL_NAME, 1,Charindex(' ', FULL_NAME)-1), 3, 1) = 'a';

--13
--adding two strings
select EMPLOYEE_ID, FULL_NAME, SALARY, EMAIL from EMPLOYEES where SUBSTRING(Substring(FULL_NAME, 1,Charindex(' ', FULL_NAME)-1),1,1)+Substring(FULL_NAME, Charindex(' ', FULL_NAME)+1, LEN(FULL_NAME))=EMAIL;
-- seems that program considering lower and upper cases itself (S=s)

--14
--showing data by some order
select EMPLOYEE_ID, FULL_NAME, EMAIL, SALARY from EMPLOYEES order by SALARY desc, HIRE_DAT desc;

--15
--showing data by some order
select EMPLOYEE_ID, FULL_NAME, SALARY from EMPLOYEES order by EMPLOYEE_ID desc;

--16
--showing average max min salary of programmers
select AVG(SALARY), MAX(SALARY), MIN(SALARY) from EMPLOYEES where JOB_ID='IT_PROG';

--17
--show if first == last char in phone number
select*from EMPLOYEES where SUBSTRING(PHONE_NUMBER,1,1)=SUBSTRING(PHONE_NUMBER,len(PHONE_NUMBER),1)

--18
--showing number of unique jobs
select count(distinct(JOB_ID)) from EMPLOYEES

--19
--all expenses for each category of job
select sum(SALARY) as sum_of_salary_for_each_job_title from EMPLOYEES group by JOB_ID

--20
--avg expenses for each category of job
select avg(SALARY) as avg_of_salary_for_each_job_title from EMPLOYEES group by JOB_ID

--21
--showing who are earning too much
select max(SALARY) as max_salary_for_each_job_title from EMPLOYEES group by JOB_ID having MAX(SALARY) > 10000 order by MAX(SALARY) desc

--22
--showing the most earning job category
select max(my_avg) from (select avg(SALARY) as my_avg from EMPLOYEES group by JOB_ID) a;

--23
--just dream of employees
select concat(FULL_NAME , ' earns ' , SALARY , ' per month, but wants ' , SALARY*3) as Dream_Salaries from EMPLOYEES

--24
--couning number of letters in full name including spaces
select FULL_NAME, len(FULL_NAME) as len from EMPLOYEES

--25
--showing names of employees
select Substring(FULL_NAME, 1,Charindex(' ', FULL_NAME)-1) as first_name from EMPLOYEES

--26
--showing first 3 letters of names
select SUBSTRING(Substring(FULL_NAME, 1,Charindex(' ', FULL_NAME)-1), 1, 3) as first_3_letters from EMPLOYEES

--27
--reversing their fullname
select REVERSE(Substring(FULL_NAME, 1,Charindex(' ', FULL_NAME)-1)) as reverse from EMPLOYEES

--28
--I AM NOT STEVYU, I AM STEVEN!!!
select REPLACE(FULL_NAME,'en','yu') as replace from EMPLOYEES

--29
--converting all leters to uppercase
select UPPER(FULL_NAME) as upper from EMPLOYEES

--30
--counted all expenses for all employees up to 2000 year
select concat(sum(DATEDIFF(MONTH, 2000-00-00, HIRE_DAT) * SALARY), '$ before 2000 year') as 'all period salaries' from EMPLOYEES

--1
--showing employees whose salary higher than avg salary
select * from  employees where salary > (select avg(salary) from EMPLOYEES where JOB_ID = 'IT_PROG')

--2
--names whose length of name more than avg
select full_name from EMPLOYEES where len(full_name) - 1 > (select avg(len(full_name) - 1) from employees)

--3
--employees with min slary in each department
select min(salary) as 'min salary', DEPARTMENT_ID from EMPLOYEES group by DEPARTMENT_ID

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
-- i didnt get what does mean maximum average in each department
-- i just showed avg salary in each department
select DEPARTMENT_NAME, avg(salary) as 'average' from departments right join EMPLOYEES on DEPARTMENTS.MANAGER_ID = EMPLOYEES.EMPLOYEE_ID group by DEPARTMENT_NAME


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
-- showing employees whose hire date > 01.01.1995 
select e.full_name, e.JOB_ID, d.department_name, e.hire_dat from EMPLOYEES e,DEPARTMENTS d, JOB_GRADES j where e.DEPARTMENT_ID = d.DEPARTMENT and e.HIRE_DAT > '01-01-95' and e.HIRE_DAT <= '11-02-22' and e.SALARY >= j.LOWEST_SAL and e.SALARY < j.HIGHEST_SAL and j.GRA in ('A','B','C')

--13
-- name of city of each employee
select e.FULL_NAME, l.loc_name from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID

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
-- finding coolgues of 142 and 144
select * from EMPLOYEES e, DEPARTMENTS d where e.DEPARTMENT_ID = d.DEPARTMENT and e.DEPARTMENT_ID = 50 and e.EMPLOYEE_ID not in (142,144)

--18 (надо спросить)
-- companies ordered by abg salary, i cant select 3rd from bootom company but in 15th task it worked
select avg(e.salary) as avg_salary, department_name from EMPLOYEES e, DEPARTMENTS d where e.DEPARTMENT_ID = d.DEPARTMENT group by DEPARTMENT_NAME  order by avg_salary desc

--19
-- findin all companies in random city
select * from EMPLOYEES e where e.EMPLOYEE_ID in (select EMPLOYEE_ID from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.LOC_NAME = 'Nara')  

--20
-- employes who are not managers
select e.EMPLOYEE_ID from EMPLOYEES e where e.EMPLOYEE_ID not in (select MANAGER_ID from DEPARTMENTS)

--21
-- city of random employee
select l.loc_name from EMPLOYEES e,DEPARTMENTS d, LOCATIONS l where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and e.EMPLOYEE_ID = 178

--22
-- counts subordinates of each manager
select d.MANAGER_ID, count(*)-1 as subordinates from EMPLOYEES e, DEPARTMENTS d where e.DEPARTMENT_ID = d.DEPARTMENT group by d.MANAGER_ID

--23
-- Write a query to display all the information about a manager who is also a subordinate.
-- i understood it like managers who also has manager
-- no such managers
select * from DEPARTMENTS d1, EMPLOYEES e1, DEPARTMENTS d2 where d1.DEPARTMENT = e1.DEPARTMENT_ID and d1.MANAGER_ID = e1.EMPLOYEE_ID and e1.DEPARTMENT_ID = d2.DEPARTMENT and d2.MANAGER_ID != e1.EMPLOYEE_ID



--24
select top 2 e.FULL_NAME from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.COUNTRY_ID = c.COUNTRY_ID and c.COUNTRY_NAME = 'Japan'  order by e.SALARY desc
select top 2 e.FULL_NAME from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.COUNTRY_ID = c.COUNTRY_ID and c.COUNTRY_NAME = 'Spain'  order by e.SALARY desc

--25
-- cities with companies at least 2 employees
select distinct(c.COUNTRY_NAME), l.LOC_NAME, count(d.department) as number_of_companies from EMPLOYEES e, DEPARTMENTS d, LOCATIONS l, COUNTRIES c where e.DEPARTMENT_ID = d.DEPARTMENT and d.LOCATION_ID = l.LOC_ID and l.COUNTRY_ID = c.COUNTRY_ID and d.DEPARTMENT in (select DEPARTMENT_ID from EMPLOYEES group by DEPARTMENT_ID having count(*) > 1) group by c.COUNTRY_NAME, l.LOC_NAME



--26
--finding who is eaning most in each department
SELECT e.FULL_NAME, e.EMPLOYEE_ID FROM employees e WHERE e.salary IN (SELECT max(salary) FROM employees GROUP BY EMPLOYEE_ID);
