create table advisers(
	id int not null primary key,
	full_name varchar(50))

create table department(
	id int not null primary key,
	name_of_department varchar(50))

create table students(
	id int primary key not null,
	full_name varchar(50),
	faculty varchar(50),
	age int not null,
	adv_id int foreign key references advisers(id))

create table professors(
	id int not null primary key,
	prof_full_name varchar(50),
	graduate_degree varchar(50),
	speciality varchar(50),
	age int,
	hire_date date,
	birth_date date,
	is_visiting int,
	dep_id int foreign key references department(id))

create table courses(
	code int primary key,
	name_of_course varchar(50),
	faculty varchar(50),
	prof_id int foreign key references professors(id))

create table duration(
	id int foreign key references professors(id),
	start_date date,
	end_date date)
--as i understood
--this table is like a contract of temporary professors at the university


alter table advisers add unique (id);
alter table department add unique (id);
alter table duration add unique (id);
alter table professors add unique (id);
alter table students add unique (id);



alter table students add constraint pk_stu primary key(age)
-- inserting incorrect primary key
alter table students drop constraint pk_stu
-- deleting this PK
alter table students add primary key(id)
-- inserting another PK


-- checking is age of professor above 18
alter table professors add check (DATEDIFF(month, birth_date, GETDATE())/12 >= 18)

-- another checking
alter table professors add check (is_visiting < 2)
-- since there is no boolean data type i had to set in this way
-- 1 means temporary professor (TRUE)
-- 0 means permanent professor (FALSE)

-- later i understood that it is unneccesary column 
-- since we can find all temporary professory just by query
-- that i have shown below

-- tables are empty thats why there is no any results

-- 1
select * from professors p inner join duration d on p.id = d.id /* and p.is_visitng = 1 */ 

-- 2
-- professors who teach more than 2 courses
select id from professors where professors.id in (select p.id from professors p inner join courses c on p.id = c.prof_id group by id having count(*) > 2) 