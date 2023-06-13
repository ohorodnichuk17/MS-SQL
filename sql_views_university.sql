use University2021_NEW2;;
GO

select *
from Students

select Email
from Students

select Name, Email, AverageMark
from Students
where AverageMark >= 7;

-- VIEW (представлення) - - це об'єкт БД, який має зовнішній
-- вид таблиці, але на відміну від неї не має своїх власних даних.
-- Представлення лише надає доступ до даних однієї або декількох таблиць, на яких воно базується

select top 2 * 
from good_students
order by AverageMark desc


select Name as 'First Name'
from good_students
order by AverageMark desc


select top 5 * 
from good_students
order by AverageMark desc

select Name as 'First name', AverageMark as Mark
from good_students
order by AverageMark desc

------------ CREATE VIEW
create view GoodStudents
as
select Name, Email, AverageMark as Mark
from Students
where AverageMark >= 7;

select * from GoodStudents

------------- ALTER VIEW
alter view GoodStudents(FirstName, LastName, Email, Mark)
as
	select Name, Surname, Email, AverageMark
	from Students
	where AverageMark >= 7;

select * from GoodStudents
select * from Students

select FirstName, Mark from GoodStudents
where FirstName like '[A-G]%';

-- для view можна вказати деякі параметри:
--		encryption		- view буде зберігатися в зашифрованому вигляді
--		schemabinding	- забороняє видалення таблиць, представлень та функцій які використовує дане view
--		view_metadata	- вказує на те, що view в режимі перегляду буде повертати його метадані,
--						  тобто інформацію про його структуру, а не записи таблиць

create or alter view GoodStudentsWithParams (FullName, EmailAddress, Mark) -- create or alter - створи або зміни view
with encryption
as
	select Name + ' ' + Surname, Email, AverageMark
	from Students
	where AverageMark >= 9
	--order by AverageMark -- забороняється використовувати всередині view

select * from GoodStudentsWithParams
order by Mark -- дозволяється використовувати при роботі з view

-- ORDER BY дозволяється всередині view лише разом з оператором TOP 
create view Top3GoodStudents (Name, Email, Mark)
as
	select top 3 Name, Email, AverageMark
	from Students
	where AverageMark >= 9
	order by AverageMark DESC

select * from Top3GoodStudents
order by Name

-------------- DROP VIEW
drop view Top3GoodStudents; -- видалення представлення

-- дозволяється використовувати багатотабличні запити
create view StudentFullInfo (StudentName, Email, Mark, GroupName)
as
	select s.Name, s.Email, s.AverageMark, g.Name
	from Students as s JOIN Groups as g ON g.Id = s.GroupId

select * from StudentFullInfo

------------------------------------------------------
-- До представлення можна застосовувати DML команди: INSERT, UPDATE, DELETE

/* За виключенням тих представлень, які містять багатотабличі запити
	або коли присутні дані оператори: 
	AVG, COUNT, SUM, MIN, MAX, GROUPING, STDEV, STDEVP, VAR, VARP;
	substring, UNION, UNION ALL, CROSSJOIN, EXCEPT, INTERSECT;
	GROUP BY, HAVING и DISTINCT, TOP;
*/

select * from Students

insert into GoodStudents
values ('Olga', 'HGJHFh', 'olga@gmail.com', 11);

select * from GoodStudents

----------------- UPDATEABLE VIEW (оновлююче представлення)
create or alter view GoodStudentsWithCheck
as
	select Name, Surname, Email, AverageMark
	from Students
	where AverageMark >= 7
	with check option; -- забороняє модифікувати записи (INSERT, UPDATE, DELETE) для записів, які не підлягають результату VIEW 

insert into GoodStudentsWithCheck
values ('Galya', 'Amirova', 'kriakria@gmail.com', 4);

select * from Students

delete from GoodStudentsWithCheck
where Name = 'Maks'