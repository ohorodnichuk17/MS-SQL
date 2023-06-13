CREATE DATABASE SportShop
COLLATE Cyrillic_General_100_CI_AS;
GO

USE SportShop;
GO

--drop DATABASE SportShop;

-- Товари: назва товару, вид товару (одяг, взуття, і т.д.), кількість товару в наявності, собівартість, виробник, ціна продажу
create table Products
(
	Id int identity(1,1) NOT NULL primary key,
	Name nvarchar(100) NOT NULL,
	TypeProduct nvarchar(20) NOT NULL,
	Quantity int NOT NULL,
	CostPrice int NOT NULL,
	Producer nvarchar(50),
	Price int NOT NULL
);
GO

INSERT INTO Products(Name, TypeProduct, Quantity, CostPrice, Producer, Price)
VALUES ('Рукавиці', 'Аксесуари', 5, 85, 'Туреччина', 150),
		('Окуляри', 'Аксесуари', 5, 85, 'Китай', 150),
		('Ремінь', 'Одяг', 15, 120, 'Туреччина', 250),
		('Рюкзак', 'Аксесуари', 10, 450, 'Польща', 700),
		('Кросівки Адідас', 'Взуття', 20, 800, 'Польща', 1500)
GO

-- Працівники: повне ім'я, дата прийняття на роботу, стать, ЗП
CREATE TABLE Employees
(
	Id INT Identity(1, 1) NOT NULL PRIMARY KEY,
	FullName NVarchar(100) NOT NULL, Check(LEN(FullName) > 0),
	HireDate Date NOT NULL,
	Gender NVarchar(1)NOT NULL,
	Salary Money NOT NULL, Check(Salary > 0)
);
Go

INSERT INTO Employees(FullName, HireDate, Gender, Salary)
VALUES ('Ярощук Іван Петрович', '2020-05-30', 'M', 8500),
('Михальчук Руслана Романівна', '2020-05-06', 'F', 8500),
('Левчук Тетяна Степанівна', '2020-05-07', 'F', 8500),
('Волос Ігор Іванович', '2020-05-15', 'M', 8500);
GO

-- Клієнти: повне ім'я, пошта, телефон, стать, знижка, підписка
CREATE TABLE Clients
(
	Id INT Identity(1, 1) NOT NULL PRIMARY KEY,
	FullName NVarchar(100) NOT NULL,
	Email NVarchar(100) NOT NULL,
	Phone NVarchar(15) NOT NULL,
	Gender NVarchar(1)NOT NULL,
	PercentSale INT NOT NULL CHECK(PercentSale >=0 AND PercentSale <=100) Default 0,
	Subscribe BIT Default 1
);
GO

INSERT INTO Clients(FullName, Email, Phone, Gender, PercentSale, Subscribe)
VALUES ('Петрук Степан Романович', 'ss@c.com', '0971234567', 'M', 10, 0),
('Романчук Людмила Степанівна', 'rls@rr.org', '0989876543', 'F', 15, 1)
GO

-- Продажі: ціна продажі, кількість одениць товару, товар, клієнт (який виконав покупку), працівник (який виконав продажу)
CREATE TABLE Salles
(
	Id INT Identity(1, 1) NOT NULL PRIMARY KEY,
	ProductId INT References Products(Id) NOT NULL,
	Price Money NOT NULL,
	Quantity INT NOT NULL,
	EmployeeId INT References Employees(Id) NOT NULL,
	ClientId INT References Clients(Id) NOT NULL,
);
GO

INSERT INTO Salles(ProductId, Price, Quantity, EmployeeId, ClientId)
VALUES  (1, 10000, 1, 1, 1),
		(1, 100, 1, 1, 1),
		(4, 1800, 1, 2, 2),
		(2, 10000, 3, 4, 2)
GO

-- вивід значень з таблиць
SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Clients;
SELECT * FROM Salles;

-----------
-- Triggers

select ClientId, SUM(Price * Quantity)
from Salles
group by ClientId
having SUM(Price * Quantity) > 50000

select Id, FullName, PercentSale
from Clients

select * from Salles
GO

-- Task 5: При новій покупці товару потрібно перевіряти загальну суму покупок клієнта.
-- Якщо сума перевищила 50000 грн, необхідно встановити відсоток знижки в 15%
create or alter trigger tg_set_sale_to_client
on Salles
after insert
as
	declare @client_id int, @sale_id int;
	
	select @client_id = ClientId, @sale_id = Id
	from inserted
		if (select SUM(Price * Quantity)
			from Salles
			where ClientId = @client_id) > 75000
		begin
			update Clients
			set PercentSale = 20
			where Id = @client_id

			update Salles
			set Price *= 0.8
			where Id = @sale_id
		end;
GO


--drop trigger tg_set_sale_to_client2
create or alter trigger tg_add_sale_to_client2
on Salles
after insert
as
	declare @client_id int, @salle_id int;

	-- проходимося по всіх нових продажах
	-- зберігаючи id клієнта та id продажі
	select @client_id = ClientId, @salle_id = Id
	from inserted
		-- перевіряємо чи загальна сума продаж даного клієнта > 50000
		if (select SUM(Price * Quantity)
			from Salles
			where ClientId = @client_id) > 50000
		begin
			-- встановити даному клієнту знижку 15%
			update Clients
			set PercentSale = 15
			where Id = @client_id

			-- зменшуємо ціну даної продажі на 15%
			update Salles
			set Price *= 0.85
			where Id = @salle_id
		end;

-- testing
select SUM(Price * Quantity)
from Salles
where ClientId = 1

insert Salles
values (2, 10000, 1, 2, 1)

SELECT * FROM Salles;
GO

-- deny insert existing products
create or alter trigger tg_deny_insert_exists_prod
on Products
after insert
as
	declare @name nvarchar(100);
	declare @id int

	select @name = Name, @id = ID
	from inserted
		if exists (select Id
				   from Products
				   where Name = @name AND ID <> @id)
		begin
			raiserror('Can not insert existign product!', 4, 1);
			rollback;
		end;
GO

INSERT INTO Products(Name, TypeProduct, Quantity, CostPrice, Producer, Price)
VALUES ('Пальто', 'Одяг', 5, 85, 'Туреччина', 2300)
GO

-- set sale to client
create or alter trigger tg_set_sale
on Salles
after insert
as
begin
	declare @Sale_Id INT
	declare @Client_Id INT

	select @Sale_Id = Id, @Client_Id = ClientId
	from inserted as i
	if 20000 < (select SUM(s.Price)
		from Salles as s
		where s.ClientId = @Client_Id)
	begin
		update Salles
		set Price = Price - (Price / 100 * 15)
		where Id = @Sale_Id
	end
end;