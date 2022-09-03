--1

select cust_address from Customers where cust_id = 1000000001

go
create function get_adress (@id int)
returns varchar(50)
as begin return (select cust_address from Customers where cust_id = @id) end
go
select dbo.get_adress(1000000001) as adress_number

--2
select prod_price * (100 + 10) / 100 from Products where prod_id = 'BNBG01'

go
create function prod_change_price(@pid varchar(50), @per int, @sign char)
returns float as 
begin
declare @result float
if @sign = '+'
	set @result = (select prod_price * (100 + @per) / 100 from Products where prod_id = @pid) 
if @sign = '-'
	set @result = (select prod_price * (100 - @per) / 100 from Products where prod_id = @pid)
return @result
end
go

drop function dbo.prod_change_price

select dbo.prod_change_price('BNBG01',10, '+')

--3
go
create function getstate(@id char)
returns char
as
begin
declare @out char
if @id in (select vend_id from Vendors)
	set @out = (select vend_state from Vendors where vend_id = @id)
else
	set @out = 'error'
return @out
end
go

drop function dbo.getstate

select dbo.getstate('FNG001')


