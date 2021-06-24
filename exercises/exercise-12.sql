-- 1
use movies;

-- 1.1
insert into MOVIESTAR(NAME, ADDRESS, GENDER, BIRTHDATE)
values ('Bruce Willis', '-', 'M', '1855/6/6');
go

create trigger TrgBruceWillis
    on MOVIE
    after insert
    as
    insert into STARSIN(MOVIETITLE, MOVIEYEAR, STARNAME)
    select TITLE, YEAR, 'Bruce Willis'
    from Inserted
    where TITLE like '%save%'
       or TITLE like '%world%';
go

-- 1.2
create trigger TrgMinimumNetworth
    on MOVIEEXEC
    after insert, update
    as
    if EXISTS(select *
              from Inserted
              where NETWORTH < 500000)
        begin
            print ('Networth should be >= 500 000');
            rollback;
        end;
go

-- 1.3
create trigger TrgOnDeleteMovieExecSetNull
    on MOVIEEXEC
    instead of delete
    as
    delete
    from MOVIE
    where PRODUCERC# in (select CERT# from deleted);
    delete
    from MOVIEEXEC
    where CERT# in (select CERT# from deleted);
go

-- 1.4
create trigger TrgCreateWhenInsertInStarsIn
    on STARSIN
    instead of insert
    as
    insert into MOVIE(TITLE, YEAR)
    select MOVIETITLE, MOVIEYEAR
    from Inserted
    where MOVIETITLE not in (select TITLE from MOVIE)
       or MOVIEYEAR not in (select distinct YEAR from MOVIE);

    insert into MOVIESTAR(NAME)
    select STARNAME
    from Inserted
    where STARNAME not in (select NAME from MOVIESTAR);

    insert into STARSIN
    select *
    from Inserted;
go
drop trigger TrgCreateWhenInsertInStarsIn;
go


-- 2
use pc;

-- 2.1
create trigger TrgOnDeleteLaptopCreatePc
    on laptop
    after delete
    as
    insert into pc(code, model, speed, ram, hd, cd, price)
    select code + 100, '1121', speed, ram, hd, '52x', price
    from Deleted
             inner join product p on p.model = Deleted.model
    where p.maker = 'A'; -- wil make it with 'A'
go

drop trigger TrgOnDeleteLaptopCreatePc;

-- 2.2
create trigger TrgOnPriceChange
    on pc
    after update
    as
    if exists(select *
              from Inserted i
              where exists(select code
                           from pc
                           where i.code != code
                             and i.speed = speed
                             and i.price > price))
        begin
            rollback
        end;
go

drop trigger TrgOnPriceChange;

-- 2.3
create trigger TrgForbidPcMakersMakingPrinters
    on product
    after insert
    as
    if exists(select maker
              from Inserted
              where type = 'PC'
                and maker in (select maker from product where type = 'Printer'))
        begin
            rollback
        end;
go

drop trigger TrgForbidPcMakersMakingPrinters;

-- 2.4
create trigger TrgPcAndLaptops
    on pc
    after insert
    as
    if exists(select *
              from Inserted i
                       inner join product p on p.model = i.model
              where not exists(select *
                               from laptop
                                        inner join product p2 on p2.model = laptop.model
                               where p2.maker = p.maker
                                 and laptop.speed >= i.speed))
        begin
            rollback
        end;
go

drop trigger TrgPcAndLaptops;

-- 2.5
create trigger TrgAveragePriceLaptops
    on laptop
    after insert, update, delete
    as
    if exists(select maker
              from laptop
                       inner join product p on laptop.model = p.model
              group by maker
              having avg(price) < 2000)
        begin
            rollback
        end
go

drop trigger TrgAveragePriceLaptops;

-- 2.6
create trigger TrgMoreRamAndMoreExpensive
    on laptop
    after insert, update
    as
    if exists(select *
              from Inserted i
              where exists(select *
                           from pc
                           where pc.ram < i.ram
                             and pc.price > i.price))
        begin
            rollback
        end;
go

drop trigger TrgMoreRamAndMoreExpensive;

-- 2.7
create trigger TrgColoredMatrixForbidden
    on printer
    instead of insert
    as
    insert into printer
    select *
    from Inserted
    where color != 'y'
      and type != 'Matrix'
go

drop trigger TrgColoredMatrixForbidden;


-- 3
use ships;

-- 3.1
create trigger TrgMaxDisplacementFixer
    on CLASSES
    instead of insert
    as
    insert into CLASSES
    select CLASS, TYPE, COUNTRY, NUMGUNS, BORE, DISPLACEMENT
    from Inserted
    where DISPLACEMENT < 35000
    union
    select CLASS, TYPE, COUNTRY, NUMGUNS, BORE, 35000
    from Inserted
    where DISPLACEMENT >= 35000;
go

drop trigger TrgMaxDisplacementFixer;

-- 3.2
create view VClassesAndShipCount
as
select C.CLASS, COUNT(*) as ShipCount
from CLASSES C
         left join SHIPS S on S.CLASS = C.CLASS
group by C.CLASS;

create trigger TrgDeleteClassAndAllShips
    on VClassesAndShipCount
    instead of delete
    as
    delete O
    from OUTCOMES O
             inner join SHIPS S on O.SHIP = S.NAME
    where S.CLASS in (select CLASS from Deleted);
    delete
    from SHIPS
    where CLASS in (select CLASS from Deleted);
    delete
    from CLASSES
    where CLASS in (select CLASS from Deleted)
go

drop trigger TrgDeleteClassAndAllShips;

-- 3.3
create trigger TrgMax2Ships
    on SHIPS
    after insert, update
    as
    if exists(select C.CLASS, COUNT(S.NAME)
              from CLASSES C
                       inner join SHIPS S on C.CLASS = S.CLASS
              group by C.CLASS
              having COUNT(S.CLASS) > 2)
        begin
            rollback
        end
go

drop trigger TrgMax2Ships;

-- 3.4
create trigger Trg9Guns
    on OUTCOMES
    after insert, update
    as
    if exists(select *
              from Inserted I
                       inner join SHIPS S1 on S1.NAME = I.SHIP
                       inner join CLASSES C1 on C1.CLASS = S1.CLASS
                       inner join OUTCOMES O on O.BATTLE = I.BATTLE
                       inner join SHIPS S2 on S2.NAME = O.SHIP
                       inner join CLASSES C2 on C2.CLASS = S2.CLASS
              where (C1.NUMGUNS > 9 and C2.NUMGUNS < 9)
                 or (C1.NUMGUNS < 9 and C2.NUMGUNS > 9))
        begin
            rollback
        end;
go

drop trigger Trg9Guns;

-- 3.5
create trigger TrgCantBeLaunchedAfterSunkOutcomes
    on OUTCOMES
    after insert, update
    as
    if exists(select *
              from Inserted I
                       inner join SHIPS S on S.NAME = I.SHIP
                       inner join BATTLES B on B.NAME = I.BATTLE
              where cast(S.LAUNCHED as varchar(20)) + '/1/1' > B.DATE)
        begin
            rollback
        end;
go

create trigger TrgCantBeLaunchedAfterSunkShips
    on SHIPS
    after update
    as
    if exists(select *
              from Inserted I
                       inner join OUTCOMES O on O.SHIP = I.NAME
                       inner join BATTLES B on B.NAME = O.BATTLE
              where cast(I.LAUNCHED as varchar(20)) + '/1/1' > B.DATE)
        begin
            rollback
        end;
go

drop trigger TrgCantBeLaunchedAfterSunkOutcomes;
drop trigger TrgCantBeLaunchedAfterSunkShips;
