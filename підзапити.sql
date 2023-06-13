use MyUniversityDb;

select * from Students

select MIN(AverageMark)
from Students

update Students
 set AverageMark = 1.1
 where Id in (32,60,74,78,79)



select top 6 AverageMark, Name, Surname, Email
from Students
order by AverageMark 

select * from Students
where AverageMark = (select MIN(AverageMark) from Students) --1.1

declare @min_mark float = (select MIN(AverageMark) from Students);
print @min_mark;

select *
from Students
where AverageMark = @min_mark

update Students
 set AverageMark = 1.1
 where Id in (32,60,74,78,79)

 select COUNT(Id)
 from Students
 where GroupId = 8

 select *
 from Students as s
 where (select COUNT(Id)
		 from Students
		 where GroupId = s.GroupId ) >= 5


declare @min_student_count int = (select top 1 COUNT(Id)
								from Students
								group by GroupId
								order by COUNT(Id) asc)
select *
from Groups as g
where (select COUNT(Id)
		from Students
		where GroupId = g.Id) =  @min_student_count;

select *
from Teachers as t
where (select COUNT(s.Id)
		from Students as s JOIN Groups as g ON g.Id=s.GroupId
						   JOIN TeachersGroups as tg ON tg.GroupId = g.Id
						   where tg.TeacherId = t.Id and s.AverageMark >= 10) 
		>
		(select COUNT(s.Id)
		from Students as s JOIN Groups as g ON g.Id=s.GroupId
						   JOIN TeachersGroups as tg ON tg.GroupId = g.Id
						   where tg.TeacherId = t.Id) /2

select *
		from Students as s JOIN Groups as g ON g.Id=s.GroupId
						   JOIN TeachersGroups as tg ON tg.GroupId = g.Id
						   where tg.TeacherId = 1

update Students
set AverageMark = 10.5
where Id in (1,14,17)







