-- Функція користувача повертає вітання в стилі
-- «Hello, ІМ'Я!» Де ІМ'Я передається як параметр. 
-- Наприклад, якщо передали Nick, то буде Hello, Nick!
CREATE FUNCTION HelloFuncc(@name NVARCHAR(30))
RETURNS NVARCHAR(30) 
AS
BEGIN
    RETURN 'Hello, ' + @name;
END
GO

SELECT dbo.HelloFuncc('Julia') AS 'Hello function'
GO

-- Функція користувача повертає інформацію про поточну кількість хвилин;
CREATE FUNCTION CountMinutes()
RETURNS INT
AS
BEGIN
    DECLARE @d INT = DATEPART(minute, GETDATE());
    RETURN @d;
END
GO

SELECT dbo.CountMinutes() AS 'Minute Part'
GO

-- Функція користувача повертає інформацію про поточний рік;
CREATE FUNCTION CurrentYear()
RETURNS INT
AS
BEGIN
    DECLARE @d INT = DATEPART(year, GETDATE());
    RETURN @d;
END
GO

SELECT dbo.CurrentYear() AS 'Current Year'
GO

-- Функція користувача повертає інформацію про те: парний або непарний рік;
CREATE FUNCTION EvenOddYear(@year int)
RETURNS BIT
AS
BEGIN
    DECLARE @evenOdd BIT
    IF(@year % 2 = 0)
        SET @evenOdd = 1
    ELSE  
        SET @evenOdd = 0
    RETURN @evenOdd      
END
GO

SELECT dbo.EvenOddYear(2023) AS 'Even or odd year'
GO

-- Функція користувача приймає число і повертає yes, якщо число просте і no, якщо число не просте;
CREATE FUNCTION PrimeOrNotPrime(@number INT)
RETURNS BIT
AS
BEGIN
    DECLARE @IsPrime bit, @Divider int
     IF (@number % 2 = 0 AND @number > 2)
        SET @IsPrime = 0
    ELSE
        SET @IsPrime = 1 
    SET @Divider = 3
    WHILE (@Divider <= floor(sqrt(@number))) AND (@IsPrime = 1)
      BEGIN
            IF @number % @Divider = 0
                SET @IsPrime = 0
            SET @Divider = @Divider + 2
      END  
      RETURN @IsPrime
END      
GO

SELECT dbo.PrimeOrNotPrime(5) AS 'Prime number or not'
GO

-- Функція користувача приймає як параметри п'ять чисел. 
-- Повертає суму мінімального та максимального значення з переданих п'яти параметрів;
ALTER FUNCTION MinMaxNumbers(@n1 INT, @n2 INT, @n3 INT, @n4 INT, @n5 INT)
RETURNS INT
AS
BEGIN
    RETURN LEAST(@n1, @n2, @n3, @n4, @n5)+GREATEST(@n1, @n2, @n3, @n4, @n5)
END
GO

SELECT dbo.MinMaxNumbers(3, 6, 11, 12, 1) as 'Sum of min&max numbers'