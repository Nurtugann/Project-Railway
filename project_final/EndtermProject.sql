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
SELECT * FROM passengers
SELECT * FROM discount_cards
SELECT * FROM tickets
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
create function number_of_stations (@sctd_train varchar(50), @start varchar(50), @end varchar(50)) --показывает количество  станции между станциями
returns int as 
begin
	if @sctd_train in (select t1.train_id from (select train_id from schedules where station_id_start = @start) t1 inner join
	(select train_id from schedules where station_id_end = @end) t2 
	on t1.train_id = t2.train_id) 
		return (select rownumb from (select station_id_start, ROW_NUMBER() over (order by time_in) as rownumb  from schedules where train_id = @sctd_train) a where station_id_start = @end) - (select rownumb from (select station_id_start, ROW_NUMBER() over (order by time_in) as rownumb  from schedules where train_id = @sctd_train) a where station_id_start = @start)
	return 0
end

drop function number_of_stations


select number_of_stations ('TSATA12','ATA001','AQT001')

go
create function calculating_cost (@numb int)
returns int as
begin
	return @numb * 1000
end




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

GO
create trigger sale_on_person on passengers
AFTER INSERT
AS 
DECLARE @discount AS FLOAT
DECLARE @status AS VARCHAR
SET @status = (select status from inserted)
SET @discount=(SELECT sale FROM sale_by_status WHERE status=@status)
update tickets SET final_cost_of_ticket = initial_cost_of_ticket * (100 - @discount) / 100
GO

--4

/*create procedure is_valid(@card_id)
as
if (select getdate() - start_date from dicount_card where card_id = @card_id) > 2years 
print 'valid'
else 
print 'not valid'

create trigger get_sale_by_trips on discount_cards --скидка по кол-во поездок
after insert
as update update tickets set final_cost_of_ticket = initial_cost_of_ticket * (100 - salee) / 100 where salee = (select salee from number_of_trips where trips = (select trips from inserted)*/

--4
DECLARE @target_cust AS VARCHAR
SET @target_cust=NULL
GO
CREATE TRIGGER discount_card ON discount_cards AFTER INSERT AS
BEGIN
UPDATE tickets SET final_cost_of_ticket=initial_cost_of_ticket*(SELECT sale FROM sale_by_number_of_trips INNER JOIN discount_cards ON discount_cards.number_of_trips=sale_by_number_of_trips.number_if_trips WHERE number_if_trips=number_of_trips)
END
GO
CREATE PROCEDURE has_discount_card @customer_id_target VARCHAR
AS
DECLARE @have_or_not AS INT
SET @have_or_not=(SELECT COUNT(discount_cards.customer_id) FROM discount_cards INNER JOIN customers ON customers.customer_id=discount_cards.customer_id WHERE discount_cards.customer_id=@customer_id_target)
IF @have_or_not=1
	ENABLE TRIGGER discount_card ON discount_cards
ELSE
	PRINT 'Do you want to get a discount card?'
GO

--5

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

