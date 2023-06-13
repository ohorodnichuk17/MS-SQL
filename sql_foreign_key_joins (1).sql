create database University2021_NEW2;
go

use University2021_NEW2;

create database MyUniversityDb;

use MyUniversityDb;
go

/* Типи зв'язків:
	- One to One (Один до Одного)
	- One to Many (Один до Багатьох)
	- Many to Many (Багато до Багатьох)
*/

---------------- Groups -----------------
create table Groups
(
	Id int primary key identity(1,1),
	Name nvarchar(50) NOT NULL check(Name <> '')
)
go

insert Groups
values	('Dublin'),
		('Delaware'),
		('New-York'),
		('Masachusets')
GO

select * from Groups

---------------- Students -----------------
create table Students
(
	-- FOREIGN KEY (column) REFERENCES table(column) - встановлює зовнішній ключ для зв'язку з таблицею

	Id int primary key identity(1,1),
	Name nvarchar(50) NOT NULL check(Name <> ''),
	Surname nvarchar(50) NOT NULL check(Surname <> ''),
	Email nvarchar(50) NULL ,
	AverageMark float check(AverageMark BETWEEN 1 AND 12),
	Birthdate date NULL check(Birthdate <= GETDATE()),
	Lessons int NOT NULL default(0),
	Fails int NOT NULL default(0),
	-- вказуємо зв'язко з групою в студента, студент має одну групу - група багато студентів
	GroupId int null FOREIGN KEY references  Groups(Id), -- в даному випадку FOREIGN KEY вказувати не обов'язково


	check(Fails <= Lessons),
	--FOREIGN KEY (GroupId) REFERENCES Groups(Id)
)
go

-- при встановленні зв'язку на запис таблиці він повинен існувати, інакше не дозволить
insert into Students (Name, Surname, Email, Birthdate, AverageMark, Lessons, Fails, GroupId)
values  ('Oleg', 'Strapp', 'bbbbbbbbb@princeton.edu', '2003-04-10', NULL, 18, 5, 3),
		('Igor', 'Targetter', 'afarg@tuttocitta.it', '2004-12-10', 9.9, 80, 15, NULL),
		('Igor', 'Orred', 'mogged2@senate.gov', '2002-11-08', NULL, default, default, NULL),
		('Valya', 'Hopewell', 'bfieraga@themeforest.net', '2003-04-15', 2.8, 28, 6, NULL),
		('Kania', 'Launchbury', 'klaunchbury4@dagondesign.com', '2001-08-03', 4.9, 71, 31, 1),
		('Jameson', 'Yair', 'jyair5@blog.com', '2003-11-18', 3.5, 55, 19, 2),
		('Griswold', 'Grimshaw', 'ggrimshaw6@1und1.de', '2002-12-25', 9.9, 33, 13, 2),
		('Sayers', 'Chesterfield', 'tytu@theglobeandmail.com', '2004-03-3', 6.7, default, default, 3),
		('Nat', 'Huniwall', 'nhuniwall8@illinois.edu', '2003-04-10', 5.7, 90, 49, 1),
		('Glenna', 'McCurtin', 'gmccurtin9@fastcompany.com', '2003-04-10', 11.4, 81, 29, 1);
GO


select * from Students

---------------- Teachers -----------------
create table Teachers
(
	Id int primary key identity,
	Name nvarchar(50),
	HireDate date,
	Phone nvarchar(20)
)
GO

insert into Teachers (Name, HireDate, Phone)
values	('Viktor', '2007-10-5', '22-33-22'),
		('Petya', '2001-1-6', '22-78-00'),
		('Vasya', '2009-3-2', '98-93-23');
GO


-- проміжна таблиця для реалізації зв'язку Many to Many
create table TeachersGroups 
(
	TeacherId int references Teachers(Id),
	GroupId int references Groups(Id),
	-- так як комбінації зовнішнії ключів не можуть повторюватися,
	-- на їх основі можна зробити складений первинний ключ
	primary key (TeacherId, GroupId)
);
GO

select * from Teachers;
select * from Groups;

-- встановлюємо зв'язки між Teachers та Groups
insert into TeachersGroups
values (1, 1), 
	   (1, 2),
	   (2, 3),
	   (3, 3)
GO
select * from TeachersGroups

select s.Name, GroupId, g.Name
from Students as s left join Groups as g on s.GroupId = g.Id
where s.GroupId is null and s.AverageMark >= 3

select s.Name, GroupId, g.Name
from Students as s left JOIN Groups as g ON s.GroupId = g.Id
where s.GroupId is NULL and s.AverageMark >= 3

-- Multi-table queries (Багатотабличні запити)

-- використовючи фільтрацію WHERE 

-- отримуємо певних студентів разом з інформацією про його групу
select s.Name, s.AverageMark, s.GroupId, g.Id, g.Name
from Groups as g, Students as s
where s.GroupId = g.Id -- join students with groups
		AND s.AverageMark >= 7

-- отримуємо ТОП-3 студентів певної групи з найкращою успішністю
select TOP 3 s.Name, s.Email, s.AverageMark, g.Name
from Groups as g, Students as s
where s.GroupId = g.Id -- join students with groups
		AND g.Name = 'Dublin'
order by s.AverageMark DESC


-- отримуємо всіх викладачів та групи в яких вони викладають
select t.Name, t.Phone, g.Name
from Teachers as t, TeachersGroups as tg, Groups as g
where tg.TeacherId = t.Id AND tg.GroupId = g.Id
	AND t.Name = 'Viktor'

-- ті ж самі запити, але використовуючи JOIN

-- JOIN оператор використовуєтся саме для зв'язування записів по зовнішньому ключу
-- FROM table_A JOIN table_B ON table_A.foreignKey = tableB.primaryKey

-- отримуємо певних студентів разом з інформацією про його групу
select s.Name, s.AverageMark, g.Name
from Students as s JOIN Groups as g ON s.GroupId = g.Id  -- join students with groups
where s.AverageMark >= 7

-- отримуємо ТОП-3 студентів певної групи з найкращою успішністю
select top 3 s.Name, s.Email, s.AverageMark, g.Name
from Groups as g JOIN Students as s ON g.Id = s.GroupId
where g.Name = 'Dublin'
order by s.AverageMark DESC

-- отримуємо всіх викладачів та групи в яких вони викладають
select t.Name, t.Phone, g.Name
from Teachers as t JOIN TeachersGroups as tg ON tg.TeacherId = t.Id 
				   JOIN Groups as g ON tg.GroupId = g.Id

-- отримуємо всіх викладачів певного студента
select s.Name, s.Surname, s.Email, g.Name as 'Group', t.Name as 'Teacher'
from Students as s JOIN Groups as g ON s.GroupId = g.Id
				   JOIN TeachersGroups as tg ON tg.GroupId = g.Id
				   JOIN Teachers as t ON t.Id = tg.TeacherId
where s.Email = 'nhuniwall8@illinois.edu'

-- ішні варіації оператора JOIN

-- отримуємо всіх студентів, які мають зв'язок з групою або не мають групу
select s.Name, g.Name
from Students as s LEFT JOIN Groups as g ON s.GroupId = g.Id

-- отримуємо студентів, які мають НЕ мають групи
select s.Name, s.AverageMark, s.GroupId, g.Id, g.Name
from Students as s LEFT JOIN Groups as g ON s.GroupId = g.Id
where s.GroupId IS NULL