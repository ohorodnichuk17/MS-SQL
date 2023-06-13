-- Оператори GROUP BY та HAVING

USE MyUniversityDb;
select * from Students;
select * from Groups
GO

SELECT g.Name, COUNT(s.Id) 
FROM Students AS s JOIN Groups AS g ON s.GroupId = g.Id
GROUP BY g.Name

SELECT s.AverageMark, COUNT(s.Id), MAX(s.Fails) 
FROM Students AS s JOIN Groups AS g ON s.GroupId = g.Id
GROUP BY s.AverageMark



alter table Students
	add BirthDate date not null default(GETDATE()) check(BirthDate <= GETDATE())

alter table Students
drop column BirthDate

-- select може містити ключі групи або агрегаційні функції (grouping key, aggregate functions)
select s.AverageMark, COUNT(s.Id), MAX(s.Fails)
from Students as s JOIN Groups as g ON s.GroupId = g.Id
group by s.AverageMark -- key
GO

------------------------------------------------------
-- GROUP BY - групування елементів по певному критерію
-- для згрупованих записів, агрегаційні функції обраховують значення для кожної групи окремо

-- групування студентів по назві групи в якій вони навчаються та обчислення кількості студентів в кожній з них
select GroupId, COUNT(Id)
from Students
group by GroupId
GO

-- групування по середньому балу та визначення кі-сті студентів для кожної групи
select AverageMark, COUNT(Id)
from Students
group by AverageMark
GO

-- фільтрація записів перед повинна виконуватися перед групуванням
select AverageMark, COUNT(Id)
from Students
where YEAR(BirthDate) >= 2003
group by AverageMark
GO

-- обрахунок середнього балу студентів кожної групи
select g.Id, g.Name, AVG(s.AverageMark)
from Students as s JOIN Groups as g ON g.Id = s.GroupId
GROUP BY g.Id, g.Name
GO

-- при сортуванні записів в якості ключа можна вказувати значення будь-якої колонки
select AverageMark, 
		COUNT(Id) as 'Student Count',
		MIN(BirthDate) as 'Oldest Student'
from Students
where AverageMark >= 9
group by AverageMark
order by MIN(BirthDate)
GO

-- отримати групу з найбільшою к-стю студентів
select top 1 g.Name--, COUNT(s.Id)
from Students as s JOIN Groups as g ON s.GroupId = g.Id
group by g.Name
order by COUNT(s.Id) desc
GO

--------------------------------------------
-- HAVING - фільтрує вже згруповані елементи

-- так як оператор WHERE виконується ще до групування, то профільтрувати групи там неможливо
-- для цього використовуємо оператор HAVING після GROUP BY

select g.Name, COUNT(s.Id) as CountOfStudents
from Students as s JOIN Groups as g ON s.GroupId = g.Id
where s.Lessons >= 10
group by g.Name
having COUNT(s.Id) > 1
order by CountOfStudents
GO

-- визначаєтся кі-сть студентів для кожної групи та відбираємо лише ті, де кі-сть > 3
select g.Name, COUNT(s.Id)
from Students as s JOIN Groups as g ON s.GroupId = g.Id
--where COUNT(s.Id) > 3 -- error
group by g.Name
having COUNT(s.Id) > 3
GO

-- відбираємо групи, які мають середній бал студентів >= 9
select	g.Name, 
		AVG(s.AverageMark) as 'Group Average Mark', 
		SUM(s.AverageMark) as 'Group Total Mark', 
		COUNT(s.Id) as 'Students Count'
from Groups as g JOIN Students as s ON s.GroupId = g.Id
group by g.Name
having AVG(s.AverageMark) >= 10
order by SUM(s.AverageMark) desc
GO

---------------------- Hospital (PZ 5)
-- Task 2
select d.Name, COUNT(w.Id)
from Departments as d JOIN Wards as w ON d.Id = w.DepartmentId
group by d.Name
GO

-- Task 9
select d.Name, SUM(w.Places)
from Departments as d JOIN Wards as w ON d.Id = w.DepartmentId
where d.Building IN (1,6,7,8) AND w.Places > 10
group by d.Name
having SUM(w.Places) > 100
GO

---------------------- Hospital (DZ 5)
-- Task 1
select COUNT(t.Id)
from Departments as d JOIN Groups as g ON d.Id = g.DepartmentId
					  JOIN GroupsLectures as gl ON gl.GroupId = g.Id
					  JOIN Lectures as l ON gl.LectureId = l.Id
					  JOIN Teachers as t ON l.TeacherId = t.Id
where d.Name = 'Software Development'
GO
--group by d.Id