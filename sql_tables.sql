---------------- PACKAGES
--1 команда. Делаем базу данных master активной с помощью оператора use
use master
--2 команда. Выводим на экран всю информацию из системной таблицы sysobjects
select *
from sysobjects
-- Посылаем на сервер пакет из двух команд для обработки
go

---------------- ALTER TABLE
-- изменяєм поле NullCol типа nvarchar(20)
alter table MyTable 
	alter column NullCol nvarchar(20) not null
-- добавить дополнительное разряженное поле test, яке оптимізує пам'ять для збереження NULL - значень
-- (рекомендується при наявності NULL-значень 40-60%)
alter table MyTable
	add NewColumn char(100) sparse null;
-- превращаем разряженное поле test в неразряженное
alter table MyTable
	alter column NewColumn drop sparse;

---------------- DROP TABLE
DROP TABLE [имя_БД.][схема.] название_таблицы [ ,...n ] 
-- например
drop table test1;
drop table testdb.dbo.test2;

---------------- SET PRIMARY KEY (PK)
-- 1. Путем установления конструкции для поля при первичном создании таблицы:
create table Table1(
	id_test1 int identity not null primary key,
    -- .............. ,
);
-- 2. Путем установления конструкции для поля при первичном создании таблицы после объявления всех полей
create table Table1(
	id_test1 int identity not null,
    --.............. ,
    constraint PK_Table1 primary key(id_test1)
);
-- 3. Путем модификации уже существующей таблицы, то есть когда таблица создана, а первичный ключ еще не задан
alter table Тest1
	add constraint pkTable1 primary key(id_test1);

---------------- DROP PRIMARY KEY
alter table Тest1
	drop constraint pkTable1 primary key(id_test1);

---------------- SET FOREIGN KEY (FK)
-- 1. Путем установления конструкции для поля при первичном создании таблицы:
create table test2 (id_test2 integer not null primary key,
                    id_test1 integer not null constraint FK_Test2_1 references Test1 (id_test1));
-- или
create table test2 (id_test2 integer not null primary key,
                    id_test1 integer not null references Test1 (id_test1));
-- 2. Путем установления конструкции для поля при первичном создании таблицы после объявления всех полей
create table Students (Id integer not null primary key,
					   GroupId integer not null, 
					   constraint FK_Students_Group foreign key (GroupId) references Groups(Id))
-- 3. Путем модификации уже существующей таблицы, то есть когда таблица создана, а вторичный ключ еще не задан
alter table test2
	add constraint fkTest2_1 foreign key (id_test2) references Test1 (id_test1)

alter table Orders
	drop constraint FK_PersonOrder;

---------------- FOREIGN KEY ACTIONS
/*
    [ON DELETE { NO ACTION | CASCADE | SET DEFAULT | SET NULL }]
    [ON UPDATE { NO ACTION | CASCADE | SET DEFAULT | SET NULL }]

    No Action (default) - забороняє видалення, поки існують зв'язки
    Cascade - відбувається видалення залежних елементів
    Set Null - встановлює значення NULL для залежних елементів
    Set Default - встановлює значення за замовчуванням для залежних елементів
*/
create table test2 ( id_test2 integer not null primary key, 
                     id_test1 integer not null,
    constraint fkTest2_1 foreign key (id_test2) references Test1 (id_test1)
    on delete set null
    on update cascade )

---------------- INSERT INTO TABLE
-- данные добавляются в таблицу в соответствии с их физическим порядком
INSERT INTO Students
VALUES (1, 'Леся', 'Поваренко', 1);
-- данные добавляются только в определенные поля,
-- а недостающие в списке наполняются NULL значениями,
-- значениями по умолчанию, а для полей с типом IDENTITY
-- или rowversion (timestamp) новые значения будут сгенерированы самостоятельно
INSERT INTO Students(fname, sname, id_group) 
VALUES ('Вова', 'Писаренко', 2),
       ('Олег', DEFAULT, 2);
-- добавить новую строку заполнен значение по умолчанию
INSERT INTO Students
    DEFAULT VALUES;

---------------- DELETE FROM TABLE
-- удалить все записи таблицы Students

select * from Students
delete
    from Students;
-- удалить из базы данных студентов с именем Вова
delete
    from Students
    where Name = 'Nat';

TRUNCATE TABLE [имя_БД.][схема.] название_таблицы 
-- например
truncate table Groups;

---------------- UPDATE TABLE
-- заменить имя студента с именем Вова на Вован
update Students
    set Name = 'Olegaaa' 
    where Name = 'Oleg';
-- снижаем текущую цену на овсяное печенье на 20% и устанавливаем новое значение скидки
update Product
    set price = price * 0.2,
        discount = 0.2
    where name = 'Овсяное печенье';