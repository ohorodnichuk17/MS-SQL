/* User-Defined Functions
	Returned value:
		scalar-valued function	- повертає скалярне значення (1, 4.7, 'Hello')
		table-valued function	- результатом такої функції є таблиця
			inline table-valued function		 - повертає таблицю за допомогою одного SELECT запиту
			multistatement table-valued function - повертає таблицю, яка містить нові імена та типи колонок
	Indexing:
		determinate		- завжди повертає однакове значення при однакових параметрах. Таку функцію можна проіндексувати
		non-determinate	- може повертати різні значення при однакових параметрах. Така функція не піддається індексуванню
*/
execute ShowHelloWorld

USE MyUniversityDb;
GO

CREATE FUNCTION GetCurrentYear()
RETURNS INT 
AS
BEGIN
	--alghorithm
	DECLARE @year INT = YEAR(GETDATE());
	RETURN @year;
END
GO

PRINT dbo.GetCurrentYear();
SELECT dbo.GetCurrentYear() AS 'Year';
GO

create function GetCurrentMonth()
returns int
as
begin
	declare @month int = MONTH(GETDATE());
	return @month
end
GO

print dbo.GetCurrentMonth();

select dbo.GetCurrentMonth() as 'Month';
GO


---------- Scalar Functions
-- функція завжди повинна повертати якесь значення

-- function that return current month
create function GetCurrentMonth ()
returns int
as
begin
	declare @date date = GETDATE();
	return MONTH(@date);
end;
GO
-- invoke
select dbo.GetCurrentMonth() as 'Current month'
print dbo.GetCurrentMonth()

select *
from Students
where MONTH(BirthDate) = dbo.GetCurrentMonth()
GO

-- returns pow of number
create or alter function Pow (@number bigint, @step int)
returns bigint
as
begin
	declare @i int = 0;
	declare @result bigint = 1;

	while (@i < @step)
	begin
		set @result *= @number;
		set @i += 1;
	end;

	return @result;
end;
GO

-- invoke
print 'Result: ' + cast(dbo.Pow(2, 10) as varchar);
GO

-- summa of two numbers
create or alter function GetSumma(@n1 int, @n2 int = 0)
returns int
as
begin
	declare @res int = @n1 + @n2
	return @res; 
end;
GO

select [dbo].GetSumma(3, default) as 'Result'

use SportShop;
select * from Products
select * from Salles
GO

-- get total price of salles by product id
create function GetTotalSalles(@prod_id int)
returns money
as
begin
return (select SUM(Price)
		from Salles
		where ProductId = @prod_id);
end;
GO
-- invoke
select [dbo].GetTotalSalles(2) as 'Total Salles'
GO

-- get count of salles by client name
create or alter function GetSallesCount(@client_email nvarchar(50))
returns int
as 
begin
return
	(select COUNT(s.Id)
	from Salles as s JOIN Clients as c ON s.ClientId = c.Id
	where c.Email = @client_email)
end;
GO

-- invoke
select [dbo].GetSallesCount('rls@rr.org') as 'Count of salles'
GO

-- convert time to total seconds
create function GetTotalSeconds (@duration time)
returns int
as 
begin
return
	(DATENAME(second, @duration) + 
	 DATENAME(minute, @duration) * 60 + 
	 DATENAME(hour, @duration) * 3600)
end;
GO

-- invoke
print dbo.GetTotalSeconds('01:01:20');

---------------- Inline Table Valued Functions
use MyUniversityDb;
GO

-- get students by group name
create function GetStudetns (@group_name nvarchar(50))
returns table
--WITH ENCRYPTION
as
return (
	select s.Id, s.Name, s.Surname, s.Email, s.AverageMark
	from Students as s JOIN Groups as g ON s.GroupId = g.Id
	where g.Name = @group_name
);
GO

-- invoke
select * 
from GetStudetns('New-York')
where Name LIKE '[A-D]%'
GO

use SportShop;
GO

-- return products in price range
create or alter function GetProducts (@min int, @max int)
returns table
as
return 
(
	select * 
	from Products
	where Price between @min and @max
);
GO

-- invoke
select * from GetProducts(200, 1000);

-- delete function
drop function GetProducts;

----------------- Multi-Statement Table-Valued Functions
-- table variable

declare @var bit = 0;

declare @cities table
(
	Id int PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

insert into @cities (Name)
values  ('Rivne'),
		('Lviv'),
		('Kharkiv')

select * from @cities

use MyUniversityDb;
GO

-- return students or teachers
create function GetStudentsOrTeachers(@is_teach bit)
returns @elements table 
(
	Id int,
	Name nvarchar(50) NOT NULL
)
as
begin
	if (@is_teach = 1)
		insert into @elements 
			select Id, Name from Teachers
	else
		insert into @elements
			select Id, Name from Students

	return; -- повертає результуючу таблицю
end;
GO

-- invoke
select * from GetStudentsOrTeachers(0)
GO

-- return even numbers from '@from' to '@to'
create or alter function GetEvenNumbers (@from int, @to int)
returns @result table (number int)
as 
begin
	declare @i int = @from
	while (@i <= @to)
	begin
		if (@i % 2 = 0)
			insert into @result
			values (@i);

		set @i += 1;
	end;

	return;
end;
GO

-- invoke
select * from GetEvenNumbers(1, 20)

declare @table table 
(
	Id int NOT NULL PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL
)

insert into @table (Name)
values ('Name1'),
	   ('Name2'),
	   ('Name3'),
	   ('Name4'),
	   ('Name2'),
	   ('Name3'),
	   ('Name3')

select * from @table

-- return all dublicated values
select distinct t1.Name
from @table as t1, @table as t2
where t1.Name = t2.Name AND t1.Id <> t2.Id