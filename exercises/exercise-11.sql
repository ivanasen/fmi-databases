-- 1
use movies;

-- 1.1
create view VNameAndBirthOfActresses
as
select NAME, BIRTHDATE
from MOVIESTAR
where GENDER = 'F';

-- 1.2
create view VMovieStarMovies
as
select NAME, COUNT(MOVIETITLE) as MovieCount
from MOVIESTAR
         left outer join STARSIN S on S.STARNAME = NAME
group by NAME;

-- 1.3
-- 1.1 - Yes
-- 1.2 - No


-- 2
use pc;

-- 2.1
create view VCodeModelPrice
as
select code, model, price
from laptop
union all
select code, model, price
from pc
union all
select code, model, price
from printer;

-- 2.2
    alter view VCodeModelPrice
    as
        select code, model, price, 'laptop' as type
        from laptop
        union all
        select code, model, price, 'pc' as type
        from pc
        union all
        select code, model, price, 'printer' as type
        from printer;

-- 2.3
    alter view VCodeModelPrice
    as
        select code, model, price, speed, 'laptop' as type
        from laptop
        union all
        select code, model, price, speed, 'pc' as type
        from pc
        union all
        select code, model, price, NULL as speed, 'printer' as type
        from printer;


-- 3
use ships;

-- 3.1
create view VBritishShips
as
select NAME, C.CLASS, C.TYPE, C.NUMGUNS, C.BORE, C.DISPLACEMENT, LAUNCHED
from SHIPS
         inner join CLASSES C on SHIPS.CLASS = C.CLASS
where COUNTRY = 'Gt.Britain';

-- 3.2
-- Showing name for readability
select NAME, NUMGUNS, DISPLACEMENT
from VBritishShips
where TYPE = 'bb'
  and LAUNCHED < 1919;

-- 3.3
select NAME, NUMGUNS, DISPLACEMENT
from SHIPS
         inner join CLASSES C on SHIPS.CLASS = C.CLASS
where C.COUNTRY = 'Gt.Britain'
  and C.TYPE = 'bb'
  and LAUNCHED < 1919;

-- 3.4
create view VMaxDisplacementByCountry
as
select COUNTRY, max(DISPLACEMENT) as MaxDisplacement
from CLASSES
group by COUNTRY;

select avg(MaxDisplacement)
from VMaxDisplacementByCountry;

-- 3.5
create view VSunkShips
as
select SHIP, BATTLE, RESULT
from OUTCOMES
where RESULT = 'sunk';

-- 3.6
insert into VSunkShips(SHIP, BATTLE, RESULT)
values ('California', 'North Cape', 'sunk');

-- 3.7
create view VAtLeast9GunsChecked
as
select *
from CLASSES
where NUMGUNS >= 9
with check option;

-- 3.8
create view VAtLeast9Guns
as
select *
from CLASSES
where NUMGUNS >= 9;

-- 3.9
create view Problem39
as
select BATTLE, COUNT(distinct SHIP) as ShipCount
from OUTCOMES
         inner join SHIPS S on S.NAME = SHIP
         inner join CLASSES C on C.CLASS = S.CLASS
where NUMGUNS < 12
group by BATTLE
having COUNT(distinct SHIP) >= 3
   and STRING_AGG(RESULT, '') LIKE '%damaged%';
