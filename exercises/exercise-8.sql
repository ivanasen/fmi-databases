-- 1
USE movies;

-- 1.1
BEGIN TRAN

INSERT INTO MOVIESTAR(NAME, BIRTHDATE)
VALUES ('Nicole Kidman', '1967-06-20');

ROLLBACK TRAN

-- 1.2
BEGIN TRAN

INSERT INTO MOVIEEXEC(NAME, NETWORTH)
VALUES ('Gosho', 10);

SELECT *
FROM MOVIEEXEC
WHERE NETWORTH < 10000000;

DELETE
FROM MOVIEEXEC
WHERE NETWORTH < 10000000;

ROLLBACK TRAN

-- 1.3
BEGIN TRAN

INSERT INTO MOVIESTAR(NAME)
VALUES ('Gosho');

SELECT *
FROM MOVIESTAR
WHERE ADDRESS IS NULL;

DELETE
FROM MOVIESTAR
WHERE ADDRESS IS NULL;

ROLLBACK TRAN

-- 1.4
BEGIN TRAN

SELECT *
FROM MOVIEEXEC;

-- Don't know where this info for president is
UPDATE MOVIEEXEC
SET NAME = 'Pres. ' + NAME;

ROLLBACK TRAN


-- 2
use pc;

-- 2.1 and 2.2

select *
from product;
select *
from pc;

insert into product(maker, model, type)
values ('C', 1100, 'PC');

insert into pc(code, model, speed, ram, hd, cd, price)
values (12, 1100, 2400, 2048, 500, '52x', 299);

delete
from product
where model = 1100;
delete
from pc
where model = 1100;

-- 2.3
begin tran

insert into laptop
select code, model, speed, ram, hd, price + 500 as price, 15 as screen
from pc;

select *
from laptop;

rollback tran

-- 2.4
begin tran

select *
from laptop
         inner join product p on laptop.model = p.model;

select *
from printer
         inner join product p on printer.model = p.model;

delete l
from laptop l
         inner join product p on l.model = p.model
where p.maker not in (select distinct maker
                      from printer
                               inner join product p2 on printer.model = p2.model);

rollback tran

-- 2.5
begin tran

select *
from product;

update product
set maker = 'A'
where maker = 'B';

rollback tran

-- 2.6
begin tran

select *
from pc;

update pc
set price = price / 2,
    hd += 20;

rollback tran

-- 2.7
begin tran

select *
from laptop
         inner join product p on laptop.model = p.model
where p.maker = 'B';

update l
set screen += 1
from laptop l
         inner join product p on l.model = p.model
where p.maker = 'B';

rollback tran


-- 3
use ships;

-- 3.1
select *
from CLASSES;

insert into CLASSES(class, type, country, numguns, bore, displacement)
values ('Nelson - Nelson', 'bb', 'Gt.Britain', 9, 16, 34000),
       ('Rodney', 'bb', 'Gt.Britain', 9, 16, 34000);

insert into SHIPS (NAME, CLASS, LAUNCHED)
values ('pesho', 'Nelson - Nelson', 1927),
       ('gosho', 'Rodney', 1927);

-- 3.2
begin tran

select *
from SHIPS
         inner join OUTCOMES o on o.SHIP = SHIP
where o.RESULT = 'sunk';

delete s
from SHIPS s
         inner join OUTCOMES o on o.SHIP = SHIP
where o.RESULT = 'sunk';

rollback tran

-- 3.3
begin tran

select *
from CLASSES;

update CLASSES
set BORE *= 2.54,
    DISPLACEMENT *= 1.1;

rollback tran

-- 3.4
begin tran

SELECT C.CLASS
from CLASSES C
         inner join SHIPS S on C.CLASS = S.CLASS
group by C.CLASS
having COUNT(*) < 3;

delete
from CLASSES
where CLASS in
      (SELECT C.CLASS
       from CLASSES C
                inner join SHIPS S on C.CLASS = S.CLASS
       group by C.CLASS
       having COUNT(*) < 3);

rollback tran

-- 3.5
begin tran

select *
from CLASSES c1
         inner join CLASSES c2 on c2.CLASS = 'Bismarck'
where c1.CLASS = 'Iowa';

update iowa
set iowa.BORE = bismarck.BORE
from CLASSES iowa
         inner join CLASSES bismarck on bismarck.CLASS = 'Bismarck'
where iowa.CLASS = 'Iowa';

rollback tran

-- ALTER TABLE table_name
-- ADD column_name datatype;