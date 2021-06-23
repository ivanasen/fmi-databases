-- 1
create database test;
use test;

-- 2
create table Product
(
    maker nchar(1),
    model nchar(4),
    type  nvarchar(7)
);

create table Printer
(
    code  int,
    model nchar(4),
    color char(1) default 'n',
    price decimal(10, 2),
    constraint color check (color in ('y', 'n'))
);

create table Classes
(
    class nvarchar(50),
    type  char(2),
    constraint type check (type in ('bb', 'bc'))
);

-- 3
insert into Product(maker, model, type)
values ('A', '1000', 'Printer');

insert into Printer(code, model)
values (123, '1000');

insert into Classes(class, type)
values ('Bismarck', 'bb');

-- 4
alter table Classes
    add bore FLOAT;

-- 5
alter table Printer
    drop column price;

-- 5
use master;
drop database test;
