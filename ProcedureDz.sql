-- процедура виводить «Hello, world!»;
CREATE PROCEDURE HelloWorld
AS
BEGIN
	PRINT 'Hello, World'
END
EXECUTE HelloWorld
GO

-- процедура повертає інформацію про поточний час;
CREATE PROCEDURE CurrentTime
@res TIME OUTPUT
AS
BEGIN
	DECLARE @time_now TIME = CAST(GETDATE() AS time);
	SET @res = @time_now
END
GO

DECLARE @time TIME
EXEC CurrentTime @time OUTPUT
PRINT @time
GO

-- процедура повертає інформацію про поточну дату;
CREATE PROCEDURE CurrentDate
@res DATE OUTPUT
AS 
BEGIN
	DECLARE @date_now DATE = CAST(GETDATE() AS DATE);
	SET @res = @date_now
END
GO

DECLARE @date DATE
EXEC CurrentDate @date OUTPUT
PRINT @date
GO

-- процедура приймає три числа і повертає їхню суму;
CREATE PROCEDURE Sum 
@a INT,
@b INT,
@c INT,
@res INT OUTPUT
AS
BEGIN
	SET @res = @a + @b + @c
END
GO

DECLARE @out_value INT = 0
EXEC Sum 4, 2, 6, @out_value OUTPUT
PRINT @out_value
GO

-- процедура приймає три числа і повертає середньоарифметичне трьох чисел;
CREATE PROCEDURE Average
@a INT,
@b INT,
@c INT,
@res INT OUTPUT
AS
BEGIN
	SET @res = @a + @b + @c / 3
END
GO

DECLARE @out_value INT = 0
EXEC Average 1, 8, 4, @out_value OUTPUT
PRINT @out_value
GO

-- процедура приймає три числа і повертає максимальне значення;
CREATE PROCEDURE Max 
@a INT,
@b INT,
@c INT,
@max INT OUTPUT
AS
BEGIN
	SET @max = @a
	IF(@b > @max) 
		SET @max = @b
	IF(@c > @max) 
		SET @max = @c
END
GO

DECLARE @out_value INT = 0
EXEC Max 9, 2, 4, @out_value OUTPUT
PRINT @out_value
GO

-- процедура приймає три числа і повертає мінімальне значення;
CREATE PROCEDURE Min 
@a INT,
@b INT,
@c INT,
@min INT OUTPUT
AS
BEGIN
	SET @min = @a
	IF(@b < @min) 
		SET @min = @b
	IF(@c < @min) 
		SET @min = @c
END
GO

DECLARE @out_value INT = 0
EXEC Min 9, 2, 4, @out_value OUTPUT
PRINT @out_value
GO

-- процедура приймає число та символ. В результаті роботи збереженої процедури відображається лінія довжиною, 
-- що дорівнює числу. Лінія побудована із символу, вказаного у другому параметрі. 
-- Наприклад, якщо було передано 5 та #, ми отримаємо лінію такого виду #####;
CREATE PROCEDURE Symbol
@number INT,
@symbol NVARCHAR(100)
AS
BEGIN
	PRINT REPLICATE(@symbol, @number)
END
GO

EXECUTE Symbol 7, #
GO

-- процедура приймає як параметр число і повертає його факторіал. 
-- Формула розрахунку факторіалу: n! = 1 * 2 * ... n. 
-- Наприклад, 3! = 1 * 2 * 3 = 6;
CREATE PROCEDURE GetValueFactorial
@factorial INT = 1,
@num INT
AS
BEGIN
	IF @num <> 0
		WHILE @num > 0
			BEGIN
				SET @factorial = @factorial * @num
				SET @num = @num - 1
			END
	SELECT @factorial
END
GO

DECLARE @out_value INT = 0
EXEC GetValueFactorial 3, 3
PRINT @out_value
GO

-- процедура приймає два числові параметри. 
-- Перший параметр – це число. Другий параметр – це ступінь. 
-- Процедура повертає число, зведене до ступеня. 
-- Наприклад, якщо параметри дорівнюють 2 і 3, 
-- тоді повернеться 2 у третьому ступені, тобто 8.
CREATE PROCEDURE Pow 
@number INT,
@pow INT,
@res INT OUTPUT
AS
BEGIN
	IF @pow <> 0
		SET @res = POWER(@number, @pow)
END
GO

DECLARE @out_value INT = 0
EXEC Pow 2, 3, @out_value OUTPUT
PRINT @out_value