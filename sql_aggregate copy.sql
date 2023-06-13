-- Aggregate Functions
/*
	COUNT() - обчислює кількість записів (працює з символьними та числовими типами)
	SUM()	- обчислює суму всіх значень (працює з числовими типами)
	AVG()	- обчислює середнє значення по всіх записах (працює з числовими типами)
	MIN()	- обчислює мінімальне значення (працює з символьними та числовими типами)
	MAX()	- обчислює максимальне значення (працює з символьними та числовими типами)
*/

USE MyUniversityDb;
select * from Students
SELECT * from Groups

select GroupId, COUNT(Id)
from Students
group by GroupId           

-- COUNT
select COUNT(Id) as 'Student Count' from Students

-- при роботі з конкретною колонкою, NULL-значення ігноруються
select COUNT(AverageMark) as 'Student count' from Students

select COUNT(Id) as 'Good Students'
from Students
where AverageMark >= 10

-- MIN/MAX
select MAX(AverageMark) as 'Result'
from Students
--where DAY(Birthdate) % 2 <> 0

select MIN(Name) as 'Result'
from Students

-- SUM/AVG
select AVG(AverageMark) as 'Result'
from Students
--where YEAR(BirthDate) >= 2000

select COUNT(s.Id) as 'Count of Students', AVG(AverageMark) as 'Sum of Marks'
from Students as s JOIN Groups as g ON s.GroupId = g.Id
where g.Name = 'Dublin'

SELECT * FROM Students

SELECT * From Groups

SELECT s.AverageMark, COUNT(s.Id) as CountId, MAX(s.Fails) AS 'Max fails lesson'
from Students AS s JOIN Groups as g ON s.GroupId = g.Id
GROUP BY s.AverageMark

