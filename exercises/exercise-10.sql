-- 1
use movies;

-- a)
-- Remove duplicates
delete
from MOVIE
where TITLE in (
    select MAX(TITLE)
    from MOVIE
    group by LENGTH
    having count(*) > 1);

alter table MOVIE
    add constraint UC_LENGTH unique (LENGTH);

-- b)
alter table MOVIE
    add constraint UC_LENGTH_STUDIONAME unique (LENGTH, STUDIONAME);

-- 2
alter table MOVIE
    drop constraint UC_LENGTH;

alter table MOVIE
    drop constraint UC_LENGTH_STUDIONAME;


-- 3
-- a), b) and c)
create table Student
(
    FacultyNumber  int primary key check (FacultyNumber >= 0 and FacultyNumber <= 99999),
    Name           nvarchar(100)        not null,
    Egn            char(10) unique      not null,
    Email          nvarchar(100) unique not null check (Email like '%@%.%'),
    Birthdate      date                 not null,
    AcceptanceDate date                 not null,
    check (datediff(year, Birthdate, AcceptanceDate) > 18 or
           (datediff(year, Birthdate, AcceptanceDate) = 18
               and month(AcceptanceDate) >= month(Birthdate)
               and day(AcceptanceDate) >= day(Birthdate))),
);

create table Course
(
    Number int primary key,
    Name   nvarchar(100)
);

create table CourseParticipants
(
    Course    int,
    StudentFN int,
    constraint CourseParticipantsPK
        primary key (Course, StudentFN),
    constraint CourseFK
        foreign key (Course) references Course (Number)
            on delete cascade,
    constraint StudentFK
        foreign key (StudentFN) references Student (FacultyNumber)
);

-- no action
--  cascade
-- set null
-- set default
