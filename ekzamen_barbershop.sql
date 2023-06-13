CREATE DATABASE Barbershop
GO

USE Barbershop
GO

CREATE TABLE Barbers
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Name NVARCHAR(100) NOT NULL CHECK(Name <> ''),
    Surname NVARCHAR(100) NOT NULL CHECK(Surname <> ''),
    Lastname NVARCHAR(100) NOT NULL CHECK(Lastname <> ''),
    Gender NVARCHAR(20) NOT NULL CHECK(Gender <> ''),
    Phone BIGINT NOT NULL UNIQUE,
    Email NVARCHAR(50) NOT NULL UNIQUE,
    DateBirthday DATE NOT NULL CHECK(DateBirthday <= GETDATE()),
    HireDate INT NOT NULL CHECK(HireDate <= GETDATE()),
    PositionId INT FOREIGN KEY REFERENCES Position(Id)
);
GO

SET IDENTITY_INSERT Barbers ON

INSERT INTO Barbers(Id, Name, Surname, Lastname, Gender, Phone, Email, DateBirthday, HireDate, PositionId)
VALUES (1, 'Felix', 'Owen', 'Wang', 'Male', 380958272482, 'felix.owen@gmail.com', '2000-04-10', 5, 3),
       (2, 'Ilyas', 'Gonzalez', 'Middleton', 'Male', 380688372742, 'gonzalez@gmail.com', '1998-09-12', 1, 2),
       (3, 'Megan', 'Rojas', 'Knox', 'Female', 380987283728, 'megan.rojas@gmail.com', '2002-01-15', 3, 2),
       (4, 'Katrina', 'Morse', 'Velazquez', 'Female', 380938358201, 'katrina.morse@gmail.com', '2001-04-08', 1, 3),
       (5, 'Trystan', 'Christensen', 'Graham', 'Male', 380968283592, 'trystan.christensen@gmail.com', '1994-11-21', 8, 1),
       (6, 'Hari', 'Palmer', 'Woods', 'Male', 380689273592, 'hari.palmer@gmail.com', '2003-05-01', 1, 3),
       (7, 'Tilly', 'Jenkins', 'Collier', 'Female', 380959244193, 'tilly.jenkins@gmail.com', '2001-02-16', 2, 3),
       (8, 'Jaxon', 'Olsen', 'Bush', 'Male', 380979378210, 'jaxon.olsen777@gmail.com', '1993-12-08', 6, 2),
       (9, 'Kain', 'Wagner', 'Farmer', 'Male', 380689248492, 'kainwagner@gmail.com', '2002-02-02', 4, 3),
       (10, 'Elizabeth', 'Bentley', 'Maddox', 'Female', 380968351384, 'eliza.bentley@gmail.com', '1992-07-19', 7, 2),
       (11, 'Yaseen', 'Bird', 'Collier', 'Male', 380987142747, 'yaseen.bird@gmail.com', '2004-05-17', 9, 3),
       (12, 'Fiona', 'Copeland', 'Murphy', 'Female', 380681582819, 'fiona.copeland1@gmail.com', '1996-12-31', 1, 3)
GO

SELECT * FROM Barbers

SET IDENTITY_INSERT Barbers OFF

CREATE TABLE Position
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Name NVARCHAR(100) NOT NULL CHECK(Name <> '')
);
GO

SET IDENTITY_INSERT Position ON

INSERT INTO Position(Id, Name)
VALUES (1, 'Cheaf barber'),
       (2, 'Senior barber'),
       (3, 'Junior barber')
GO

SELECT * FROM Position

SET IDENTITY_INSERT Position OFF

CREATE TABLE Services
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Name NVARCHAR(100) NOT NULL CHECK(Name <> ''),
    Duration TIME CHECK(Duration BETWEEN '10:00' AND '21:00'),
    Price MONEY NOT NULL CHECK(Price >= 0) DEFAULT 0
);
GO

SET IDENTITY_INSERT Services ON

INSERT INTO Services(Id, Name, Duration, Price)
VALUES (1, 'ESCAPE HAIRCUT', '11:30', 3999),
       (2, 'CLEAN ESCAPE', '11:50', 2000),
       (3, 'GRAND ESCAPE', '12:10', 1930),
       (4, 'ULTIMATE ESCAPE HAIRCUT', '20:20', 6999),
       (5, 'BUZZ CUT', '15:45', 4914),
       (6, 'BEARD TRIM LINE UP', '20:15', 999),
       (7, 'HEAD SHAVE', '19:40', 499),
       (8, 'RAZOR FADE', '18:00', 300),
       (9, 'BEARD SHAVE', '17:30', 150),
       (10, 'CLEAN UP', '15:00', 135),
       (11, 'FULL SERVICE', '12:30', 8999)
GO

SELECT * FROM Services

SET IDENTITY_INSERT Services OFF

CREATE TABLE BarbersServices
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    BarberId INT FOREIGN KEY REFERENCES Barbers(Id),
    ServiceId INT FOREIGN KEY REFERENCES Services(Id) 
);
GO

SET IDENTITY_INSERT BarbersServices ON

INSERT INTO BarbersServices(Id, BarberId, ServiceId)
VALUES (1, 3, 8),
       (2, 6, 11),
       (3, 2, 3),
       (4, 9, 5),
       (5, 5, 9),
       (6, 12, 6),
       (7, 4, 10),
       (8, 11, 8),
       (9, 1, 4),
       (10, 3, 7),
       (11, 10, 4),
       (12, 7, 1),
       (13, 8, 2),
       (14, 2, 5),
       (15, 11, 9),
       (16, 8, 1),
       (17, 5, 9)
GO

SELECT * FROM BarbersServices

SET IDENTITY_INSERT BarbersServices OFF

CREATE TABLE Feedbacks
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Meesage NVARCHAR(max) NOT NULL,
    BarberId INT FOREIGN KEY REFERENCES Barbers(Id),
    MarksId INT FOREIGN KEY REFERENCES Marks(Id)
);
GO

SET IDENTITY_INSERT Feedbacks ON

INSERT INTO Feedbacks(Id, Meesage, BarberId, MarksId)
VALUES (1, 'Best shop I have ever been!', 2, 8),
       (2, 'Place is absolutely amazing!', 5, 3),
       (3, 'Excellent haircut', 9, 1),
       (4, 'Fantastic place to get a cut and beard trim.', 4, 9),
       (5, 'Great barber shop with a fun vintage feel.', 11, 7),
       (6, 'Literally the best shop', 8, 5),
       (7, 'Mark is bad', 3, 6),
       (8, 'The place is relaxing and friendly', 1, 2),
       (9, 'Great spot with exhalent costumer service', 12, 12),
       (10, 'Arguably the best haircut I have ever had', 10, 11),
       (11, 'No experience fading horrible barber', 6, 4)
GO

SELECT * FROM Feedbacks

SET IDENTITY_INSERT Feedbacks OFF

CREATE TABLE Marks
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Name NVARCHAR(100) NOT NULL CHECK(Name <> '')
);
GO

SET IDENTITY_INSERT Marks ON

INSERT INTO Marks(Id, Name)
VALUES (1, '10/10'),
       (2, '9/10'),
       (3, '5/10'),
       (4, '10/10'),
       (5, '8/10'),
       (6, '10/10'),
       (7, '2/10'),
       (8, '10/10'),
       (9, '5/10'),
       (10, '9/10'),
       (11, '0/10'),
       (12, '7/10')
GO

SELECT * FROM Marks

SET IDENTITY_INSERT Marks OFF
GO

CREATE TABLE DateSchedule
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Data DATE NOT NULL CHECK(Data >= GETDATE()),
    Time TIME CHECK(Time BETWEEN '10:00' AND '21:00'),
    ClientId INT FOREIGN KEY REFERENCES Clients(Id),
    BarberId INT FOREIGN KEY REFERENCES Barbers(Id)
);
GO

SET IDENTITY_INSERT DateSchedule ON

INSERT INTO DateSchedule(Id, Data, Time, ClientId, BarberId) 
VALUES (1, '2023-01-30', '11:20', 12, 2),
       (2, '2023-01-29', '12:30', 3, 8 ),
       (3, '2023-01-31', '10:10', 9, 11),
       (4, '2023-02-12', '20:30', 1, 1),
       (5, '2023-02-02', '11:45', 4, 3),
       (6, '2023-01-30', '10:55', 5, 5),
       (7, '2023-01-31', '19:30', 7, 10),
       (8, '2023-02-22', '18:45', 10, 9),
       (9, '2023-01-31', '13:00', 13, 7),
       (10, '2023-02-01', '12:00', 2, 12),
       (11, '2023-03-15', '11:30', 6, 6),
       (12, '2023-02-11', '16:20', 8, 4),
       (13, '2023-04-18', '18:00', 15, 3),
       (14, '2023-01-30', '15:00', 13, 11),
       (15, '2023-03-21', '17:40', 14, 9),
       (16, '2023-03-29', '12:30', 16, 5)
GO

SELECT * FROM DateSchedule

SET IDENTITY_INSERT DateSchedule OFF

CREATE TABLE Avalibility
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    DateTime DATE NOT NULL CHECK(DateTime <= GETDATE()),
    BarberId INT FOREIGN KEY REFERENCES Barbers(Id)
);
GO

SET IDENTITY_INSERT Avalibility ON

INSERT INTO Avalibility(Id, DateTime, BarberId)
VALUES (1, '2023-01-22', 2),
       (2, '2023-01-18', 6),
       (3, '2023-01-15', 11),
       (4, '2023-01-28', 3),
       (5, '2023-01-26', 8),
       (6, '2023-01-21', 12),
       (7, '2023-01-13', 4),
       (8, '2023-01-01', 1),
       (9, '2023-01-09', 10),
       (10, '2023-01-12', 7),
       (11, '2023-01-16', 9),
       (12, '2023-01-19', 5)
GO

SELECT * FROM Avalibility

SET IDENTITY_INSERT Avalibility OFF

CREATE TABLE Clients
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Name NVARCHAR(100) NOT NULL CHECK(Name <> ''),
    Surname NVARCHAR(100) NOT NULL CHECK(Surname <> ''),
    Lastname NVARCHAR(100) NOT NULL CHECK(Lastname <> ''),
    Phone BIGINT NOT NULL UNIQUE,
    Email NVARCHAR(50) NOT NULL UNIQUE
);
GO

SET IDENTITY_INSERT Clients ON

INSERT INTO Clients(Id, Name, Surname, Lastname, Phone, Email)
VALUES (1, 'Leyton', 'Bryant', 'Poole', '380958284729', 'leyton.bryant@gmail.com'),
       (2, 'Leo', 'Glass', 'Snyder', '380687394728', 'leo.glass@gmail.com'),
       (3, 'Enzo', 'Montoya', 'Long', '38983739374', 'enzo.montoya@gmail.com'),
       (4, 'Ronan', 'Ford', 'Meyer', '380937394738', 'ronan.ford@gmail.com'),
       (5, 'Syed', 'Dejesus', 'May', '380507283720', 'syed.dejesus@gmail.com'),
       (6, 'Mollie', 'Rosario', 'Young', '380689273847', 'mollie.rosario@gmail.com'),
       (7, 'Hattie', 'Hines', 'Oliver', '380982749274', 'hattie.hines@gmail.com'),
       (8, 'Adam', 'Oconnell', 'Andrews', '380957294727', 'adam.oconnell@gmail.com'),
       (9, 'Lila', 'Jennings', 'Quinn', '380502848274', 'lila.jennings@gmail.com'),
       (10, 'Elinor', 'Baker', 'Carter', '380639738592', 'alinor.baker@gmail.com'),
       (11, 'Rachael', 'Thomson', 'Sparks', '380987395728', 'rachael.thomson@gmail.com'),
       (12, 'Siena', 'Shepherd', 'Fuller', '380508372858', 'siena.shepherd@gmail.com'),
       (13, 'Lulu', 'Everett', 'Baldwin', '380957293728', 'luli.everett@gmail.com'),
       (14, 'Pearl', 'Sawyer', 'Anderson', '380683859389', 'pearl.sawyer@gmail.com'),
       (15, 'Hannah', 'Nolan', 'Higgins', '380502848384', 'hannah.nolan@gmail.com'),
       (16, 'Marnie', 'Winter', 'Wells', '380983749373', 'marnie.winter@gmail.com')
GO

SELECT * FROM Clients

SET IDENTITY_INSERT Clients OFF
GO

CREATE TABLE Archive
(
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    ClientId INT FOREIGN KEY REFERENCES Clients(id),
    BarberId INT FOREIGN KEY REFERENCES Barbers(id),
    ServiceId INT FOREIGN KEY REFERENCES Services(id),
    Date  DATE NOT NULL,
    Price MONEY NOT NULL CHECK(Price > 0),
    FeedbackId INT FOREIGN KEY REFERENCES Feedbacks(id),
);
GO

SET IDENTITY_INSERT Archive ON

INSERT INTO Archive(Id, ClientId, BarberId, ServiceId, Date, Price, FeedbackId) 
VALUES (1, 3, 11, 4, '2022-05-16', 300, 8),
       (2, 5, 3, 7, '2020-12-25', 1999, 6),
       (3, 8, 6, 1, '2023-01-13', 999, 4),
       (4, 11, 12, 1, '2022-11-12', 105, 9), 
       (5, 16, 10, 10, '2019-04-21', 6999, 11),
       (6, 14, 2, 9, '2022-08-19', 500, 2),
       (7, 12, 8, 11, '2022-05-04', 499, 7),
       (8, 1, 9, 3, '2022-03-05', 999, 10),
       (9, 7, 1, 8, '2022-04-30', 99, 3),
       (10, 9, 7, 2, '2023-01-24', 699, 1),
       (11, 13, 4, 6, '2021-12-17', 299, 5),
       (12, 5, 5, 5, '2021-10-13', 100, 8),
       (13, 2, 11, 9, '2018-07-17', 350, 3),
       (14, 6, 2, 4, '2022-06-25', 5000, 11),
       (15, 15, 4, 2, '2023-01-27', 2999, 9),
       (16, 10, 12, 11, '2017-02-25', 1000, 3)
GO

SELECT * FROM Archive

SET IDENTITY_INSERT Archive OFF
GO


-- Повернути ПІБ всіх барберів салону.
CREATE VIEW FullNameBarbers
AS
    SELECT Name + ' ' + Surname + ' ' + Lastname AS 'Full name'
    FROM Barbers
GO

SELECT * FROM FullNameBarbers
GO

-- Повернути інформацію про всіх синьйор-барберів.
CREATE VIEW InfoAboutSeniors
AS
    SELECT Id, Name + ' ' + Surname + ' ' + LastName AS 'Full name', Gender, Phone, Email, DateBirthday, HireDate, PositionId
    FROM Barbers
    WHERE PositionId = 2
GO

SELECT * FROM InfoAboutSeniors
GO

-- Повернути інформацію про всіх барберів, які можуть надати послугу традиційного гоління бороди.
CREATE VIEW ShavingBeardBarbers
AS
    SELECT B.Id, B.Name + ' ' + B.Surname + ' ' + B.LastName AS 'Full name', B.Gender, B.Phone, B.Email, B.DateBirthday, B.HireDate, B.PositionId
    FROM Services AS S, Barbers AS B JOIN BarbersServices AS BS ON BS.ServiceId = 9 AND BS.BarberId = B.Id
GO

SELECT DISTINCT * FROM ShavingBeardBarbers
GO

--Повернути інформацію про всіх барберів, які можуть надати конкретну послугу. Інформація про потрібну послугу надається як параметр.
CREATE FUNCTION Service(@service NVARCHAR(40))
RETURNS TABLE
AS
RETURN (
    SELECT B.Id, B.Name + ' ' + B.Surname + ' ' + B.LastName AS 'Full name', B.Gender, B.Phone, B.Email, B.DateBirthday, B.HireDate, B.PositionId
    FROM Barbers AS B JOIN BarbersServices AS BS ON BS.BarberId = B.Id JOIN Services AS S ON BS.ServiceId = S.Id
    WHERE S.Name = @service
);
GO

SELECT * FROM Service('ESCAPE HAIRCUT')
GO

-- Повернути інформацію про всіх барберів, які працюють понад зазначену кількість років. Кількість років передається як параметр.
CREATE FUNCTION NumberOfYears(@years INT)
RETURNS TABLE
AS
RETURN (
    SELECT Id, Name + ' ' + Surname + ' ' + LastName AS 'Full name', Gender, Phone, Email, DateBirthday, HireDate, PositionId
    FROM Barbers
    WHERE HireDate = @years
);
GO

SELECT * FROM NumberOfYears(1)
GO

-- Повернути кількість синьйор-барберів та кількість джуніор-барберів.
CREATE VIEW JuniorSenior
AS
    SELECT B.Id, B.Name + ' ' + B.Surname + ' ' + B.LastName AS 'Full name', B.Gender, B.Phone, B.Email, B.DateBirthday, B.HireDate, B.PositionId
    FROM Barbers AS B, Position AS P
    WHERE B.PositionId = 2 OR B.PositionId = 3 
GO

SELECT DISTINCT * FROM JuniorSenior
GO

-- Повернути інформацію про постійних клієнтів. Критерій постійного клієнта: був у салоні задану кількість разів. 
-- Кількість передається як параметр.
CREATE FUNCTION RegularCustomers(@amount INT)
RETURNS TABLE
AS
RETURN (
    SELECT C.Id, C.Name + ' ' + C.Surname + ' ' + C.Lastname AS 'Full name', C.Phone, C.Email, COUNT(a.ClientId) AS 'Number of times'
    FROM Clients AS C JOIN Archive AS A ON C.Id = A.ClientId
    GROUP BY C.Id, C.Name + ' ' + C.Surname + ' ' + C.Lastname , C.Phone, C.Email
    HAVING COUNT(a.ClientId) > @amount
);
GO

SELECT * FROM RegularCustomers(1)
GO

-- Заборонити можливість видалення інформації про чиф-барбер, якщо не додано другий чиф-барбер.
CREATE TRIGGER disallow_remove_cheaf
ON Barbers
FOR DELETE
AS 
    IF EXISTS (SELECT PositionId FROM deleted EXCEPT SELECT PositionId FROM Barbers)
    BEGIN 
        RAISERROR('It is not possible to delete the cheaf Barber', 12, 1)
        ROLLBACK TRANSACTION
    END;
GO    

INSERT INTO Barbers (Name, Surname, Lastname, Gender, Phone, Email, DateBirthday, HireDate, PositionId)
VALUES ('Robert', 'Smith', 'Pol', 'Male', '380958592938', 'robert.smith@gmail.com', '1999-05-19', 4, 1)
GO

-- Заборонити додавати барберів молодше 21 року.    
CREATE TRIGGER disallow_barbers
ON Barbers
AFTER INSERT
AS
    IF EXISTS (SELECT * FROM inserted AS I WHERE (SELECT DATEDIFF(year, I.DateBirthday, GETDATE())) < 21)
        BEGIN
            RAISERROR('The barber must be over 21 years old', 12, 1)
            ROLLBACK TRANSACTION
        END;
GO        

INSERT INTO Barbers (Name, Surname, Lastname, Gender, Phone, Email, DateBirthday, HireDate, PositionId)
VALUES ('Ilon', 'Musk', 'Reeve', 'Male', '380687292928', 'ilon.musk1@gmail.com', '2020-05-19', 3, 2),
       ('Bil', 'Gates', 'William', 'Male', '380982127392', 'bil.gates1@gmail.com', '2004-05-19', 7, 3)
GO