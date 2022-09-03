	--create view males as (select * from passengers where GENDER = 'male');
	--create view females as (select * from passengers where GENDER = 'female');
--1
select * from passengers

-- 2
select * from males
select * from females
-- select COUNT(*) as 'number_of_passengers' from passengers GROUP BY GENDER
declare @count_of_males as int
declare @count_of_females as int
set @count_of_males = (select COUNT(*) from males)
set @count_of_females = (select COUNT(*) from females)

if @count_of_females + @count_of_males = (select count(*) from passengers)
	print 'MATCH'
else 
	print 'NOT MATCH'


--3
select cabin, count(*) from passengers group by CABIN

--4
select * from passengers where EMBARKED is null

--5
declare @survived_males int
declare @survived_females int

set @survived_males = (select COUNT(*) from passengers where GENDER = 'male' and SURVIVED = 1)
set @survived_females = (select COUNT(*) from passengers where GENDER = 'female' and SURVIVED = 1)

select @survived_males * 100/ (@survived_females + @survived_males) as 'males', @survived_females * 100 / (@survived_females + @survived_males) as 'females'

--6
declare @avg_age int
set @avg_age = (select avg(age) from passengers where SURVIVED = 0)
print 'avg age of victims is ' + Convert(varchar, @avg_salary)

--7
DECLARE @num_of_absense AS INT
SET @num_of_absense=(SELECT COUNT(PASSENGERID) FROM dbo.passengers)-(SELECT COUNT(CABIN) AS COUNTS FROM dbo.passengers)

SELECT PASSENGERID,SURVIVED,PCLASS,NAME,GENDER,AGE,SIBSP,PARCH,TICKET,FARE,passengers.CABIN,EMBARKED,ISNULL(COUNTS,@num_of_absense) AS NUM_CABIN FROM dbo.passengers 
LEFT JOIN dbo.cabins ON passengers.CABIN=cabins.CABIN ORDER BY PASSENGERID ASC
--8
drop view names

go
create view names as select p.name as 'full name', left(p.name, charindex(',', p.name) - 1) as 'last name' from passengers p
go

drop view names
drop view for_maiden_names
go
CREATE VIEW for_maiden_names AS
SELECT NAME AS ORIGINAL_NAME, LEFT(NAME,CHARINDEX(',',NAME)-1) AS LAST_NAME, 
REPLACE(RIGHT(NAME,(LEN(NAME)-LEN(LEFT(NAME,CHARINDEX('.',NAME))))),SUBSTRING(NAME,CHARINDEX('(',NAME),(CHARINDEX(')',NAME)-CHARINDEX('(',NAME)+1)),'') AS FIRST_NAME,
REPLACE(SUBSTRING(NAME,CHARINDEX('(',NAME),(CHARINDEX(')',NAME)-CHARINDEX('(',NAME))),'(','') AS MAIDEN_NAME 
FROM dbo.passengers
go
select * from for_maiden_names

--9
select regalia, COUNT(regalia) AS count 
from (select SUBSTRING(NAME,CHARINDEX(',',name)+1,CHARINDEX('.',NAME) - CHARINDEX(',',name)) as regalia from dbo.passengers)
as TMP_TABLE group by regalia

--10

select * from passengers
go
create view names as select p.PARCH,p.SIBSP, substring(p.name, 0, charindex(',', p.name) - 1) as 'last_name', RIGHT(p.name,len(p.name)-charindex(',', p.name)) as 'first_name' from passengers p
go
select * from names
SELECT last_name AS family,first_name as 'member' FROM names WHERE SIBSP>0 OR PARCH>0 ORDER BY last_name 
drop view names

--11
drop view tmp_table
drop view tmp_table2
go
create view tmp_table as select *, substring(name, 0, charindex(',', name) - 1) as family from passengers
go
select * from tmp_table
go
create view tmp_table2 as select count(*) as counts, family from tmp_table group by family
go
select PASSENGERID, NAME, counts from tmp_table inner join tmp_table2 on tmp_table.family = tmp_table2.family order by NAME

--12
drop view TWELVE_A
drop view TWELVE_B
drop view TWELVE_C
drop view TWELVE_D
GO
CREATE VIEW TWELVE_A AS SELECT name AS ORIGINAL_NAME, LEFT(name,CHARINDEX(',',name)-1) AS LAST_NAME, RIGHT(name,(LEN(name)-LEN(LEFT(name,CHARINDEX('.',name))))) as FIRST_NAME, AGE, SIBSP, PARCH FROM dbo.passengers WHERE AGE<18 AND PARCH=0
GO
select * from TWELVE_A

GO
create view TWELVE_B as select name as ORIGINAL_NAME, LEFT(name,CHARINDEX(',',name)-1) AS LAST_NAME, RIGHT(name,(LEN(name)-LEN(LEFT(name,CHARINDEX('.',name))))) as FIRST_NAME, AGE, SIBSP, PARCH FROM dbo.passengers WHERE AGE<18 AND PARCH>0
GO
select * from TWELVE_B


GO
create view TWELVE_C as select name as ORIGINAL_NAME, LEFT(name,CHARINDEX(',',name)-1) AS LAST_NAME, RIGHT(name,(LEN(name)-LEN(LEFT(name,CHARINDEX('.',name))))) as FIRST_NAME, AGE, SIBSP, PARCH FROM dbo.passengers WHERE AGE>=18 AND SIBSP = 0
GO
SELECT * FROM TWELVE_C



GO
create view TWELVE_D as select name as ORIGINAL_NAME, LEFT(name,CHARINDEX(',',name)-1) AS LAST_NAME, RIGHT(name,(LEN(name)-LEN(LEFT(name,CHARINDEX('.',name))))) as FIRST_NAME, AGE, SIBSP, PARCH FROM dbo.passengers WHERE AGE>=18 AND SIBSP > 0
GO
SELECT * FROM TWELVE_D

--13
select * from passengers
select name, SUBSTRING(name,charindex('"',name)+1,len(name)-charindex('"',name)-1) as nickname from passengers where charindex('"',name) > 0

/*SELECT ORIGINAL_NAME,regalia,NICKNAME from (SELECT NAME AS ORIGINAL_NAME, LEFT(NAME,CHARINDEX(',',NAME)-1) AS LAST_NAME, 
REPLACE(RIGHT(NAME,(LEN(NAME)-LEN(LEFT(NAME,CHARINDEX('.',NAME))))),SUBSTRING(NAME,CHARINDEX('(',NAME),(CHARINDEX(')',NAME)-CHARINDEX('(',NAME)+1)),'') AS FIRST_NAME,
REPLACE(SUBSTRING(NAME,CHARINDEX('(',NAME),(CHARINDEX(')',NAME)-CHARINDEX('(',NAME))),'(','') AS NICKNAME, SUBSTRING(NAME,CHARINDEX(',',name)+1,CHARINDEX('.',NAME) - CHARINDEX(',',name)) as regalia 
FROM dbo.passengers) AS TMP_TABLE WHERE regalia!=' Mrs.' AND NICKNAME!=' '*/