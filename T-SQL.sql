-- T-SQL
if(3 <> 4)

declare @number int;
declare @@global_number int = 333; --глобальна змінна
set @number = 10;
print 'Number: ' + cast(@number as varchar);
print 'Number: ' + convert(varchar, @number); -- T-SQL
--print @number, @@global_number;
select  @number as 'Local', @@global_number as 'Global';

declare @result bigint = @number + 999;
--set @result = @result + 3;
set @result *= 3;
print @result;

if(@result > @number)
begin--{
	print 'Bigger than number';
	print 'Bigger than number';
	print 'Bigger than number';
end--}
else
	print 'Less than number';

declare @i int = 10;

while(@i > 0)
begin
	print @i;
	set @i -= 1;
end

-- ПРОЦЕДУРИ
create procedure ShowHello
as
begin
	print 'Bla bla bla'
end

execute ShowHello