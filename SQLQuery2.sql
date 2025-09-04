--1 tund
-- 03.09.2025

--loome andmebaasi
create database TITpe23

-- db kustutamine
drop database TITpe23

-- tabeli loomine
create table Gender
(
Id int not null primary key,
Gender nvarchar(10) not null
)

--andmete sisestamine
insert into Gender (Id, Gender)
values (1, 'Male')
insert into Gender (Id, Gender)
values (2, 'Female')
insert into Gender (Id, Gender)
values (3, 'Unknown')

--vaatame tabeli sisu
select * from Gender

--teha tabel nimega Person
--seal peavad olema muutujad Id int not null primary key,
-- Name nvarchar(30),
-- Email nvarchar(30),
-- GenderId int

create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--andmete sisestamine
insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 1),
(2, 'Wonderwoman', 'w@w.com', 2),
(3, 'Batman', 'b@b.com', 1),
(4, 'Hulk', 'h@h.com', 1),
(5, 'Catwoman', 'c@c.com', 2),
(6, 'Antman', 'ant"ant.com', 1),
(8, NULL, NULL, 1)

select * from Person

--v��rv�tme �henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--- kui sisestad uue rea andmeid ja ei ole sisestanud 
--- GenderId alla v��rtust, siis see automaatselt sisestab 
--- sellele reale v��rtuse 3-e nagu meil on unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Person (Id, Name, Email)
values (9, 'Black Panther', 'p@p.com')

select * from Person

-- piirangu kustutamine
alter table Person
drop constraint DF_Persons_GenderId

-- lisame veeru tabelisse
alter table Person
add Age nvarchar(10)

--lisame nr piirangu vanuse sisestamisel
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

insert into Person (Id, Name, Email, GenderId, Age)
values (10, 'Dr Doom', 's@s.com', 1, 154)

select * from Person

-- kuidas uuendada andmeid
update Person
set Age = 50
where Id = 7

--lisada uus veerg Person tabelisse
--veeru nimi on City nvarchar(50)
alter table Person
add City nvarchar(50)

--k�ik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k�ik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'
-- k�ik, kes ei ela Gothamis, variant nr 2. Tee ise
select * from Person where City != 'Gotham'

-- n�itab teatud vanusega inimesi
select * from Person where Age = 40 or Age = 154 or Age = 21
select * from Person where Age in (154, 40, 21)

-- n�itab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 22 and 41

-- wildcardi e n�itab k�ik g-t�hega linnad
select * from Person where City like 'n%'

--otsida emailid, kus on olemas @-m�rk
select * from Person where Email like '%@%'

-- n�itab k�iki, kellel ei ole @-m�rki emailis
select * from Person where Email not like '%@%'

--n�itab, kellel on emailis ees ja peale @-m�rki ainult �ks t�ht
select * from Person where Email like '_@_.com'

--k]ik, kellel nimes ei ole esimene t�ht W, A, S
select * from Person where Email like '[^WAS]%'

-- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

--- k�ik, kes elavad Gothamis ja New Yorkis ning on vanemad, kui 29a
select * from Person where (City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab t�hestikulises j�rjekorras inimesi ja v�tab aluseks nime
select * from Person order by Name
-- kuvab vastupidises j�rjestuses
select * from Person order by Name desc

--v�tab kolm esimest rida
select top 3 * from Person

-- rida 131
-- 04.09.2025
-- tund 2

-- kolm esimest, aga tabeli j�rjestus on Age ja siis Name
select * from Person
select top 3 Age, Name from Person

-- n'ita esimesed 50% tabelis
select top 50 percent * from Person

--j�rjestab vanuse j�rgi isikud
select * from Person order by Age desc

--v�tab neli esimest ja j�rjestab vanuse j�rgi
select top 4 * from Person order by Age

-- muudab Age muutuja intiks ja n�itab vanuselises j�rjestuses
select * from Person order by cast(Age as int)

-- k�ikide isikute koondvanus
select sum(cast(Age as int)) from Person

--kuvab k�ige nooremat isikut
select min(cast(Age as int)) from Person
--kuvab k�ige vanemat isikut
select max(cast(Age as int)) from Person

-- n�eme konkreetsetes linnades olevate isikute koondvanust
-- enne oli Age string, aga enne p�ringut muutsime selle int-ks
select City, sum(Age) as TotalAge from Person group by City 

--kuidas saab koodiga muuta andmet��pi ja selle pikkust
--vaja muuta Name nvarchar(25) peale
alter table Person
alter column Name nvarchar(25)

--- kuvab esimeses reas v�lja toodud j�rjestuses ja kuvab Age-i TotalAge-ks
--- j�rjest City-s olevate nimede j�rgi ja siis genderId j�rgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

--n�itab, et mitu rida on selles tabelis
select count(*) from Person
select * from Person

-- tahame tulemust, et mitu inimest on genderId v��rtusega 2
-- konkreetses linnas ja arvutab vanuse kokku
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total person(s)]
from Person
where GenderId = '1'
group by GenderId, City

--n�itab �ra inimeste koondvanuse, mis on �le 41 a ja 
--kui palju neid igas linnas elab 
--eristab inimese soo j�rgi �ra
select GenderId, City, sum(Age) as TotalAge, count(Id)
as [Total Person(s)]
from Person
group by GenderId, City having sum(Age) > 41

-- loome tabelid Employees ja Department
--Department tabelis peavad olema muutujad:
--Id int primary key,
--DepartmentName nvarchar(50),
--Location nvarchar(50),
--DepartmentHead nvarchar(50)

--Employees tabelis peavad olema muutujad:
--Id int primary key,
--Name nvarchar(50),
--Gender nvarchar(50),
--Salary nvarchar(50),
--DepartmentId int

create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

--- join p�ring
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

select sum(cast(Salary as int)) from Employees  --arvutab k]ikide palgad kokku

-- min palga saaja ja kui panen min asemele max, siis max palga saaja
select min(cast(Salary as int)) from Employees

--[he kuu l�ikes palgafond linnade l�ikes
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location 

-- lisame Employees tabelisse City veeru ja peab olema nvarchar(30)
alter table Employees
add City nvarchar(30)

-- rida 257
--tund 3

