--------------- Transact-SQL (T-SQL)

----------------variables
declare @number INT = 0;
set @number = 11;

declare @date_now date;
select @date_now = GETDATE(), @number = 12

-- show
select @date_now as 'Current Date', @number as 'Number';

------------------- print
print 'Current date: ' + cast(@date_now as nvarchar(20));
print 'Current date: ' + convert(nvarchar(20), @date_now);

------------------- raiserror
raiserror('Something went wrong! File: %s, Id: %d', 15, 1, 'main_bd.md', 34);

declare @number INT = 777;
RAISERROR ('Number: %d %s', 24, 1, @number, 'value')
-- Severity: 1-10 - warnings (not errors)
--			11-15 - user errors
--			16-24 - system errors (18 > fatal error)
-- %d, %i - digit
-- %s - string
-- %u - unsigned digit

select * from sys.messages
where message_id = 29300

raiserror (29300, 16, 1, 'windows.exe');

------------------- set in select
use Hospital;
use University;

declare @number money;
select @number = MAX(Salary)
from Doctors

print 'Max Salary: ' + cast(@number as nvarchar(10));

declare @oldest_st nvarchar(30)

select @oldest_st = Name
from Students 
order by BirthDate DESC

print @oldest_st;

----------------- conditions
declare @minutes int = datepart(minute, GETDATE());
print @minutes

declare @weekday nvarchar(10) = datename(weekday, GETDATE());
print @weekday

if (@minutes > 30)
begin
	print 'Bigger';
end;
else
begin
	print 'Less';
end;

--cycles
declare @i INT = 0;

while (@i < 10)
begin
	if (@i = 7)
	begin
		Raiserror('%d - Error message...', 11, 0, @i);
		--break;
	end;
	else
	begin
		PRINT(CAST(@i as nvarchar(2)) + ' - Element: ');
	end
	--set @i = @i + 1;
	set @i += 1
end;

--case
GO
declare @i INT = 1;

declare @msg NVARCHAR(30)

set @msg = case	
	when @i > 0 then 'Positive'
	when @i = 0 then 'Zero'
	when @i < 0 then 'Negative'
	end;

PRINT @msg;

print (
	case @i
		when 1 then 'One'
		when 2 then 'Two'
		when 3 then 'Three'
		else 'Invalid' --спрацює, якщо жодна умова when не виконалася
		end);

select Id, Name
from Students
where Id = @i

-- insert select - вставка даних, які повертає select запит
create table VeryGoodStudents
(
	Id int primary key identity,
	Name nvarchar(100) NOT NULL, 
	Surname nvarchar(100) NOT NULL
)

insert into VeryGoodStudents(Name, Surname)
	select Name, Surname
	from Students
	where AverageMark >= 10

select * from VeryGoodStudents

-- select into - вставка даних, які повертає select запит в окрему таблицю, яка створюється автоматично
select Name, Surname, AverageMark
into BadStudents
from Students
where AverageMark < 10

select * from BadStudents

SELECT CONVERT(VARCHAR(8),GETDATE(),108)