use MyUniversityDb;
go

select * from Students;
go

CREATE TRIGGER tg_test_hello
ON Groups
AFTER INSERT
AS
	PRINT 'Group was created'

INSERT INTO Groups VALUES('New group 1'); 
INSERT INTO Groups VALUES('New group 2'); 
INSERT INTO Groups VALUES('New group 3'); 
INSERT INTO Groups VALUES('New group 4');
DELETE Groups WHERE Id = 5

GO

/* Triggers types:
	Commadn: DDL (create, alter, drop), DML (insert, update, delete)
	Invokation time: AFTER, INSTEAD OF
*/

--------------- AFTER -----------------
-- Trigger than automaticaly invokes after insert a new student
create trigger tg_notify_remove_st
on Students		-- table
after delete	-- command
as
	print 'Student was deleted';
go

insert into Students (Name, Surname, Email, BirthDate, AverageMark)
values  ('Oleg', 'Christopher', 'jgty@gmail.com', '1999-09-27', 3),
		('Abner', 'Glanton', 'dkfeirg@gmail.com', '1995-09-20', 9);
go

select * from Students

delete from Students
where Id IN (11,12);

-- provocation
INSERT INTO Students (Name, Surname, Email, BirthDate, AverageMark)
VALUES 
	('Ivanka', 'Lublin', 'ninjia@gmail.com', '2005/1/1', 11),
	('Vika', 'Lublin', 'blablagreat@gmail.com', '2000/4/10', 11),
	('Sofia', 'Fedor', 'coolean@gmail.com', '1996/12/15', 12),
	('Galya', 'Blaegaer', 'soroja@gmail.com', '2003/7/12', 5),
	('Taras', 'Blaegaer', 'ninjia@gmail.com', '1998/5/9', 12),
	('Alex', 'Fedor', 'qjojojo@gmail.com', '1999/3/3', 9),
go

--drop table Archive
-- create archive table
create table Archive
(
	Id int identity primary key,
	Message nvarchar(100) NOT NULL,
	Date datetime default(getdate()) NOT NULL
)
go

select * from Archive
go

-- Temporary tables in triggers:
-- [inserted] - contains inserted items
-- [deleted]  - with deleted items

CREATE OR ALTER TRIGGER tg_new_student
ON Students
AFTER INSERT
AS
	INSERT INTO Archive(Message)
		SELECT 'Student ' + Name + ' was added to database'
		FROM inserted
GO

-- write out about new students
create or alter trigger tg_new_st_record
on students
after insert
as
	insert into Archive	(Message)
		select 'Student ' + Name + ' ' + Surname + ' was registered!'
		from inserted
	--values (cast(@@ROWCOUNT as varchar) + ' students were registered!');
go
-- check
select * from Archive
go

-- write out about deleted students
create or alter trigger tg_archive_delete_st
on Students
after delete
as
insert into Archive (Message)
	select 'Student ' + Name + ' was deleted!'
	from deleted
GO

select * from Students
GO
-- provocation
delete from Students
where Id IN (17, 16)
go

-- trigger after update students
create or alter trigger tg_archive_update_st
on Students
after update
as
insert into Archive(Message)
	select 'Student ' + i.Name + ' changed avg mark from ' + CAST(d.AverageMark as varchar) + ' to ' + CAST(i.AverageMark as varchar)
	from inserted as i JOIN deleted as d ON i.Id = d.Id

-- check
update Students
set AverageMark -= 1.8
where Id IN (12, 13)
go

-- deny insert young studetns (< 7 years)
create or alter trigger tg_deny_young_st
on Students
after insert
as
	if exists (select Id
			   from inserted
			   where DATEDIFF(year, BirthDate, GETDATE()) < 7)
	begin
		raiserror('Deny insert young student!', 12, 1)
		rollback transaction; -- відміна операції на яку виконався тригер
	end;
go

select * from Students
go
-- provocation
INSERT INTO Students (Name, Surname, Email, BirthDate, AverageMark)
VALUES 
	('Diilia', 'Heersema', 'jkkflo@bing.com', '2020-09-04', 12),
	('Valeda', 'Thaw', 'nckfjeroig@omniture.com', '1985-10-29', 8)
go

-- deny insert students into overflow group (> 10 students)
create or alter trigger tg_deny_overflow_group
on Students
after insert
as

if exists (select Id
		   from inserted
		   where (select COUNT(s.Id)
				  from Students as s --JOIN Groups as g ON s.GroupId = g.Id
				  where s.GroupId = inserted.GroupId) > 5)
begin
	raiserror('Deny overflow group!', 12, 1)
	rollback;
end;
go

-- provocation
INSERT INTO Students (Name, Surname, Email, BirthDate, AverageMark, GroupId)
VALUES 
	('Donnamarie', 'Witchalls', 'popop@ycombinator.com', '2001-02-01', 11.1, 1),
	('Kolli', 'Whitty', 'hvfktyf@homestead.com', '2004-06-01', 9.5, 1)
GO

-- check
select g.Id, g.Name, COUNT(s.Id)
from Students as s JOIN Groups as g ON s.GroupId = g.Id
group by g.Id, g.Name
go

-- with several command
create trigger tg_deny_modify_st
on Students
after update, delete
as
begin
	raiserror('Cannot modify or delete student!', 15, 1);
	rollback;
end;

-- disable/enable trigger
disable trigger tg_deny_modify_st on Students;
enable trigger tg_deny_modify_st on Students;

-- provocation
update Students
set AverageMark = AverageMark + 1
where Id = 6

delete from Students
where Id = 10

--------------- INSTEAD OF -----------------
select * from Students;

alter table Students
	add IsGraduate bit NOT NULL default(0)

select * from Archive
go

-- set graduate instead of delete students
create trigger tg_graduate_st
on Students
instead of delete
as
	update Students
	set IsGraduate = 1
	where Id IN (select Id from deleted)

select * from Students
-- provocation
delete from Students
where Id IN (37, 52);
go

-- deny insert old students
create or alter trigger tg_deny_old_st
on Students
instead of insert
as
INSERT INTO Students (Name, Surname, Email, BirthDate, AverageMark, GroupId, IsGraduate)
	select Name, Surname, Email, BirthDate, AverageMark, GroupId, IsGraduate
	from inserted
	where DATEDIFF(year, BirthDate, GETDATE()) < 55;

	-----------------------------
	insert into Archive (Message)
	select 'Student ' + Name + ' was ignored. Age must be < 55'
	from inserted
	where DATEDIFF(year, BirthDate, GETDATE()) >= 55;



-- provocation
INSERT INTO Students (Name, Surname, Email, BirthDate, AverageMark)
VALUES 
	('Hort', 'McCardle', 'aeaerg@yandex.ru', '1999-12-26', 11),
	('Katti', 'Goslin', 'nvoeuof@washington.edu', '1950-03-22', 12),
	('Carol', 'McGarahan', 'bhifibh@ask.com', '1996-05-11', 10);

select * from Students;
select * from Archive;
go

-- deny insert group with existing name (AFTER)
create or alter trigger tg_deny_dublicate_group
on Groups
after insert, update
as

if exists (	select i.Id
			from inserted as i, Groups as g
			where g.Name = i.Name AND g.Id <> i.Id)
begin
	raiserror('Deny insert group with existing name!', 12, 1)
	rollback transaction;
end;

/*
	Groups:			inserted:
		Rivne			Lutck
		Lviv			Rivne
		Kyiv
		Lutck
		Rivne
*/

-- test
select * from Groups

insert Groups (Name)
values ('Florida')

update Groups
set Name = 'New-York'
where Name = 'Florida'