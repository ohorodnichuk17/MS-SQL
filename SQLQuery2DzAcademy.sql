CREATE DATABASE Academy;
GO

USE Academy;
GO

CREATE TABLE Curators
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(max) NOT NULL CHECK(Name <> ''),
	Surname nvarchar(max) NOT NULL CHECK(Surname <> '')
)
GO


SET IDENTITY_INSERT Curators ON

INSERT INTO Curators(Id, Name, Surname)
VALUES (1, 'Gary', 'Burke'),
	   (2, 'Cassandra', 'Cross'),
	   (3, 'Richard', 'Stout')
GO

INSERT INTO Curators(Id, Name, Surname)
VALUES (4, 'Monica', 'Davis'),
	   (5, 'Paul', 'Johnson'),
	   (6, 'Samuel', 'Jones'),
	   (7, 'John', 'Smith'),
	   (8, 'Jason', 'Conley'),
	   (9, 'Carol', 'Richards')
GO

SELECT * FROM Curators

SET IDENTITY_INSERT Curators OFF


CREATE TABLE Faculties 
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Financing money NOT NULL CHECK(Financing >= 0) DEFAULT 0,
	Name nvarchar(100) NOT NULL CHECK(Name <> '') UNIQUE
)
GO

SET IDENTITY_INSERT Faculties ON

INSERT INTO Faculties(Id, Financing, Name) 
VALUES (1, 345, 'History'),
	   (2, 674, 'Arts '), 
	   (3, 975, 'Engineering'),
	   (4, 809, 'Economics'),
	   (5, 314, 'Commerce')
GO

INSERT INTO Faculties(Id, Financing, Name) 
VALUES (6, 897, 'Programming'),
	   (7, 672, 'Technologies'), 
	   (8, 135, 'Science'),
	   (9, 890, 'Mathematics'),
	   (10, 907, 'Law')
GO

SELECT * FROM Faculties

SET IDENTITY_INSERT Faculties OFF

CREATE TABLE Departments
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Financing money NOT NULL check(Financing >= 0) DEFAULT 0,
	Name nvarchar(100) NOT NULL check(Name <> '') UNIQUE,
	FacultyId int NOT NULL FOREIGN KEY REFERENCES Faculties(Id) 
)
go

SET IDENTITY_INSERT Departments  ON

INSERT INTO Departments(Id, Financing, Name, FacultyId)
VALUES (1, 6321, 'Administration', 3),
       (2, 753, 'Technologies', 7),
	   (3, 1342, 'Logistics', 1),
       (4, 9564, 'Finance', 5),
	   (5, 1434, 'Maintenance', 4),
	   (6, 158, 'Legal', 2),
       (7, 6842, 'Security', 5),
	   (8, 6843, 'Warehouses', 8),
	   (9, 743, 'Development', 7)
GO

SELECT * FROM Departments

SET IDENTITY_INSERT Departments  OFF
		
CREATE TABLE Groups
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(10) NOT NULL CHECK(Name <> '') UNIQUE,
	Course int NOT NULL CHECK(Course BETWEEN 1 AND 5),
	DepartmentId int NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)
GO

SET IDENTITY_INSERT Groups  ON

INSERT INTO Groups(Id, Name, Course, DepartmentId)
VALUES (1, 'P107', 2, 4),
	   (2, 'A414', 1, 3),
	   (3, 'DKQ414', 2, 6),
	   (4, 'HA275', 5, 8),
	   (5, 'BAU52', 4, 3),
	   (6, 'NKJ623', 2, 9),
	   (7, 'JWI374', 1, 1),
	   (8, 'GHJ864', 5, 6)
GO

SELECT * FROM Groups

SET IDENTITY_INSERT Groups  OFF


CREATE TABLE GroupCurators
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	CuratorId int NOT NULL FOREIGN KEY REFERENCES Curators(Id),
	GroupId int NOT NULL FOREIGN KEY REFERENCES Groups(Id)
)
GO

SET IDENTITY_INSERT GroupCurators  ON

INSERT INTO GroupCurators(Id, CuratorId, GroupId)
VALUES (1, 1, 4),
	   (2, 3, 8),
	   (3, 7, 4),
	   (4, 9, 2),
	   (5, 6, 5),
	   (6, 4, 3),
	   (7, 7, 1),
	   (8, 2, 6)
GO

SELECT * FROM GroupCurators

SET IDENTITY_INSERT GroupCurators  OFF

CREATE TABLE Subjects
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(100) NOT NULL CHECK(Name <> '') UNIQUE,
)
GO

SET IDENTITY_INSERT Subjects  ON

INSERT INTO Subjects(Id, Name)
VALUES (1, 'Math'),
	   (2, 'IT'),
	   (3, 'Programming'),
	   (4, 'Networking'),
	   (5, 'Python'),
	   (6, 'Java'),
	   (7, 'C#'),
	   (8, 'English'),
	   (9, 'Science'),
	   (10, 'Art')
GO

SELECT * FROM Subjects

SET IDENTITY_INSERT Subjects  OFF

CREATE TABLE Teachers
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(max) NOT NULL CHECK(Name <> ''),
	Surname nvarchar(max) NOT NULL CHECK(Surname <> ''),
	Salary money NOT NULL CHECK(Salary >= 0)
)
GO

SET IDENTITY_INSERT Teachers ON

INSERT INTO Teachers(Id, Name, Surname, Salary)
VALUES (1, 'Dana', 'Allen', 5000),
	   (2, 'Michael', 'Williams', 3999),
	   (3, 'Casey', 'Moon', 7982),
	   (4, 'Brandi', 'Greene', 526),
	   (5, 'Richard', 'Baker', 99),
	   (6, 'Timothy', 'Davis', 9999),
	   (7, 'Scott', 'Young', 8237),
	   (8, 'Dustin', 'Robbins', 1000),
	   (9, 'Stephanie', 'Mata', 7928),
	   (10, 'Amanda', 'Rivera', 2000),
	   (11, 'Sharon', 'Murillo', 7495)
GO

SELECT * FROM Teachers

SET IDENTITY_INSERT Teachers OFF

CREATE TABLE Lectures
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	LectureRoom nvarchar(max) NOT NULL check(LectureRoom <> ''),
	SubjectId int NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
	TeacherId int NOT NULL FOREIGN KEY REFERENCES Teachers(Id)
)
GO

SET IDENTITY_INSERT Lectures ON

INSERT INTO Lectures(Id, LectureRoom, SubjectId, TeacherId) 
VALUES (1, 'ABC', 2, 8),
	   (2, 'Community', 6, 1),
	   (3, 'Social', 8, 2),
	   (4, 'Decision', 3, 4),
	   (5, 'Lab', 9, 7),
	   (6, 'Space', 5, 8),
	   (7, 'Synergy', 1, 11),
	   (8, 'Brainstorming', 10, 8),
	   (9, 'Genius', 4, 5),
	   (10, 'Jam', 9, 3),
	   (11, 'Paradise', 6, 10),
	   (12, 'Odyssey', 7, 3)
GO

SELECT * FROM Lectures

SET IDENTITY_INSERT Lectures OFF

CREATE TABLE GroupsLectures
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	GroupId int NOT NULL FOREIGN KEY REFERENCES Groups(Id),
	LectureId int NOT NULL FOREIGN KEY REFERENCES Lectures(Id)
)
GO

SET IDENTITY_INSERT GroupsLectures ON

INSERT INTO GroupsLectures(Id, GroupId, LectureId) -- Gi 8, Li 12 
VALUES (1, 4, 6), 
	   (2, 8, 11),
	   (3, 3, 7),
	   (4, 1, 2),
	   (5, 2, 5),
	   (6, 7, 8),
	   (7, 5, 1), 
	   (8, 6, 9), 
	   (9, 3, 12) 
GO

SELECT * FROM GroupsLectures

SET IDENTITY_INSERT GroupsLectures OFF

-- 1. ������� �� ������ ���� ����� ���������� �� ����.
SELECT t.Id, t.Name, t.Surname, t.Salary, g.Id, g.Name, g.Course, g.DepartmentId
FROM Teachers AS t, Groups AS g
WHERE  t.Id = g.Id
GO

-- 2. ������� ����� ����������, ���� ������������ ������ ���� �������� ���� ������������ ����������. 
SELECT f.Name AS Faculties,
	   d.Name AS Departments,
	   f.Financing AS Financing,
	   d.Financing as Financing
FROM Faculties AS f, Departments AS d
WHERE f.Financing < d.Financing AND d.FacultyId = f.Id
GO	   

-- 3. ������� ������� �������� ���� �� ����� ����, �� ���� ���������.  
SELECT c.Surname, g.Name
FROM Curators AS c JOIN Groups AS g ON c.Id = g.Id
GO

-- 4. ������� ����� �� ������� ����������, �� ������� ������ � ���� �P107�.
SELECT t.Surname + ' ' + t.Name as Teachers, g.Name as Groups
FROM Groups AS g, Teachers AS t, Lectures as l, GroupsLectures as gl
WHERE gl.GroupId = g.Id AND gl.LectureId = l.Id AND l.TeacherId = t.Id AND g.Name = 'P107'
GO

-- 5. ������� ������� ���������� �� ����� ����������, �� ���� ���� ������� ������.
SELECT t.Surname, f.Name
FROM Teachers AS t, Faculties AS f, Lectures as l, GroupsLectures as gl
WHERE 
GO
-- 6. ������� ����� ������ �� ����� ����, �� �� ��� ��������
SELECT d.Name AS Departments, g.Name AS Groups
FROM Departments AS d, Groups AS g
WHERE g.DepartmentId = d.Id
GO

--7. ������� ����� ��������, �� ���� �������� �Dustin Robbins�.
SELECT s.Name AS Subjects, t.Name + ' ' + t.Surname as Tecahers
FROM Subjects as s, Teachers as t
WHERE t.Name = 'Dustin' AND t.Surname = 'Robbins' AND s.Id = t.Id
GO

-- 8. ������� ����� ������, �� �������� ��������� �Programming�
SELECT d.Name AS Departments, s.Name AS Subjects
FROM Departments AS d, Subjects AS s
WHERE s.Name = 'Programming'AND d.Id = s.Id
GO

-- 9. ������� ����� ����, �� �������� �� ���������� Mathematics.
SELECT g.Name AS Groups, d.Name AS Departments, f.Name AS Faculties
FROM Groups AS g, Departments AS d, Faculties AS f
WHERE f.Name = 'Mathematics' AND g.DepartmentId = d.Id AND d.FacultyId = f.Id
GO

-- 10. ������� ����� ���� 5-�� �����, � ����� ����� ����������, �� ���� ���� ��������.
SELECT g.Name AS Groups, g.Course AS Groups, f.Name AS Faculties
FROM Groups AS g, Faculties AS f, Departments AS d
WHERE g.Course = 5 AND g.DepartmentId = d.Id AND d.FacultyId = f.Id
GO

-- 11. ������� ����� ����� ���������� �� ������, �� ���� ������� (����� �������� �� ����),
--     ������� ������� ���� � ������, �� ��������� � ������� �Brainstorming�.
SELECT t.Name + ' ' + t.Surname as Teachers, s.Name as Subjects, g.Name as Groups, l.LectureRoom as Lectures
FROM Teachers AS t, Subjects AS s, Groups AS g, Lectures AS l, GroupsLectures AS gl
WHERE l.LectureRoom = 'Brainstorming' AND l.TeacherId = t.Id AND  gl.GroupId = g.Id AND gl.LectureId = l.Id AND l.SubjectId = s.Id
GO 