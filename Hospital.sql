CREATE DATABASE Hospital
GO

USE Hospital
GO

CREATE TABLE Departments
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Building int NOT NULL CHECK(Building BETWEEN 1 AND 5),
	Financing money NOT NULL CHECK(Financing > 0) DEFAULT 0,
	Name nvarchar(100) NOT NULL CHECK(Name <> '') UNIQUE
)
GO

SET IDENTITY_INSERT Departments ON
INSERT INTO Departments(Id, Building, Financing, Name)
VALUES (1, 1, 2999, 'Surgery'),
	   (2, 2, 1970, 'Trauma'),	
	   (3, 3, 1000, 'Neurological'),
	   (4, 4, 2000, 'therapeutic'),
	   (5, 5, 19999, 'Septic')
GO

SELECT * FROM Departments
SET IDENTITY_INSERT Departments OFF

CREATE TABLE Diseases
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(100) NOT NULL CHECK(Name <> '') UNIQUE,
	Severity int NOT NULL CHECK(Severity > 1) DEFAULT 1
)
GO

SET IDENTITY_INSERT Diseases ON
INSERT INTO Diseases(Id, Name, Severity)
VALUES (1, 'Bronchitis', 4),
	   (2, 'Flu', 5),
	   (3, 'Diabet', 8),
	   (4, 'Malaria', 8),
	   (5, 'Poisoning', 3),
	   (6, 'Schizophrenia', 10)
GO

SELECT * FROM Diseases
SET IDENTITY_INSERT Diseases OFF

CREATE TABLE Doctors
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(max) NOT NULL CHECK(Name <> ''),
	Surname nvarchar(max) NOT NULL CHECK(Surname <> ''),
	Phone char(10) NOT NULL,
	Salary money NOT NULL CHECK(Salary >= 0)
)
GO

SET IDENTITY_INSERT Doctors ON
INSERT INTO Doctors(Id, Name, Surname, Phone, Salary)
VALUES (1, 'Daisie', 'Frederick', '0987394728', 8000),
	   (2, 'Tyler', 'Montgomery', '0958274827', 12000),
	   (3, 'Sapphire', 'Duke', '0687282729', 9000),
	   (4, 'Maddie', 'Munoz', '0968262846', 24000),
	   (5, 'Uzair', 'Nolan', '0986382738', 14000),
	   (6, 'Russell', 'Dillon', '0937283728', 5000),
	   (7, 'Ellie-May', 'Friedman', '0687284628', 90000)
GO

SELECT * FROM Doctors
SET IDENTITY_INSERT Doctors OFF

CREATE TABLE Examinations
(
	Id int PRIMARY KEY IDENTITY NOT NULL,
	Name nvarchar(100) NOT NULL CHECK(Name <> '') UNIQUE,
	DayOfWeek int NOT NULL CHECK(DayOfWeek BETWEEN 1 AND 7),
	StartTime TIME NOT NULL CHECK(StartTime BETWEEN '08:00' AND '18:00'),
	EndTime TIME NOT NULL  CHECK(EndTime BETWEEN '08:00' AND '18:00'),
	CHECK(EndTime > StartTime)
)
GO

SET IDENTITY_INSERT Examinations ON
INSERT INTO Examinations(Id, Name, DayOfWeek, StartTime, EndTime)
VALUES(1, 'Inspection', 3, '10:00', '11:30'),
	  (2, 'Auscultation', 2, '9:00', '9:30'),
	  (3, 'Percussion', 6, '13:00', '14:30'),
	  (4, 'Palpation', 1, '15:15', '17:20'),
	  (5, 'Manipulation', 5, '12:10', '14:40')
GO

SELECT * FROM Examinations
SET IDENTITY_INSERT Examinations OFF

CREATE TABLE Wards
(
	Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	Building INT NOT NULL CHECK(Building BETWEEN 1 AND 5),
	Floor INT NOT NULL CHECK(Floor > 0),
	Name NVARCHAR(20) NOT NULL CHECK(Name <> '') UNIQUE
)
GO

SET IDENTITY_INSERT Wards ON
INSERT INTO Wards(Id, Building, Floor, Name)
VALUES(1, 4, 2, 'General'),
	  (2, 3, 1, 'Surgery'),
	  (3, 2, 5, 'Cardiothoracic'),
	  (4, 5, 1, 'Neurology'),
	  (5, 3, 2, 'Ophthalmology'),
	  (6, 2, 3, 'Rehabilitation'),
	  (7, 4, 1, 'Endocrinology')	
GO

SELECT * FROM Wards
SET IDENTITY_INSERT Wards OFF

CREATE TABLE DoctorsExaminations
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	StartTime TIME NOT NULL CHECK(StartTime BETWEEN '08:00' AND '18:00'),
	EndTime TIME NOT NULL  CHECK(EndTime BETWEEN '08:00' AND '18:00'),
	CHECK(EndTime > StartTime),
	DoctorId INT NOT NULL FOREIGN KEY REFERENCES Doctors(Id),
	ExaminationId INT NOT NULL FOREIGN KEY REFERENCES Examinations(Id),
	WardId INT NOT NULL FOREIGN KEY REFERENCES Wards(Id) 
)
GO

SET IDENTITY_INSERT DoctorsExaminations ON
INSERT INTO DoctorsExaminations(Id, StartTime, EndTime, DoctorId, ExaminationId, WardId)
VALUES()

GO

SELECT * FROM DoctorsExaminations
SET IDENTITY_INSERT DoctorsExaminations OFF

-- 1. Представлення відображає список всіх докторів
CREATE VIEW AllDoctors
AS
SELECT Id, Name, Surname, Phone, Salary 
FROM Doctors
GO 

SELECT * FROM AllDoctors

-- 2. Представлення відображає повну інформацію по всіх обстеженнях включно з іменем доктора, іменем палати та кількістю мість в ній
CREATE VIEW  AboutExaminations
AS
SELECT E.Id, E.Name, E.DayOfWeek, E.StartTime, E.EndTime, D.Name, DP.Name, DP.Id
FROM Examinations AS E JOIN Doctors AS D JOIN Departments AS DP ON d.Id = DP.Id

-- 3. Відображає інформацію про палати конкретного віділення (на вибір)
CREATE VIEW DepartmentsInform
AS
SELECT Id, Building, Financing, Name
FROM Departments
WHERE Name = 'Trauma'

SELECT * FROM DepartmentsInform

-- 4. Відображає інформацію про доктора який виконав найбільшу кількість обстежень
CREATE VIEW BestDoctor (DoctorId, DoctorName, Surname, ExaminationsId)
AS
SELECT D.Id, D.Name, D.Surname, E.Id
FROM Doctors AS D JOIN Examinations AS E ON E.Id > 4 

SELECT * FROM BestDoctor

-- 5. Відображає топ-3 докторів за величиною премії
CREATE VIEW TopDoctors
AS
SELECT TOP 3 *
FROM Doctors
ORDER BY Salary DESC

SELECT * FROM TopDoctors

-- 6. Відображає інформацію про доктора, який отримує найбільшу ЗП
CREATE VIEW BigSalary
AS
SELECT Id, Name, Surname, Phone, Salary 
FROM Doctors WHERE Salary > 30000

SELECT * FROM BigSalary