--1
create procedure vendor_product as
begin
select v.vend_id, v.vend_name, v.vend_country, p.prod_name from Vendors v full join (select vend_id, STRING_AGG(TRIM(prod_name),',') as prod_name from Products group by vend_id) p on v.vend_id = p.vend_id
end
exec vendor_product
drop procedure vendor_product

--2
go
create procedure email_update as
begin
update Customers set cust_email=CONCAT('kztoys','@',LOWER(REPLACE(cust_name,' ','')),'.com') where cust_email IS NULL
end
exec email_update
drop procedure email_update

--3
go
create procedure description_insert as
begin
	declare @status varchar(50)
	select c.cust_id,c.cust_name,c.cust_address, c.cust_email, o.counts, (case when o.counts > 1 then 'regular customer' else 'seldom customer' end) as 'description' from Customers c, (select count(*) as 'counts', cust_id from Orders group by cust_id) o  where c.cust_id=o.cust_id
end

exec description_insert
drop procedure description_insert

--4
go
create procedure vendor_description_insert as
begin
	select v.vend_id, v.vend_name, v.vend_country, (case when len(vend_country)%2=0 then 'even' else 'odd' end) as vend_description from Vendors v
end
exec vendor_description_insert
drop procedure vendor_description_insert

--5
go
create procedure full_cost @prod_id varchar(50), @order_num int as
begin
declare @output varchar(50)
set @output = concat('Full cost is ',(SELECT CONVERT(varchar,item_price*quantity) from OrderItems where prod_id=@prod_id AND order_num=@order_num))
print @output
end
exec full_cost @prod_id='BR01', @order_num=20006;
drop procedure full_cost

--6
go
create procedure messagee as
begin
declare @output varchar(50)
set @output = (case when (select count(*) from Vendors where vend_city is null) > 0 then 'There are some vendors with unknown locations' else 'Information about location is filled' end)
print @output
end
exec messagee
drop procedure messagee

--7
go
create procedure about_city as
begin
/*create view tmp as
select c.cust_name, c.cust_state, v.vend_state from 
Customers c, Orders o, OrderItems oi, Products p, Vendors v 
where c.cust_id = o.cust_id and o.order_num = oi.order_num and oi.prod_id = p.prod_id and p.vend_id = v.vend_id*/
select distinct(c.cust_name), (case when c.cust_state = v.vend_state then 'YES' else 'NO' end) as vend from Customers c, Vendors v
end
exec about_city
drop procedure about_city


--8
go
create procedure avg_price as
begin
declare @avg1 int
set @avg1 = (select avg(prod_price) from Products)
declare @max int
set @max = (select max(prod_price) from Products)
declare @avg2 int
set @avg2 = (select avg(prod_price) from Products where prod_price between @avg1 and @max)
select * from Products where prod_price between @avg1 and @avg2
end
exec avg_price
drop procedure avg_price

--9
go
create procedure customers_data as
begin
declare @max int
declare @s_max int
set @max = (select max(MON) from (select sum(oi.item_price*oi.quantity) as MON from Customers c, Orders o, OrderItems oi where c.cust_id=o.cust_id and o.order_num=oi.order_num group by c.cust_id) a)
set @s_max = (select max(MON) from (select sum(oi.item_price*oi.quantity) as MON from Customers c, Orders o, OrderItems oi where c.cust_id=o.cust_id and o.order_num=oi.order_num group by c.cust_id) a where MON != @max)
select c.cust_id, count(*) as num_items, sum(oi.item_price*oi.quantity) as MON, case when MON = @max then 'maximum' when MON = @s_max then 'second_max' else 'usual' end as status from Customers c, Orders o, OrderItems oi where c.cust_id=o.cust_id and o.order_num=oi.order_num group by c.cust_id
end
exec customers_data

--10
-- here i am finding all products and prderitems of defined vendor
go
create procedure vendors_products as
begin
select * from
OrderItems oi, Products p, Vendors v
where oi.prod_id = p.prod_id and p.vend_id = v.vend_id and v.vend_id = 'DLL01'
end
exec vendors_products
