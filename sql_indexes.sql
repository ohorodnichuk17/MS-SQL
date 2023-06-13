---------------------------------------
-- INDEXES
---------------------------------------

-- execution plan
use SportShop

select * from Products
GO

-- show plan while query
-- set showplan_all OFF | ON

select Name
from Products
where Price > 200
--where Name = 'Окуляри'
order by Name

----------------------------------------------------
-- clustered & non-clustered
----------------------------------------------------
select Name, Price
from Products
--where Name = 'Ремінь'
order by Name

-- create clustered index on PK
create clustered index i_PK on Products (Id);
-- drop index
drop index i_PK on Users;

-- create simple non-clustered no-unique index
create nonclustered index i_name on Products (Name);

-- disable index
alter index i_name on Products disable;
-- unable index
alter index i_name on Products rebuild;

----------------------------------------------------
-- with included column
----------------------------------------------------
select Name, Price, Quantity from Products 
order by Price;

create index i_name_with_price on Products (Name) include (Price);

create index i_priceB on Products (Price) include (Name, Quantity);

----------------------------------------------------
-- composit
----------------------------------------------------
select Name + ' ' + TypeProduct from Products 
order by Name, TypeProduct;

create index i_name_typeProduct on Products (Name, TypeProduct)

----------------------------------------------------
-- filtered
----------------------------------------------------
select * from Products 
where Quantity  100
order by Quantity;

create index i_quantity_less_100 on Products (Quantity) where Quantity < 100;

----------------------------------------------------
-- unique
----------------------------------------------------
create unique index i_email_unique on Clients (Email)

select * from Clients

insert Clients (FullName, Email, Phone, Gender, PercentSale, Subscribe)
values ('Віктор Романюк', 'ss@c.com', '2341531', 'M', 0, 1);

delete from Clients
where Id = 6