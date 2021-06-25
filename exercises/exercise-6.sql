-- COLLATE Latin1_General_CS_AS
-- 1
use movies;

select *
from MOVIE
where YEAR < 1982
  and TITLE in (select MOVIETITLE
                from STARSIN
                where STARNAME like '%[^bk]%')
order by YEAR;

-- 13
use movies;

select NAME, COUNT(M.STUDIONAME)
from MOVIESTAR
         left join STARSIN S on MOVIESTAR.NAME = S.STARNAME
         left join MOVIE M on S.MOVIETITLE = M.TITLE and S.MOVIEYEAR = M.YEAR
group by NAME;

-- 4
use movies;

select *
from MOVIE M
where INCOLOR = 'n'
  and YEAR < (select min(YEAR)
              from MOVIE
              where STUDIONAME = M.STUDIONAME
                and INCOLOR = 'y');

-- 7
use ships;

select distinct BATTLE
from OUTCOMES
         inner join SHIPS S on OUTCOMES.SHIP = S.NAME
         inner join CLASSES C on S.CLASS = C.CLASS
where RESULT = 'damaged'
  and C.COUNTRY = 'Japan';

-- 20
use ships;

select CLASSES.CLASS, COUNT(S2.NAME)
from CLASSES
         inner join SHIPS S2 on CLASSES.CLASS = S2.CLASS
where CLASSES.CLASS in (select C.CLASS
                        from CLASSES C
                                 inner join SHIPS S on C.CLASS = S.CLASS
                        group by C.CLASS
                        having COUNT(S.NAME) >= 3)
  and exists(select * from OUTCOMES where SHIP = S2.NAME and RESULT = 'ok')
group by CLASSES.CLASS;

-- 19
use ships;

select NAME, COUNT(O.BATTLE) as DamagedCount
from SHIPS
         inner join OUTCOMES O on SHIPS.NAME = O.SHIP
where O.RESULT = 'damaged'
group by NAME
union
select NAME, 0 as DamagedCount
from SHIPS
         left join OUTCOMES O on SHIPS.NAME = O.SHIP
where O.RESULT is NULL
   or O.RESULT != 'damaged'
group by NAME;

-- 14
use movies;

select STARNAME, COUNT(MOVIETITLE)
from STARSIN
where MOVIEYEAR > 1990
group by STARNAME
having COUNT(MOVIETITLE) > 3;

-- 8
use ships;

select NAME, C.CLASS
from SHIPS
         inner join CLASSES C on SHIPS.CLASS = C.CLASS
where LAUNCHED = (select LAUNCHED from SHIPS where NAME = 'Rodney') + 1
  and C.NUMGUNS > (select avg(NUMGUNS)
                   from CLASSES
                   where COUNTRY = C.COUNTRY
                   group by COUNTRY);