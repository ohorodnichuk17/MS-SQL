--------------- STORAGE PROCEDURES
use University2021;

----------------------------
create procedure MyFirstProc
as
	print 'Hello World!';

execute MyFirstProc;

drop procedure MyFirstProc;

----------------------------
-- with params
create proc sp_students_list 
@mark int
as
	select * from Students
	where AverageMark >= @mark

exec sp_students_list 5

----------------------------
create or alter proc sp_summ
@a int,
@b int = 1  -- значення по замовчуванню для параметра
as
	--code
	--declare @res bigint
	--set @res = @a + @b
	--select @res;
	print @a + @b;
	--select @a + @b;
GO

-- implicit 
exec sp_summ 7, 3

-- explicit
exec sp_summ @b=3, @a=7

----------------------------
-- return values with output params
create proc sp_substruct
@a int,
@b int,
@res int output
as
	--code
	set @res = @a - @b
GO

declare @out_value int = 0;
-- implicit 
exec sp_substruct 7, 3, @out_value output
-- explicit
--exec Sub @b=3, @a=7, @res = @out_value output
print @out_value;

-- use variable
select * 
from Students 
where AverageMark >= @out_value

select @out_value;

-------------------------------
-- get max and min student mark
create proc sp_get_max_min_mark
@max float output,
@min float output
as
	--set @max = (select MAX(AverageMark) from Students);
	--set @min = (select MIN(AverageMark) from Students);

	select @max = MAX(AverageMark), @min = MIN(AverageMark)
	from Students

-- execution
declare @max float, @min float;

exec sp_get_max_min_mark @max output, @min output

select @max as 'Maximum Mark', @min as 'Minimum Mark'

----------------------------------------
-- update students mark by email
create proc sp_update_mark
@new_mark float,
@email nvarchar(50)
as
	update Students
		set AverageMark = @new_mark
		where Email = @email

-- execution
exec sp_update_mark 9.1, 'aerge@gmail.com';

select * from Students

----------------------------
-- get students count
create proc sp_student_count
as
	declare @res int
	select @res = count(Id) from Students
	return @res; -- дозволяє повернути результат типу int
GO

declare @res int
exec @res = sp_student_count
print @res

----------------------------
-- процедура, яка повертає студентів які мають середній бал в переданому діапазоні
create or alter proc sp_students_by_mark
@mark_from int,
@mark_to int = @mark_from -- робе
as
	select Name + ' ' + Surname as [Full Name], Email, AverageMark
	from Students
	where AverageMark between @mark_from and @mark_to
	order by AverageMark desc;
GO
--------------------------------------------------------------
-- виклик процедури
exec sp_students_by_mark 7, 9

-- процедура повертає найстаршого та наймолодшого студента певної групи
create or alter proc sp_get_oldest_and_youngest_st
@group_name nvarchar(100),
@oldest date output,
@youngest date output
as
	select @oldest = MIN(BirthDate), @youngest = MAX(BirthDate)
	from Students as s JOIN Groups as g ON s.GroupId = g.Id
	where g.Name = @group_name -- AND s.BirthDate IS NOT NULL -- for avoid warning
GO
--------------------------------------------------------------
-- виклик процедури
declare @oldest date, @youngest date
exec sp_get_oldest_and_youngest_st 'New-York', @oldest output, @youngest output

print 'Oldest: ' + convert(nvarchar(30), @oldest);
print 'Youngest: ' + convert(nvarchar(30), @youngest);

-- повна інформація про студентів
create or alter proc sp_show_students_info
as
	select s.Id, s.Name + ' ' + s.Surname as [Full Name], s.Email, g.Name as [Group Name], s.AverageMark--, s.BirthDate
	from Students as s JOIN Groups as g ON s.GroupId = g.Id

exec sp_show_students_info

-- процедура змінює оцінку студента по email
create or alter proc sp_change_mark
@email nvarchar(100),
@new_mark int
as
	if (@new_mark not between 1 and 12)
		raiserror ('Mark %d must be in range from 1 to 12', 13, 1, @new_mark);
	else
		update Students
		set	AverageMark = @new_mark
		where Email = @email
GO

-- EXECUTE --
select * from Students

exec sp_change_mark 'kriakria@gmail.com', 8

-- системна процедура, яка повертає список таблиць БД
execute sys.sp_tables

-- процедура переводить студента в певну групу по імені
create or alter proc sp_move_student
@st_id int,
@group_name nvarchar(50)
as
	if not exists (select Id 
				   from Groups
				   where Name = @group_name)
	begin
		raiserror('Invalid group name.',11,1)
		return;
	end;

	declare @group_id int;

	select @group_id = Id
	from Groups
	where Name = @group_name

	update Students
	set GroupId = @group_id
	where Id = @st_id

-- execution
exec sp_show_students_info
exec sp_move_student 73, 'Colorado'


--------------- Database Music Collection
use MusicCollection

-- Task 4:
alter proc sp_get_most_popular_disk
@style_name nvarchar(50)
as
	select top 1 d.Name, COUNT(s.Id)
	from Songs as s JOIN MusicDiscs as d ON s.MusicDiscId = d.Id	
					JOIN Styles as st ON d.StyleId = st.Id
	where @style_name = 'all' OR st.Name = @style_name
	group by d.Id, d.Name
	order by COUNT(s.Id) desc

select * from Styles
select * from MusicDiscs
select * from Songs

exec sp_get_most_popular_disk 'Lizard, mexican beaded'

-- Task 7:
declare @part_name nvarchar(50) = 'ol'
 
-- ol eg olga bla ol egbla rozola
Name like '% ' + @part_name + ' %'