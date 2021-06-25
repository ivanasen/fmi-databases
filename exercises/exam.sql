use movies;

select TITLE, LENGTH
from MOVIE
where TITLE like 'Star%[^k]'
order by LENGTH desc, TITLE;

select S.NAME, S.ADDRESS, string_agg(M1.TITLE, ' ')
from STUDIO S
         left join MOVIE M1 on S.NAME = M1.STUDIONAME
where M1.LENGTH is NULL
   or M1.LENGTH > (select avg(M2.LENGTH)
                   from MOVIE M2
                   where M2.STUDIONAME = S.NAME)
group by S.NAME, S.ADDRESS;


-- Ако дадено студио няма филми - изкарваме NULL
select S.NAME, S.ADDRESS, M1.TITLE
from STUDIO S
         left join MOVIE M1 on S.NAME = M1.STUDIONAME
where M1.LENGTH is NULL
   or M1.LENGTH > (select avg(M2.LENGTH)
                   from MOVIE M2
                   where M2.STUDIONAME = S.NAME);


select STUDIO.NAME, COUNT(distinct M.TITLE) as MovieCount, YEAR(MIN(MOVIESTAR.BIRTHDATE)) as OldestStartBirth
from STUDIO
         left join MOVIE M on STUDIO.NAME = M.STUDIONAME
         left join STARSIN S on M.TITLE = S.MOVIETITLE and M.YEAR = S.MOVIEYEAR
         left join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
group by STUDIO.NAME
having COUNT(distinct MOVIESTAR.NAME) <= 2;

select *
from MOVIE
where STUDIONAME like 'USA%';

select *
from STARSIN
where MOVIETITLE like 'The Man%';

create trigger TrgMakeNullInsteadDelete
    on MOVIE
    instead of delete
    as
    update MOVIE
    set LENGTH     = NULL,
        STUDIONAME = NULL
    where TITLE in (select TITLE from Deleted);
go

drop trigger TrgMakeNullInsteadDelete;

select *
from MOVIE;

delete
from MOVIE
where TITLE = 'Star Trek';


select *
from MOVIE;

begin tran

delete
from MOVIE
where STUDIONAME in (select distinct STUDIONAME
                     from MOVIE
                     where INCOLOR = 'Y')
  and TITLE not in (select distinct MOVIETITLE
                    from STARSIN);

rollback tran
