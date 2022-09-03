SELECT * FROM stations
SELECT * FROM trains
SELECT * FROM cariages
SELECT * FROM coupes
SELECT * FROM schedules
SELECT * FROM seats
SELECT* FROM cost_by_calss
SELECT * FROM sale_by_number_of_trips
SELECT * FROM sale_by_status
SELECT * FROM customers
SELECT * FROM passengers where isnull(pass_status,0) = '0'
SELECT * FROM discount_cards
SELECT * FROM tickets
SELECT * FROM schedules

select isnull(seat_id,1) from tickets

GO






--2
go
CREATE procedure is_there_train @first varchar(50), @second varchar(50) --есть ли прямой поезд между станциями
as
	select t1.train_id from (select train_id from schedules where station_id_start = @first) t1 inner join
	(select train_id from schedules where station_id_end = @second) t2 
	on t1.train_id = t2.train_id
go


exec is_there_train @first='ALA001', @second='ATA001'

--drop procedure is_there_train



go
create procedure get_marshrut @sctd_train varchar(50) --находит все станции и расписание поезда 
as 
	select station_id_start,time_in,time_out,date_in,date_out from schedules where train_id = @sctd_train order by date_in, time_in
go

exec get_marshrut @sctd_train = 'TSATA12'

drop procedure get_marshrut

go
CREATE FUNCTION number_of_stations (@sctd_train varchar(50), @start varchar(50), @end varchar(50)) --показывает количество  станции между станциями
returns int as 
begin
	if @sctd_train in (select t1.train_id from (select train_id from schedules where station_id_start = @start) t1 inner join
	(select train_id from schedules where station_id_end = @end) t2 
	on t1.train_id = t2.train_id) 
		return (select rownumb from (select station_id_start, ROW_NUMBER() over (order by time_in) as rownumb  from schedules where train_id = @sctd_train) a where station_id_start = @end) - (select rownumb from (select station_id_start, ROW_NUMBER() over (order by time_in) as rownumb  from schedules where train_id = @sctd_train) a where station_id_start = @start)
	return 0
end
go

drop function number_of_stations


select dbo.number_of_stations ('TEALA11','ALA001','ALA001')
select dbo.number_of_stations ('TEALA15','ALA001','ATY001')

go
create function calculating_cost (@numb int)
returns int as
begin
	return @numb * 1000
end


go
create trigger upd_init_cost on tickets
after insert
as
	declare @sct_train varchar(50) = (select train_id from inserted)
	declare @numb int = (select dbo.number_of_stations(station_id_start, station_id_end, @sct_train) from inserted)
	update tickets
	set initial_cost_of_ticket = dbo.calculating_cost(@numb)




--1
go
CREATE PROCEDURE is_there_seat @selected_train AS VARCHAR
AS
DECLARE @train_target AS VARCHAR
SET @train_target=@selected_train
DECLARE @is_free AS INT
SET @is_free=(SELECT COUNT(*) FROM trains FULL JOIN cariages ON trains.train_id=cariages.train_id FULL JOIN coupes ON cariages.carriage_id=coupes.carriage_id FULL JOIN seats ON seats.coupe_id=coupes.coupe_id WHERE trains.train_id=@train_target AND seat_id='free')
IF @is_free>0
	ENABLE TRIGGER to_ocupie ON seats
ELSE
	PRINT 'No free seats.'

GO
create trigger to_ocupie on tickets --booking the seat
after insert
as update seats set status = 'occupied' where seat_id = (select seat_id from inserted)

-- нужно ли создавать функцию покупки билета, или это можно в на пайтен через иф проверять


--3
go
create procedure show_cost @id as varchar(50)
as
select final_cost_of_ticket from tickets where passenger_id = @id

--drop procedure show_cost

exec show_cost @id = 'P1001667556'

--проблема с костом тикета



--4
go
CREATE TRIGGER get_status ON passengers AFTER INSERT AS
DECLARE @age AS INT
SET @age=(SELECT age FROM inserted)
IF @age>60
	UPDATE passengers SET pass_status='pensioner' WHERE passenger_id=(SELECT passenger_id FROM inserted)
ELSE IF @age BETWEEN 18 AND 23
	UPDATE passengers SET pass_status='student' WHERE passenger_id=(SELECT passenger_id FROM inserted)
ELSE IF @age BETWEEN 0 AND 12
	UPDATE passengers SET pass_status='child' WHERE passenger_id=(SELECT passenger_id FROM inserted)
ELSE
	UPDATE passengers SET pass_status=NULL WHERE passenger_id=(SELECT passenger_id FROM inserted)




SELECT station_id_start FROM (SELECT ROW_NUMBER() OVER(ORDER BY train_id) row_num,* FROM schedules) AS TMP_TABLE WHERE train_id='TNAQT13' AND row_num=1

--5
go
CREATE PROCEDURE strictly_women @customer_id_target VARCHAR,@seat_id VARCHAR
AS 
DECLARE @cnt AS INT
SET @cnt=(SELECT COUNT(tickets.passenger_id) FROM tickets INNER JOIN passengers ON tickets.passenger_id=passengers.passenger_id WHERE tickets.customer_id=@customer_id_target)
DECLARE @startp AS INT
SET @startp=0
WHILE @startp<=@cnt
DECLARE @gender AS VARCHAR
SET @gender=(SELECT gender FROM tickets INNER JOIN passengers ON tickets.passenger_id=passengers.passenger_id WHERE tickets.customer_id=@customer_id_target)
DECLARE @passenger_id AS VARCHAR
SET @passenger_id=(SELECT tickets.passenger_id FROM tickets INNER JOIN passengers ON tickets.passenger_id=passengers.passenger_id WHERE tickets.customer_id=@customer_id_target)
IF @gender!='female'
	PRINT 'You are not allowed to be there'
ELSE
	UPDATE seats SET status='occupied' WHERE seat_id=@seat_id
	INSERT INTO tickets(seat_id,initial_cost_of_ticket,final_cost_of_ticket) VALUES (@seat_id,(SELECT cost_of_ticket_per_station FROM cost_by_calss))


-- проверка не женский ли вагон
go
create procedure for_woman @psng_id varchar(50)
as
if (select woman_carriage from tickets where passenger_id = @psng_id) = 1 and (select gender from passengers where passenger_id = @psng_id) = 'male'
	select 'not allowed, you should choose another carriage'
else
	select 'accepted'

-- процедура проверки всех сидени
go
create procedure all_free_seats @sclt_train varchar(50)
as
select * from seats where status = 'free' and coupe_id in (select coupe_id from coupes where carriage_id in (select carriage_id from cariages where train_id = @sclt_train)) order by seat_id

exec all_free_seats @sclt_train = 'TAATY11'


--6 отмена билета
-- освобождаем место
go
create trigger cancel on tickets
after delete
as
begin
update seats
set status = 'free' where seat_id = (select seat_id from deleted)
end

go
create procedure deleting_ticket @psng_id varchar(50) as
delete from tickets where passenger_id = @psng_id

--7 
-- проверка фулл или не фулл

go
create trigger is_full_coupe on seats
after update
as
begin
if (select count(*) from seats where status = 'occupied' and coupe_id=(select coupe_id from inserted)) = 4
	update coupes set is_full_coupe = 'full'
end


go
create trigger is_full_carriage on coupes
after update
as
begin
if (select count(*) from coupes where is_full_coupe = 'full' and carriage_id=(select carriage_id from inserted)) = 5
	update cariages set is_full_carriage = 'full' where carriage_id = (select carriage_id from inserted)
end



go
create trigger is_full_train on cariages
after update
as
begin
if (select count(*) from cariages where is_full_carriage = 'full' and train_id=(select train_id from inserted)) = 10
	update trains set is_full_train = 'full' where train_id = (select train_id from inserted)
end

drop trigger is_full_train
drop trigger is_full_carriage
drop trigger is_full_coupe



--8
go
create trigger deleting_wrong_tickets on tickets
after insert
as
declare @ps_id varchar(50) = (select passenger_id from inserted)
--if (select gender from passengers where passenger_id = (select passenger_id from inserted)) = 'male' and (select woman_carriage from inserted) = 1
	--exec deleting_ticket @psng_id = @ps_id
if (select isnull(seat_id,0) from inserted) = '0'
	exec deleting_ticket @psng_id = @ps_id

drop trigger deleting_wrong_tickets
