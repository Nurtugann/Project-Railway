--1 
select name from student

--2
select lecturer from subject

--3
select * from subject where lecturer = 'curtis'

select * from subject where code = 'cs1500' or code = 'cs3010'

--4
select * from student where id = '1234' or id = '4000'

select * from student where name = 'joe' or name = 'hector'

select * from student minus select * from student where name = 'ling'
-- difference operator isnt working then another approach
select * from student where name != 'ling'

--5
select * from student, enroll where student.name = 'joe'

--6
select * from student, enroll where student.name = 'joe' and enroll.id = 1234

--7
select student.id,name,code from student, enroll where student.name = 'joe' and enroll.id = 1234

--8
select student.id,code from student, enroll where student.name = 'joe' and enroll.id = 1234

--9
select student.id, student.name, enroll.code, subject.lecturer from student, enroll, subject  where student.id = enroll.id and enroll.code = subject.code and student.name = 'hector'

--10
select student.name, subject.lecturer from student, enroll, subject  where student.id = enroll.id and enroll.code = subject.code and subject.lecturer = 'curtis'

