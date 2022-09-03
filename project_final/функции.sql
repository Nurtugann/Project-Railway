--1
go
create function count_seats (@tr_id varchar(50))
returns varchar(50)
as begin
declare @result varchar(50) 
set @result = (select count(*) from seats where status = 'occupied' and coupe_id in (select coupe_id from coupes where carriage_id in (select carriage_id from cariages where train_id = @tr_id)))
return @result
end
go
select dbo.count_seats('TVSHYM15')
--2
go
create function count_seats_in_carr (@cr_id varchar(50))
returns varchar(50)
as begin
declare @result varchar(50) 
set @result = (select count(*) from seats where status = 'occupied' and coupe_id in (select coupe_id from coupes where carriage_id in (select carriage_id from cariages where carriage_id = @cr_id)))
return @result
end
go

select dbo.count_seats_in_carr('CRGAATY101101')

--3
go
create function most_pop_carr (@tr_id varchar(50))
returns varchar(50)
as begin
declare @result varchar(50) 
set @result = (select carriage_id from (select top 1 carriage_id, dbo.count_seats_in_carr(train_id) as cnt from cariages order by cnt) a)
return @result
end
go


select dbo.most_pop_carr('TVSHYM15')

--4
go
CREATE function is_there_train (@first varchar(50), @second varchar(50))
returns varchar(50)--есть ли прямой поезд между станциями
as
begin
	declare @result varchar(50) = (select top 1 t1.train_id from (select train_id from schedules where station_id_start = @first) t1 inner join
	(select train_id from schedules where station_id_end = @second) t2 
	on t1.train_id = t2.train_id)
	return @result
end
go

select * from stations

select dbo.is_there_train('ALA001', 'AST001')

select * from schedules

--5
go
create function dlina (@first varchar(50), @second varchar(50)) --раст меж станциями
returns int
as
begin
declare @result int = (select sum(distance_between_stations) from schedules where train_id = dbo.is_there_train(@first, @second))
return @result
end
go

select dbo.dlina('ALA001', 'AST001')

--6 --длина дороги поезда
go
create function dlina_tr (@tr varchar(50))
returns varchar(50)
as
begin
declare @result varchar(50) = (select sum(distance_between_stations) from schedules where train_id = @tr)
return @result
end
go


select dbo.dlina_tr('TVSHYM15')






