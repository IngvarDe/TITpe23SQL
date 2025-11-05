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

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--- kui sisestad uue rea andmeid ja ei ole sisestanud 
--- GenderId alla väärtust, siis see automaatselt sisestab 
--- sellele reale väärtuse 3-e nagu meil on unknown
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

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- kõik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'
-- kõik, kes ei ela Gothamis, variant nr 2. Tee ise
select * from Person where City != 'Gotham'

-- näitab teatud vanusega inimesi
select * from Person where Age = 40 or Age = 154 or Age = 21
select * from Person where Age in (154, 40, 21)

-- näitab teatud vanusevahemikus olevaid inimesi
select * from Person where Age between 22 and 41

-- wildcardi e näitab kõik g-tähega linnad
select * from Person where City like 'n%'

--otsida emailid, kus on olemas @-märk
select * from Person where Email like '%@%'

-- näitab kõiki, kellel ei ole @-märki emailis
select * from Person where Email not like '%@%'

--näitab, kellel on emailis ees ja peale @-märki ainult üks täht
select * from Person where Email like '_@_.com'

--k]ik, kellel nimes ei ole esimene täht W, A, S
select * from Person where Email like '[^WAS]%'

-- kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

--- kõik, kes elavad Gothamis ja New Yorkis ning on vanemad, kui 29a
select * from Person where (City = 'Gotham' or City = 'New York')
and Age >= 30

--- kuvab tähestikulises järjekorras inimesi ja võtab aluseks nime
select * from Person order by Name
-- kuvab vastupidises järjestuses
select * from Person order by Name desc

--võtab kolm esimest rida
select top 3 * from Person

-- rida 131
-- 04.09.2025
-- tund 2

-- kolm esimest, aga tabeli järjestus on Age ja siis Name
select * from Person
select top 3 Age, Name from Person

-- n'ita esimesed 50% tabelis
select top 50 percent * from Person

--järjestab vanuse järgi isikud
select * from Person order by Age desc

--võtab neli esimest ja järjestab vanuse järgi
select top 4 * from Person order by Age

-- muudab Age muutuja intiks ja näitab vanuselises järjestuses
select * from Person order by cast(Age as int)

-- kõikide isikute koondvanus
select sum(cast(Age as int)) from Person

--kuvab kõige nooremat isikut
select min(cast(Age as int)) from Person
--kuvab kõige vanemat isikut
select max(cast(Age as int)) from Person

-- näeme konkreetsetes linnades olevate isikute koondvanust
-- enne oli Age string, aga enne päringut muutsime selle int-ks
select City, sum(Age) as TotalAge from Person group by City 

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
--vaja muuta Name nvarchar(25) peale
alter table Person
alter column Name nvarchar(25)

--- kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i TotalAge-ks
--- järjest City-s olevate nimede järgi ja siis genderId järgi
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId order by City

--näitab, et mitu rida on selles tabelis
select count(*) from Person
select * from Person

-- tahame tulemust, et mitu inimest on genderId väärtusega 2
-- konkreetses linnas ja arvutab vanuse kokku
select GenderId, City, sum(Age) as TotalAge, count(Id) as [Total person(s)]
from Person
where GenderId = '1'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja 
--kui palju neid igas linnas elab 
--eristab inimese soo järgi ära
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

--- join päring
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id

select sum(cast(Salary as int)) from Employees  --arvutab k]ikide palgad kokku

-- min palga saaja ja kui panen min asemele max, siis max palga saaja
select min(cast(Salary as int)) from Employees

--[he kuu lõikes palgafond linnade lõikes
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
--10.09.2025
select* from Employees

select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees 
group by City, Gender
--tahame ainult Employees tabelist näha City ja Gender veergu

--sama nagu eelmine, aga linnad tähestikulises järjestuses
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees 
group by City, Gender
order by City

--loeb ära, et mitu rida on tabelis
select count(*) from Employees

--teil tuleb teada saada, et mitu töötajat on soo ja linna kaupa
select Gender, City, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees
group by Gender, City

--kuvab ainult kõik mehede linnade
select Gender, City, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employees(s)]
from Employees
where Gender = 'Female'
group by Gender, City

select Gender, City, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employees(s)]
from Employees
group by Gender, City
having Gender = 'Female'

select * from Employees where sum(cast(Salary as int)) > 4000
-- k]igil, kellel on palk [le 4000 ja arvutab need kokku ning n'itab soo kaupa
--kasutada having-t
select Gender, City, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employees(s)]
from Employees
group by Gender, City
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1

-- kustutame veeru nimega City Employees tabelis
alter table Employees
drop column City

--- inner join
--- kuvab neid, kellel on DepartmentName all olemas v''rtus
--- kasutada Department ja Employees
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
--kuidas saada k]ik andmed Employee-st k'tte
select Name, Gender, Salary, DepartmentName
from Employees
left join Department  -- võib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

-- right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department  -- võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--outer join
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department  -- võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id

--p'ringu sisu
--select ColumnList
--from LeftTable
--joinType RightTable
--on JoinCondition e võõrvõti ja primaarvõti ühendatakse ära

--inner join
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--kasutada left joini ja kuidas saada teada, et kellel on DepartmentName NULL
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--teine variant
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null

--kuidas saame Department tabelis oleva rea, kus on NULL
--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--full join
--mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

select * from Department

--saame muuta tabeli nimetust, alguses vana tabeli nimi ja siis uus soovitud
sp_rename 'Department1' , 'Department'

--kasutame Employees tabeli asemel lühendit E ja M
select E.Name as Employee, M.Name as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--teha veerg ja nimeks ManagerId ning andmetüüp on int
alter table Employees
add ManagerId int

--inner join
--kuvab ainult managerId all olevate isikute väärtused
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--kõik saavad kõikide ülemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

select isnull('Asd', 'No Manager') as Manager

--NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

--neil kellel ei ole ülemust, siis paneb neile No Manager teksti
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--rida 428
--4 tund
--11.09.2025

-- teeme p'ringu, kus kasutame case-i
select E.Name as Employee, case when M.Name is null then 'No Manager'
else M.Name end as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--lisame tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)
alter table Employees
add LastName nvarchar(30)

select * from Employees

--muudame veeru nime
sp_rename 'Employees.Name', 'FirstName'

--kasutate update ja t'itke samamoodi nagu on minul
-- muudame ja lisame andmeid
update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3

update Employees
set FirstName = 'Sam', MiddleName = NULL, LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

select * from Employees

--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
--
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

-- loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame andmed tabelisse
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutame union all, mis n'itab kõiki ridu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kasutada union all-i ja sorteerida nime järgi tulemus
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--sp esile kutsumine
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--miks ei lähe see sp tööle
--nõuab Gender parameetrit
spGetEmployeesByGenderAndDepartment
--õige variant
spGetEmployeesByGenderAndDepartment 'Male', 1
--- niimoodi saab sp tahetud järjekorrast mööda minna, kui ise paned muutujad paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

--saab sp sisu vaadata result-i vaates
sp_helptext spGetEmployeesByGenderAndDepartment

-- kuidas muuta sp-d ja võti peale panna, et keegi teine peale teie ei saaks muuta
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
with encryption -- paneb võtme peale
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

-- teeme sp, kus loendab töötajad ära läbi Id ja liigitab soo kaupa ära
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end
-- uus p'ring
declare @TotalCount int
execute spGetEmployeeCountByGender 'asd', @TotalCount out
if(@TotalCount = 0)
	print 'TotalCount is null'
else
	print '@TotalCount is not null'
print @TotalCount

--n'itab ära, et mitu rida vastab nõuetele
declare @TotalCount int
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Male'
print @TotalCount

-- sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info
sp_help Employees
-- kui soovid sp helptexti n'ha
sp_helptext spGetEmployeeCountByGender

-- vaatame, millest sp s]ltub
sp_depends spGetEmployeeCountByGender
--vaatame tabeli sõltuvust
sp_depends Employees

-- sp mille muutujateks on Id ja Name nvarchar(20) output
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

--annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = count(Id) from Employees
end

--saame teada, et mitu rida andmeid on tabelis
declare @TotalEmployees int
execute spTotalCount2 @TotalEmployees output
select @TotalEmployees

--mis id all on keegi nime j'rgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(50) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end
-- annab tulemuse, kus id real nr 1 on keegi koos nimega
declare @FirstName nvarchar(50)
execute spGetNameById1 4, @FirstName output
print 'Name of the employee = ' + @FirstName
-- 
declare @FirstName nvarchar(2)
execute spGetNameById1 4, @FirstName output
print 'Name  = ' + @FirstName

sp_help spGetNameById
--
create proc spGetNameById2
@Id int
as begin
	return (select FirstName from Employees where Id = @Id)
end
--tuleb veateade kuna kutsusime välja int-i, aga Pam on string
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 2
print 'Name of the employee = ' + @EmployeeName

--sisseehitatud string funktsioonid
--see konverteerib ASCII tähe väärtuse numbriks
select ascii('a')

--prindime kogu tähestiku välja
declare @Start int
set @Start = 97
while (@Start <= 122)
begin
	select char (@Start)
	set @Start = @Start + 1
end

--rida 699
-- 5 tund
--18.09.2025

--eemaldame tühjad kohad sulgudes vasakul pool
select ltrim('        Hello')
--paremalt poolt
select RTRIM('        Hello      ')
--tühikute eemaldamine veerust

select * from Employees

--teha p'ring Employee tabeli vastu ja tahan näha Eesnime, Keskmistnime ja perekonnanime.
--Eesnimel ei oleks tühikuid ees
select ltrim(FirstName) as FirstName, MiddleName, LastName from Employees

-- keerab kooloni sees olevad andmed vastupidiseks
-- vastavalt upper ja lower-ga saan muuta märkide suurust
-- reverse funktsioon pöörab kõik ümber
select REVERSE(upper(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
RTRIM(LTRIM(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--näeb, mitu tähte on sõnal ja loeb tühikud sisse
select FirstName, len(FirstName) as [Total Characters] from Employees
--n'eb, mitu tähte on sõnal ja ei loe tühikuid sisse
select FirstName, len(ltrim(FirstName)) as [Total Characters] from Employees

---left, right, substring
-- vasakult poolt neli esimest tähte
select left('ABCDEF', 4)
--paremalt poolt kolm t'hte
select right('ABCDEF', 3)

--kuvab @-tähemärgi asetust
select CHARINDEX('@', 'sara@aaa.com')

--esimene nr peale komakohta n'itab, et mitmendast alustab ja siis mitu nr peale seda kuvada
select SUBSTRING('pam@bbb.com', 5, 2)

-- @-märgist kuvab kolm tähemärki. Viimase nr saab määrata pikkust
select substring('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

--- peale @-m'rki reguleerin tähemärkide pikkuse näitamist
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 2,
len('pam@bbb.com') - charindex('@', 'pam@bbb.com'))

-- saame teada domeeninimed emailides
select SUBSTRING(Email, charindex('@', Email) + 1,
len (Email) - CHARINDEX('@', Email)) as EmailDomain
from Employees

alter table Employees
add Email nvarchar(20)

update Employees set Email = 'Tom@aaa.com' where Id = 1
update Employees set Email = 'Pam@bbb.com' where Id = 2
update Employees set Email = 'John@aaa.com' where Id = 3
update Employees set Email = 'Sam@bbb.com' where Id = 4
update Employees set Email = 'Todd@bbb.com' where Id = 5
update Employees set Email = 'Ben@ccc.com' where Id = 6
update Employees set Email = 'Sara@ccc.com' where Id = 7
update Employees set Email = 'Valarie@aaa.com' where Id = 8
update Employees set Email = 'James@bbb.com' where Id = 9
update Employees set Email = 'Russel@bbb.com' where Id = 10

--lisame *-märgiga teatud kohast
select FirstName, LastName,
	substring(Email, 1, 2) + REPLICATE('*', 5) + --peale teist m'rki paneb viis tärni
	substring(Email, CHARINDEX('@', Email), len(Email) - CHARINDEX('@', Email) + 1) as Email
from Employees

--kolm korda näitab strinfgis olevat väärtust
select REPLICATE('asd', 3)

--kuidas sisestada tühikut kahe nime vahele
select space(5)

--tühikute arv peab olema 25 eesnime ja perekonnanime vahel
--need kaks muutujat tuleb panna ühte veergu FullName veerunime all
--andmed tuleb võtta Employee tabelist
select FirstName + space(25) + LastName as FullName
from Employees

--PATINDEX
--sama, mis CHARINDEX, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0

--kõik .com-d asendatakse .net-ga
--Employee tabeli vastu peab päringu tegema
select Email, replace(Email, '.com', '.net') as ConvertedEmail
from Employees

--soovin asendada peale esimest märki kolm tähte viie tärniga
--kasutada stuff
select FirstName, LastName, Email,
	stuff(Email, 2, 3, '*****') as StuffedEmail
from Employees

-- datetime tabel
create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

--masina kellaaeg
select GETDATE(), 'GETDATE()'

insert into DateTime
values (getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

select * from DateTime

update DateTime set c_datetimeoffset = '2025-09-18 18:52:26.0400000 +01:00'
where c_datetimeoffset = '2025-09-18 18:52:26.0400000 +00:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja p'ring
select SYSDATETIME(), 'SYSDATETIME()' --veel t'psem aja p'ring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET()' -- täpne aeg koos ajalise nihkega UTC suhtes
select GETUTCDATE(), 'GETUTCDATE()' --UTC aeg


select ISDATE('asd')  --tagastab 0 kuna string ei ole date
select ISDATE(getdate()) --tagastab 1 kuna on kp
select isdate('2025-09-18 18:52:26.04000000')-- tagastab o kuna max kolm komakohta võib olla
select isdate('2025-09-18 18:52:26.040') --tagastab 1
select day(getdate()) --annab jooksva kuupäeva nr
select day('01/22/2017') --annab stringis oleva kp ja j'rjestus peab olema õige
select month(getdate()) --annab jooksva kuu nr
select month('01/22/2017') --annab stringis oleva kuu ja j'rjestus peab olema õige
select year(getdate()) --annab jooksva kuu nr
select year('01/22/2017') --annab stringis oleva kuu ja j'rjestus peab olema õige

select datename(day, '2025-09-18 18:52:26.040') --annab stringis oleva p'eva nr
select datename(weekday, '2025-09-18 18:52:26.040') --annab stringis oleva päeva sõnana
select datename(Month, '2025-09-18 18:52:26.040') --annab stringis oleva kuu sõnana

---rida 845
-- 6 tund
-- 24.09.2025

create table EmployeesWithDates
(
Id nvarchar(2),
Name nvarchar(20),
DateOfBirth datetime
)

INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (1, 'Sam', '1980-12-30 00:00:00.000');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (2, 'Pam', '1982-09-01 12:02:36.260');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (3, 'John', '1985-08-22 12:03:30.370');
INSERT INTO EmployeesWithDates  (Id, Name, DateOfBirth)  
VALUES (4, 'Sara', '1979-11-29 12:59:30.670');

select * from EmployeesWithDates

-- kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud
select Name, DateOfBirth, DATENAME(WEEKDAY, DateOfBirth) as [Day],
	   MONTH(DateOfBirth) as MonthNumber,
	   DATENAME(MONTH, DateOfBirth) as [MonthName],
	   YEAR(DateOfBirth) as [Year]
from EmployeesWithDates

select DATEPART(WEEKDAY, '2025-09-20 12:59:30.670')-- kuvab 7 kuna USA nädal algab pühapäevaga
select DATEPART(month, '2025-09-20 12:59:30.670')  --kuvab kuu nr
select DATEADD(day, 20, '2025-09-20 12:59:30.670')  --liidab stringis olevale kp 20 päeva juurde
select DATEADD(day, -20, '2025-09-20 12:59:30.670')  --lahutab -20 päeva
select DATEDIFF(MONTH, '11/30/2025', '01/31/2025')  --kuvab kahe stringi kuudevahelise aega nr-na
select DATEDIFF(YEAR, '11/30/2020', '01/31/2025') --kuvab kahe stringi aastavahelist aega nr-na

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
	declare @tempdate datetime, @years int, @months int, @days int
	select @tempdate = @DOB

	select @years = DATEDIFF(year, @tempdate, getdate()) - case when (MONTH(@DOB) > MONTH(getdate())) or (month(@DOB)
	= month(getdate()) and day(@DOB) > day(GETDATE())) then 1 else 0 end
	select @tempdate = dateadd(year, @years, @tempdate)

	select @months = datediff(MONTH, @tempdate, GETDATE()) - case when day(@DOB) > DAY(GETDATE()) then 1 else 0 end
	select @tempdate = DATEADD(MONTH, @months, @tempdate)

	select @days = DATEDIFF(day, @tempdate, getdate())

	declare @Age nvarchar(50)
		set @Age = cast(@years as nvarchar(4)) + ' Years ' + cast(@months as nvarchar(2)) + ' Months ' 
		+ cast(@days as nvarchar(2)) + ' days old'
	return @Age
end

--saame vaadata kasutajate vanust
select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeesWithDates

select dbo.fnComputeAge('11/11/2020')

--nr peale DOB muutujat n'itab, et mismoodi kuvada DOB-d
select Id, Name, DateOfBirth,
convert(nvarchar, DateOfBirth, 110) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id] from EmployeesWithDates

select cast(GETDATE() as date) -- tänane kp
select convert(date, getdate()) -- tänane kp

select abs(-101.5) ---abs on absoluutne nr ja tulemuseks saame ilma miinus m'rgita tulemuse
select ceiling(15.2)---tagastab 16 ja suurendab suurema täisarvu suunas
select ceiling(-15.2)---tagastab -15 ja suurendab suurema positiivse täisarvu suunas
select floor(15.2)--- ümardab negatiivsema nr poole
select floor(-15.2) --- ümardab negatiivsema nr poole
select POWER(2, 4) -- hakkab korrutama 2x2x2x2, esimene nr on korrutatav
select SQUARE(9) -- antud juhul 9 ruudus
select sqrt(81) -- annab vastuse 9, ruutjuur

select rand() --annab suvaliuse nr
select floor(rand()* 100)  --- korrutab sajaga iga suvalisue nr

--iga kord näitab 10 suvalist nr-t
declare @counter int
set @counter = 1
while (@counter <= 10)
	begin
		print floor(rand() * 1000)
		set @counter = @counter + 1
	end

select ROUND(850.556, 2)	-- ümardab kaks kohta peale komat, tulemus 850.560
select ROUND(850.556, 2, 1)	-- ümardab allapoole, tulemus 850.550
select ROUND(850.556, 1)	-- ümardab ülespoole ja võtab ainult esimest nr peale koma arvesse 850.600 
select ROUND(850.556, 1, 1)	-- ümardab allapoole
select ROUND(850.556, -2)	-- ümardab täisnr ülesse
select ROUND(850.556, -1)	-- ümardab täisnr allapoole

--create function
create function dbo.CalculateAge(@DOB date)
returns int
as begin
declare @Age int

set @Age = DATEDIFF(year, @DOB, GETDATE()) -
	case
		when (MONTH(@DOB) > MONTH(GETDATE())) or
			 (MONTH(@DOB) > MONTH(GETDATE()) and day(@DOB) > day(getdate()))
		then 1
		else 0 
		end
	return @Age
end

execute dbo.CalculateAge '10/08/2020'

--arvutab välja, kui vana on isik ja võtab arvesse kuud ja päevad
--antud juhul näitab kõike, kes on üle 36 a vanad
select Id, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 36

-- inline table valued functions
alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

update EmployeesWithDates set Gender = 'Male', DepartmentId = 1
where Id = 1
update EmployeesWithDates set Gender = 'Female', DepartmentId = 2
where Id = 2
update EmployeesWithDates set Gender = 'Male', DepartmentId = 1
where Id = 3
update EmployeesWithDates set Gender = 'Female', DepartmentId = 3
where Id = 4
insert into EmployeesWithDates (Id, Name, DateOfBirth, DepartmentId, Gender)
values (5, 'Todd', '1978-11-29 12:59:30.670', 1, 'Male')

select * from EmployeesWithDates

-- scalare function annab mingis vahemikus olevaid andmeid, aga
-- inline table values ei kasuta begin ja end funktsioone
-- scalar annab väärtused ja inline annab tabeli 
create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeesWithDates
		where Gender = @Gender)

--kõik female töötajad
select * from fn_EmployeesByGender('Female')

select * from fn_EmployeesByGender('Female')
where Name = 'Pam'

-- rida 1007
-- 25.09.2025
-- 7 tund

-- kahest erinevast tabelist andmete võtmine ja koos kuvamine
-- esimene on funktsioon ja teine tabel
select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId


--inline funktsiooni
create function fn_GetEmployees()
returns table as
return (Select Id, Name, cast(DateOfBirth as date)
		as DOB
		from EmployeesWithDates)

select * from fn_GetEmployees()

-- multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, Name, Cast(DateOfBirth as date) from EmployeesWithDates

	return
end

select * from fn_MS_GetEmployees()

--mis inline funktsiooni ja multi erinevused e eelised ja puudused
--- inline tabeli funktsioonid on paremini töötamas kuna käsitletakse vaatena
--- multi puhul on pm tegemist stored proceduriga ja kulutab ressurssi rohkem

update fn_GetEmployees() set Name = 'Sam1' where Id = 1 -- saab muuta andmeid
update fn_MS_GetEmployees() set Name = 'Sam2' where Id = 1  -- multi puhul ei saa andmeid muuta

--deterministic ja non-deterministic 

select count(*) from  EmployeesWithDates
select SQUARE(3) --k]ik tehtemärgid on ettemääratud funktsioonid, sinna kuuluvad veel sum, avg ja square

--mitte ettemääratud
select GETDATE()
select CURRENT_TIMESTAMP
select rand() --see funktsioon saab olla mõlemas kategoorias, kõik oleneb sellest, kas sulgudes on 1 või ei ole


--loome funktsiooni, mille nimeks on fn_GetNameById
--tagastab nvarchar(30)
create function fn_GetNameById(@id int)
returns nvarchar(30)
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end

select dbo.fn_GetNameById(3)

--kustuta kogu tabel
drop table EmployeesWithDates

create table EmployeesWithDates
(
Id int primary key,
Name nvarchar(50) NULL,
DateOfBirth datetime NULL,
Gender nvarchar(10) NULL,
DepartmentId int NULL
)

select * from EmployeesWithDates

insert into EmployeesWithDates values(1, 'Sam', '1980-12-30 00:00:00.000', 'Male', 1)
insert into EmployeesWithDates values(2, 'Pam', '1982-09-01 12:02:36.260', 'Female', 2)
insert into EmployeesWithDates values(3, 'John', '1985-08-22 12:03:30.370', 'Male', 1)
insert into EmployeesWithDates values(4, 'Sara', '1979-11-29 12:59:30.670', 'Female', 3)
insert into EmployeesWithDates values(5, 'Todd', '1978-11-29 12:59:30.670', 'Male', 1)

create function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end

sp_helptext fn_GetEmployeeNameById

--kr[pteerige funktsioon nimega fn_GetEmployeeNameById ära
alter function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @Id)
end


create function fn_GetEmployeeNameById(@Id int)
returns nvarchar(20)
with schemabinding
as begin
	return (select Name from dbo.EmployeesWithDates where Id = @Id)
end

--ei saa kustutada tabelit, kui funktsioon on seal küljes
drop table dbo.EmployeesWithDates

--temporary tables

--- #-märgi ette panemisel saame aru, et tegemist on temp table-ga
--- seda tabelit saab ainult selles päringus avada
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails

select Name from sysobjects
where Name like '#PersonDetails%'

--kustuta temp tabel
drop table #PersonDetails

--teha stored procedure, kus luuakse temp table nimega #PersonDetails
-- ja sisestatakse andmed:
--insert into #PersonDetails values(1, 'Mike')
--insert into #PersonDetails values(2, 'John')
--insert into #PersonDetails values(3, 'Todd')
create proc spCreateLocalTempTable
as begin
create table #PersonDetails(Id int, Name nvarchar(20))

insert into #PersonDetails values(1, 'Mike')
insert into #PersonDetails values(2, 'John')
insert into #PersonDetails values(3, 'Todd')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--tehke globaalne tabel, koos kahe muutujaga
create table ##PersonDetails(Id int, Name nvarchar(20))

--index
create table EmployeeWithSalary
(
Id int primary key,
Name nvarchar(25),
Salary int,
Gender nvarchar(10)
)

insert into EmployeeWithSalary values
(1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary

select * from EmployeeWithSalary
where Salary > 5000 and Salary < 7000

--loome indeksi, mis asetab palga kahanevasse j'rjestusse
create index IX_Employee_Salary
on EmployeeWithSalary (Salary asc)

--indksi välja kutsumine
select * from EmployeeWithSalary with (index (IX_Employee_Salary))

--saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--saame vaadata tabelit koos selle sisuga alates v'ga detailsest infost
select 
	TableName = t.Name,
	IndexName = ind.name,
	IndexId = ind.index_id,
	ColumnId = ic.index_column_id,
	ColumnName = col.name,
	ind.*,
	ic.*,
	col.*
FROM
     sys.indexes ind 
INNER JOIN 
     sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN 
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
WHERE 
     ind.is_primary_key = 0 
     AND ind.is_unique = 0 
     AND ind.is_unique_constraint = 0 
     AND t.is_ms_shipped = 0 
ORDER BY 
     t.name, ind.name, ind.index_id, ic.is_included_column, ic.key_ordinal;

--indeksi kustutamine
drop index EmployeeWithSalary.IX_Employee_Salary

---- indeksi tüübid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Täistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veergudega indeksid

-- klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse 
-- ja selle tulemusel saab tabelis olla ainult üks klastris olev indeks

create table EmployeeCity
(
Id int primary key,
Name nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)

-- andmete õige järjestuse loovad klastris olevad indeksid ja kasutab selleks Id nr-t
-- põhjus, miks antud juhul kasutab Id-d, tuleneb primaarvõtmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

-- klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis 
-- ja seda saab klastrite puhul olla ainult üks

select * from EmployeeCity

create clustered index IX_EmployeeCity_Name
on EmployeeCity(Name)

--- annab veateate, et tabelis saab olla ainult üks klastris olev indeks
--- kui soovid, uut indeksit luua, siis kustuta olemasolev

--- saame luua ainult ühe klastris oleva indeksi tabeli peale
--- klastris olev indeks on analoogne telefoni suunakoodile

-- loome composite indeksi
-- enne tuleb kõik teised klastris olevad indeksid ära kustutada
create clustered index IX_Employee_Gender_Salary
on EmployeeCity(Gender desc, Salary asc)
-- kui teed select päringu sellele tabelile, siis peaksid nägema andmeid, mis on järjestatud selliselt:
-- Esimeseks võetakse aluseks Gender veerg kahanevas järjestuses ja siis Salary veerg tõusvas järjestuses
select * from EmployeeCity 

--mitte klastris olev indesk
create nonclustered index IX_EmployeeCity_Name
on EmployeeCity(Name)
--teeme p'ringu tabelile
select * from EmployeeCity

--- erinevused kahe indeksi vahel
--- 1. ainult üks klastris olev indeks saab olla tabeli peale, 
--- mitte-klastris olevaid indekseid saab olla mitu
--- 2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi viitama tabelile
--- Juhul, kui selekteeritud veerg ei ole olemas indeksis
--- 3. Klastris olev indeks määratleb ära tabeli ridade slavestusjärjestuse
--- ja ei nõua kettal lisa ruumi. Samas mitte klastris olevad indeksid on 
--- salvestatud tabelist eraldi ja nõuab lisa ruumi

create table EmployeeFirstName
(
Id int primary key,
FirstName nvarchar(50),
LastName nvarchar(50),
Salary int,
Gender nvarchar(10),
City nvarchar(50)
)

exec sp_helpindex EmployeeFirstName
--ei saa sisestada kahte samagusue Id v''rtusega rida
--peab saama sisestama andmed just sellisel kujul nagu on allpool kirjas
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

drop index EmployeeFirstName.PK__Employee__3214EC07CD193801
--- kui käivitad ülevalpool oleva koodi, siis tuleb veateade
--- et SQL server kasutab UNIQUE indeksit jõustamaks väärtuste unikaalsust ja primaarvõtit
--- koodiga Unikaalseid Indekseid ei saa kustutada, aga käsitsi saab

-- sisestame uuesti kaks koodirida andmeid
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'John', 'Menco', 2500, 'Male', 'London')

create unique nonclustered index UIX_Employee_Firstname_Lastname
on EmployeeFirstName(FirstName, LastName)
-- alguses annab veateate, et Mike Sandoz-st on kaks korda
-- ei saa lisada mitte-klastris olevat indeksit, kui ei ole unikaalseid andmeid
--- kustutame tabeli ja sisestame andmed uuesti
truncate table EmployeeFirstName

insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(2, 'John', 'Menco', 2500, 'Male', 'London')

--lisame uue unikaalse piirnagu
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstName_City
unique nonclustered(City)

insert into EmployeeFirstName values(3, 'John', 'Menco', 3500, 'Male', 'London')

-- saab vaadata indeksite nimekirja
exec sp_helpconstraint EmployeeFirstName

-- 1.Vaikimisi primaarvõti loob unikaalse klastris oleva indeksi, samas unikaalne piirang
-- loob unikaalse mitte-klastris oleva indeksi
-- 2. Unikaalset indeksit või piirangut ei saa luua olemasolevasse tabelisse, kui tabel 
-- juba sisaldab väärtusi võtmeveerus
-- 3. Vaikimisi korduvaid väärtusied ei ole veerus lubatud,
-- kui peaks olema unikaalne indeks või piirang. Nt, kui tahad sisestada 10 rida andmeid,
-- millest 5 sisaldavad korduviad andmeid, siis kõik 10 lükatakse tagasi. Kui soovin ainult 5
-- rea tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis selleks kasutatakse IGNORE_DUP_KEY

--koodin'ide>
create unique index IX_EmployeeFirstName
on EmployeeFirstname(City)
with ignore_dup_key

truncate table EmployeeFirstname

insert into EmployeeFirstName values(3, 'John', 'Menco', 3500, 'Male', 'London')
insert into EmployeeFirstName values(4, 'John', 'Menco', 3512, 'Male', 'London1')
insert into EmployeeFirstName values(4, 'John', 'Menco', 3345, 'Male', 'London1')
--- enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga
--- nüüd läks keskmine rida läbi kuna linna nimi oli unikaalne

select * from EmployeeFirstName

--rida 1358
-- 8 tund
-- 01.10.2025

--view

--view on salvestatud SQL-i päring. Saab käsitleda ka virtuaalse tabelina

select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--loome view
create view vEmployeesByDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

--view p'ringu esile kutsumine
select * from vEmployeesByDepartment

-- view ei salvesta andmeid vaikimisi
-- seda tasub võtta, kui salvestatud virtuaalse tabelina

-- milleks vaja:
-- saab kasutada andmebaasi skeemi keerukuse lihtsutamiseks,
-- mitte IT-inimesele
-- piiratud ligipääs andmetele, ei näe kõiki veerge

--teha veerg, kus näeb ainult IT-töötajaid
--see peab olema view ja kasutama joini
-- view nimi on vITEmployeesInDepartment
alter view vITEmployeesInDepartment
as
select FirstName, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id
where Department.DepartmentName = 'IT'
-- ülevalpool olevat päringut saab liigitada reataseme turvalisuse alla
-- tahan ainult näidata IT osakonna töötajaid

select * from vITEmployeesInDepartment

--saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid
--view, mis tagastab summeeritud andmeid
create view vEmployeesCountByDepartment
as
select DepartmentName, count(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--kui soovid vaadata view sisu
sp_helptext vEmployeesCountByDepartment

--muuta 
alter view ViewNimi
--kustutada
drop view vEmployeesCountByDepartment

--view uuendused
--kas läbi view saab uuendada andmeid??

--teeme andmete uuenduse, aga enne tuleb teha view
create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees

--muudame Tom eesnimeks Tom123
update vEmployeesDataExceptSalary
set [FirstName] = 'Tom123' where Id = 1

--kustutame andmeid ja kasutame view-d
delete from vEmployeesDataExceptSalary where Id = 2
--sisestame läbi view andmeid juurde
--Id 2, Gender Female, DeptId 2, Name Pam
insert into vEmployeesDataExceptSalary (Id, Gender, DepartmentId, FirstName)
values(2, 'Female', 2, 'Pam')

select * from vEmployeesDataExceptSalary

--indekseeritud view
--MS SQL-s on indekseeritud view nime all ja
--Oracle-s materjaliseeritud view

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)
select * from Product

create table ProductSales
(
Id int,
QuantitySold int
)
select * from ProductSales

--loome view, mis annab meile veerud TotalSales ja TotalTransaction
--sum, isnull, count_big
create view vTotalSalesTransactionProduct
with schemabinding
as
select Name,
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
count_big(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name

--- kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
-- 1. view tuleb luua koos schemabinding-ga
-- 2. kui lisafunktsioon select list viitab väljendile ja selle tulemuseks
-- võib olla NULL, siis asendusväärtus peaks olema täpsustatud. 
-- Antud juhul kasutasime ISNULL funktsiooni asendamaks NULL väärtust
-- 3. kui GroupBy on täpsustatud, siis view select list peab
-- sisaldama COUNT_BIG(*) väljendit
-- 4. Baastabelis peaksid view-d olema viidatud kahesosalie nimega
-- e antud juhul dbo.Product ja dbo.ProductSales.

select * from vTotalSalesTransactionProduct

--paneb selle view t'hestikulisse j'rjestusse
create unique clustered index UIX_vTotalSalesByProduct_Name
on vTotalSalesTransactionProduct(Name)

--view piirangud
create view vEmployeeDetails
@Gender nvarchar(20)
as
select Id, FirstName, Gender, DepartmentId
from Employees
where Gender = @Gender
--vaatesse ei saa kaasa panna parameetreid e antud juhul Gender

create function fnEmployeeDetails(@Gender nvarchar(20))
returns table
as return
(select Id, FirstName, Gender, DepartmentId
from Employees where Gender = @Gender)

--funktsiooni esile kutsumine koos parameetritega
select * from fnEmployeeDetails('male')

--teha view nimega vEmployeeDetailsSorted
--kasutada order by-d
create view vEmployeeDetailsSorted
as
select Id, FirstName, Gender, DepartmentId
from Employees
order by Id
--order by-d ei saa kasutada

--teha globaalne temp table
--muutujad on Id, Name, Gender
--sisestada neli rida andmeid
create table ##TestTempTable(Id int, FirstName nvarchar(20), Gender nvarchar(10))

insert into ##TestTempTable values(101, 'Martin', 'Male')
insert into ##TestTempTable values(102, 'Joe', 'Female')
insert into ##TestTempTable values(103, 'Pam', 'Female')
insert into ##TestTempTable values(104, 'James', 'Male')

--sisestame andmed
create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
--temp tabelit ei saa kasutada view-s

-- Triggerid

-- DML trigger
--- kokku on kolme tüüpi: DML, DDL ja LOGON

--- trigger on stored procedure eriliik, mis automaatselt käivitub, kui mingi tegevus 
--- peaks andmebaasis aset leidma

--- DML - data manipulation language
--- DML-i põhilised käsklused: insert, update ja delete

-- DML triggereid saab klasifitseerida  kahte tüüpi:
-- 1. After trigger (kutsutakse ka FOR triggeriks)
-- 2. Instead of trigger (selmet trigger e selle asemel trigger)

--- after trigger käivitub peale sündmust, kui kuskil on tehtud insert, update ja delete

-- loome tabeli
create table EmployeeAudit
(
Id int identity(1,1) primary key,
AuditData nvarchar(1000)
)

--peale iga t;;taja sisestamist tahame teada saada t;;taja Id-d, p'eva ning aega(millal sisestati)
--k]ik andmed tulevad EmployeeAudit tabelisse
create trigger trEmployeeForInsert
on Employees
for insert
as begin
	declare @Id int
	select @Id = Id from inserted
	insert into EmployeeAudit
	values ('New employee with Id = ' + cast(@Id as nvarchar(5)) + ' is added at '
	+ cast(GETDATE() as nvarchar(20)))
end

select * from Employees
insert into Employees values (11, 'Male', 3000, 1, 3, 'Bob', 'Blob', 'Bomb', 'bob@bomb.com')
select * from Employees
select * from EmployeeAudit

--delete trigger
--kasutame Employees tabelit
--kui kustutakse andmeid siis salvesta tegevus EmployeeAudit
create trigger trEmployeeForDelete
on Employees
for delete
as begin
	declare @Id int
	select @Id = Id from deleted

	insert into EmployeeAudit
	values('An existing employee with Id =  ' + cast(@Id as nvarchar(5)) + ' is deleted at '
	+ CAST(GETDATE() as nvarchar(20)))
end

delete from Employees where Id = 11

---rida 1633
--- tund 9
-- 02.10.2025

create trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20), @NewLastName nvarchar(20)
	declare @OldEmail nvarchar(50), @NewEmail nvarchar(50)
	
	--muutuja, kuhu läheb lõpptekst
	declare @AuditString nvarchar(1000)

	--laeb kõik uuendatud andmed temp table alla
	select * into #TempTable
	from inserted

	--käib läbi kõik andmed temp tabelis
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		--selekteerib esimese rea andmed temp tabelist
		select top 1 @Id = Id, @NewGender = Gender,
		@NewSalary = Salary, @NewDepartmentId = DepartmentId,
		@NewManagerId = ManagerId, @NewFirstName = FirstName,
		@NewMiddleName = MiddleName, @NewLastName = LastName,
		@NewEmail = Email
		from #TempTable
		-- võtab vanad andmed kustutatud tabelist
		select @OldGender = Gender,
		@OldSalary = Salary, @OldDepartmentId = DepartmentId,
		@OldManagerId = ManagerId, @OldFirstName = FirstName,
		@OldMiddleName = MiddleName, @OldLastName = LastName,
		@OldEmail = Email
		from deleted where Id = @Id

		--loob auditi stringi dünaamiliselt
		set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
		if(@OldGender <> @NewGender)
			set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' +
			@NewGender

		if(@OldSalary <> @NewSalary)
			set @AuditString = @AuditString + ' Salary from ' + cast(@OldSalary as nvarchar(20)) + ' to ' 
			+ cast(@NewSalary as nvarchar(10))

		if(@OldDepartmentId <> @NewDepartmentId)
			set @AuditString = @AuditString + ' DepartmentId from ' + cast(@OldDepartmentId as nvarchar(20)) + ' to ' 
			+ cast(@NewDepartmentId as nvarchar(10))

		if(@OldManagerId <> @NewManagerId)
			set @AuditString = @AuditString + ' ManagerId from ' + cast(@OldManagerId as nvarchar(20)) + ' to ' 
			+ cast(@NewManagerId as nvarchar(10))

		if(@OldFirstName <> @NewFirstName)
			set @AuditString = @AuditString + ' Firstname from ' + @OldFirstName + ' to ' +
			@NewFirstName

		if(@OldMiddleName <> @NewMiddleName)
			set @AuditString = @AuditString + ' Middlename from ' + @OldMiddleName + ' to ' +
			@NewMiddleName

		if(@OldLastName <> @NewLastName)
			set @AuditString = @AuditString + ' Lastname from ' + @OldLastName + ' to ' +
			@NewLastName

		if(@OldEmail <> @NewEmail)
			set @AuditString = @AuditString + ' Email from ' + @OldEmail + ' to ' +
			@NewEmail

		insert into dbo.EmployeeAudit values (@AuditString)
		--kustutab temp tabelest rea, et saaksime liikuda uue rea juurde
		delete from #TempTable where Id = @Id
	end
end

--uuendame t;;taja andmeid, mille Id on 10
--muudate ta nime, palka ja keskmist nime
update Employees set FirstName = 'testasd', Salary = 4001, MiddleName = '456asd'
where Id = 10

--p'rid tabelit Employees ja EmployeeAudit ka samal ajal
select * from Employees
select * from EmployeeAudit

--instead of trigger
create table Employee
(
Id int primary key,
Name nvarchar(30),
Gender nvarchar(10),
DepartmentId int
)

-- kellel ei ole seda tabelit, siis nemad sisestavad selle koodi
create table Department
(
Id int primary key,
DepartmentName nvarchar(20)
)

insert into Employee values(1, 'John', 'Male', 3)
insert into Employee values(2, 'Mike', 'Male', 2)
insert into Employee values(3, 'Pam', 'Female', 1)
insert into Employee values(4, 'Todd', 'Male', 4)
insert into Employee values(5, 'Sara', 'Female', 1)
insert into Employee values(6, 'Ben', 'Male', 3)

select * from Employee

create view vEmployeeDetails
as
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Employee.DepartmentId = Department.Id

select * from vEmployeeDetails

insert into vEmployeeDetails values(7, 'Valarie', 'Female', 'IT')
--tuleb veateade
--nüüd vaatame, et kuidas saab instead of triggeriga seda probleemi lahendada

create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert
as begin
	declare @DeptId int

	select @DeptId = dbo.Department.Id
	from Department
	join inserted
	on inserted.DepartmentName = Department.DepartmentName

	if(@DeptId is null)
		begin
		raiserror('Invalid department name. Statement terminated', 16, 1)
		return
	end

	insert into dbo.Employee(Id, Name, Gender, DepartmentId)
	select Id, Name, Gender, @DeptId
	from inserted
end

--- raiserror funktsioon
-- selle eesmärk on tuua välja veateade, kui DepartmentName veerus ei ole väärtust
-- ja ei klapi uue sisestatud väärtusega. 
-- Esimene on parameeter ja veateate sisu, teine on veataseme nr (nr 16 tähendab üldiseid vigu),
-- kolmas on olek

delete from Employee where Id = 6

update vEmployeeDetails
set Name = 'Johny', DepartmentName = 'IT'
where Id = 1
--ei saa uuendada andmeid kuna mitu tabelit on sellest m]jutataud

update vEmployeeDetails
set DepartmentName = 'IT'
where Id = 1

select * from vEmployeeDetails

--teha trigger nimega tr_vEmployeeDetails_InsteadOfUpdate
--see peab olema instead of update t[[pi

--teha update

create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin

	if(update(Id))
	begin
		raiserror('Id cannot be changed', 16, 1)
		return
	end

	if(update(DepartmentName))
	begin
		declare @DeptId int
		select @DeptId = Department.Id
		from Department
		join inserted
		on inserted.DepartmentName = Department.DepartmentName

		if(@DeptId is null)
		begin
			raiserror('Invalid department name', 16, 1)
			return
		end

		update Employee set DepartmentId = @DeptId
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(UPDATE(Gender))
	begin
		update Employee set Gender = inserted.Gender
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(UPDATE(Name))
	begin
		update Employee set Name = inserted.Name
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end
end

--teha uuendus Id = 1
--muuta Name, genderit ja DeptId

update Employee set Name = 'John123', Gender = 'Male', DepartmentId = 3
where Id = 1

select * from vEmployeeDetails

--tuleb teha view, mille nimi on vEmployeeCount
--peab kokku arvutama, et mitu t;;tajat on tabelis teatud osakondades

create view vEmployeeCount
as
select DepartmentId, DepartmentName, count(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId


select * from vEmployeeCount

--n'ita ära osakonnad, kus on töötajaid 2tk või rohkem
select DepartmentName, TotalEmployees from vEmployeeCount
where TotalEmployees >= 2

--kasutame temp tabelit
select DepartmentName, DepartmentId, count(*) as TotalEmployees
into #TempEmployeeCount
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from #TempEmployeeCount

--n'ita ära osakonnad, kus on töötajaid 2tk või rohkem, aga kasuta #TempEmployeeCount
select DepartmentName, TotalEmployees from #TempEmployeeCount
where TotalEmployees >= 2

--teeme view, et kasutada seda triggeris 'ra
create view vEmployeeDetails
as
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Employee.DepartmentId = Department.Id

--kustutame 'ra triggeri
drop trigger tr_vEmployeeDetails_InsteadOfUpdate

--teha instead of delete trigger
--kasutada vEmployeeDetails
create trigger trEmployeeDetails_InsteadOfdDelete
on vEmployeeDetails
instead of delete
as begin
delete Employee
from Employee
join deleted
on Employee.Id = deleted.Id
end

delete from vEmployeeDetails where Id = 2
select * from Employee

-- rida 1909
-- 07.10.25
-- 10 tund

-- CTE tähendab common table expressionit
truncate table Employee

insert into Employee values
(6, 'John', 'Male', 1),
(7, 'Pam', 'Female', 4)

select * from Employee

--CTE
with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
	(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
	)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2

-- päritud tabeli variant
select DepartmentName, TotalEmployees
from
	(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
	)
as EmployeeCount
where TotalEmployees >= 2

--mitu CTE-d järjest
--esimese CTE nimi on EmployeeCountBy_Payroll_IT_Dept(DepartmentName, Total)
--saame teada, kui palju töötab IT ja Payroll osakonnas
with EmployeeCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
select DepartmentName, Count(Employee.Id) as TotalEmployees
from Employee
join Department
on Employee.DepartmentId = Department.Id
where DepartmentName in('Payroll', 'IT')
group by DepartmentName
),
--teise CTE nimi on EmployeesCountBy_HR_Admin_Dept(DepartmentName, Total)
EmployeesCountBy_HR_Admin_Dept(DepartmentName, Total)
as
(
select DepartmentName, Count(Employee.Id) as TotalEmployees
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName
)
--tuleb kasutada unionit kahe CTE päringu ühitamisel
select * from EmployeeCountBy_Payroll_IT_Dept
union
select * from EmployeesCountBy_HR_Admin_Dept

-- peale CTE-d peab kohe tulema käsklus SELECT, INSERT, UPDATE või DELETE
-- kui proovid midagi muud, siis tuleb veateade
-- tuleb teha join päring, kus saame samasugused andmed nagu oli eelmise päringuga
select DepartmentName, count(Department.Id)
from Department
join Employee
on Department.Id = Employee.DepartmentId
group by DepartmentName

-- uuendamine CTE-s
-- loome lihtsa CTE
with Employees_Name_Gender
as
(
	select Id, Name, Gender from Employee
)
select * from Employees_Name_Gender

--uuendame andmeid ja kasutame selleks CTE-d
--uuendame Id 1-te genderit Female peale
with Employees_Name_Gender
as
(
	select Id, Name, Gender from Employee
)
update Employees_Name_Gender set Gender = 'Female' where Id = 1
go
select * from Employee

--kasutame join-i CTE tegemisel
with EmployeesByDepartment
as
(
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Department.Id = Employee.DepartmentId
)
select * from EmployeesByDepartment

--kasutame joini ja muudame Employee tabelis Id = 1-ga genderi Male peale
with EmployeesByDepartment
as
(
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Department.Id = Employee.DepartmentId
)
update EmployeesByDepartment set Gender = 'Male' where Id = 1

select * from Employee

--kasutame join-i ja muudame mõlemas tabelis andmeid
--Id = 1 on n[[d Gender jälle Female, DepartmentName = IT
with EmployeesByDepartment
as
(
	select Employee.Id, Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
)
update EmployeesByDepartment set Gender = 'Male', DepartmentName = 'IT'
where Id = 1
--ei luba teha uuendusi kuna rohkem, kui ühes tabelis ei tohi teha uuendusi

with EmployeesByDepartment
as
(
	select Employee.Id, Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
)
update EmployeesByDepartment set DepartmentName = 'IT'
where Id = 1

--- kokkuvõte CTE-st
-- 1. kui CTE baseerub ühel tabelil, siis uuendus töötab
-- 2. kui CTE baseerub mitmel tablil, siis tuleb veateade
-- 3. kui CTE baseerub mitmel tabelil ja tahame muuta ainult ühte tabelit, siis
-- uuendus saab tehtud

--- CTE, mis iseendale viitab, kutsutakse korduvaks CTE-ks
--- kui tahad andmeid näidata hierarhiliselt

truncate table Employee

select * from Employee

insert into Employee values
(1, 'Tom', 2),
(2, 'Josh', null),
(3, 'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8, 'Sam', 5),
(9, 'Simon', 1)

-- tuleb teha left join
--ja kuvada NULL veeru asemel Super Boss
-- kui v''rtus
select Emp.Name as [Employee Name],
isnull(Manager.Name, 'Super Boss') as [Manager Name]
from dbo.Employee Emp
left join Employee Manager
on Emp.DepartmentId = Manager.Id

--kasutame CTE-d
with EmployeeCTE(Id, Name, DepartmentId, [Level])
as
(
	select Employee.Id, Name, DepartmentId, 1
	from Employee
	where DepartmentId is null

	union all

	select Employee.Id, Employee.Name,
	Employee.DepartmentId, EmployeeCTE.[Level] + 1
	from Employee
	join EmployeeCTE
	on Employee.DepartmentId = EmployeeCTE.Id
)
select EmpCTE.Name as Employee, isnull(MgrCTE.Name, 'Super Boss') as Manager,
EmpCTE.[Level]
from EmployeeCTE EmpCTE
left join EmployeeCTE MgrCTE
on EmpCTE.DepartmentId = MgrCTE.Id

--- PIVOT
create table ProductSales
(
SalesAgent nvarchar(50),
SalesCountry nvarchar(50),
SalesAmount int
)

--rida 2133
-- 11 tund 
-- 14.10.2025

select * from ProductSales
insert into ProductSales values('Tom', 'UK', 200)
insert into ProductSales values('John', 'US', 180)
insert into ProductSales values('John', 'UK', 260)
insert into ProductSales values('David', 'India', 450)
insert into ProductSales values('Tom', 'India', 350)

insert into ProductSales values('David', 'US', 200)
insert into ProductSales values('Tom', 'US', 130)
insert into ProductSales values('John', 'India', 540)
insert into ProductSales values('John', 'UK', 120)
insert into ProductSales values('David', 'UK', 220)

insert into ProductSales values('John', 'UK', 420)
insert into ProductSales values('David', 'US', 320)
insert into ProductSales values('Tom', 'US', 340)
insert into ProductSales values('Tom', 'UK', 660)
insert into ProductSales values('John', 'India', 430)

insert into ProductSales values('David', 'India', 230)
insert into ProductSales values('David', 'India', 280)
insert into ProductSales values('Tom', 'UK', 480)
insert into ProductSales values('John', 'UK', 360)
insert into ProductSales values('David', 'UK', 140)


select SalesCountry, SalesAgent, SUM(SalesAmount) as Total
from ProductSales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

--pivot näide
select SalesAgent, India, US, UK
from ProductSales
pivot
(
sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTabel

--p'ring muudab unikaalsete veergude väärtust (India, US, UK) SalesCountry veerus
--omaette veergudeks koos veergude SalesAmount liitmisega

create table ProductsSalesWithId
(
Id int primary key,
SalesAgent nvarchar(50),
SalesCountry nvarchar(50),
SalesAmount int
)

insert into ProductsSalesWithId values(1, 'Tom', 'UK', 200)
insert into ProductsSalesWithId values(2, 'John', 'US', 180)
insert into ProductsSalesWithId values(3, 'John', 'UK', 260)
insert into ProductsSalesWithId values(4, 'David', 'India', 450)
insert into ProductsSalesWithId values(5, 'Tom', 'India', 350)

insert into ProductsSalesWithId values(6, 'David', 'US', 200)
insert into ProductsSalesWithId values(7, 'Tom', 'US', 130)
insert into ProductsSalesWithId values(8, 'John', 'India', 540)
insert into ProductsSalesWithId values(9, 'John', 'UK', 120)
insert into ProductsSalesWithId values(10, 'David', 'UK', 220)

insert into ProductsSalesWithId values(11, 'John', 'UK', 420)
insert into ProductsSalesWithId values(12, 'David', 'US', 320)
insert into ProductsSalesWithId values(13, 'Tom', 'US', 340)
insert into ProductsSalesWithId values(14, 'Tom', 'UK', 660)
insert into ProductsSalesWithId values(15, 'John', 'India', 430)

insert into ProductsSalesWithId values(16, 'David', 'India', 230)
insert into ProductsSalesWithId values(17, 'David', 'India', 280)
insert into ProductsSalesWithId values(18, 'Tom', 'UK', 480)
insert into ProductsSalesWithId values(19, 'John', 'UK', 360)
insert into ProductsSalesWithId values(20, 'David', 'UK', 140)

select SalesAgent, India, US, UK
from ProductsSalesWithId
pivot
(
	sum(SalesAmount) for SalesCountry in ([India], [US], [UK])
)
as PivotTable
--miks ei näita tulemust:
--põhjuseks on Id veeru olemasolu productSalesWithId, mida võetakse arvesse
--pööramise ja grupeerimise järgi
select SalesAgent, India, US, UK
from
(
	select SalesAgent, SalesCountry, SalesAmount from ProductsSalesWithId
)
as SourceTable
pivot
(
	sum(SalesAmount) for SalesCountry in (India, US, UK)
)
as PivotTable

--UNPIVOT teha
--kasutada tabelit ProductsSalesWithId
select Id, FromAgentOrCountry, CountryOrAgent
from
(
	select Id, SalesAgent, SalesCountry, SalesAmount
	from ProductsSalesWithId
) as SourceTable
unpivot
(
CountryOrAgent for FromAgentOrCountry in (SalesAgent, SalesCountry)
)
as PivotTable

---transactionid

--transaction jälgib järgmisi samme:
--1. selle algust
--2. käivitab DB käske
--3. kontrollib vigu. Kui on viga, siis taastab algse oleku

create table MailingAddress
(
Id int not null primary key,
EmployeeNumber int,
HouseNumber nvarchar(50),
StreetAddress nvarchar(50),
City nvarchar(10),
PostalCode nvarchar(20)
)

insert into MailingAddress
values(1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create table PhysicalAddress
(
Id int not null primary key,
EmployeeNumber int,
HouseNumber nvarchar(50),
StreetAddress nvarchar(50),
City nvarchar(10),
PostalCode nvarchar(20)
)

insert into PhysicalAddress
values(1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end

spUpdateAddress

select * from MailingAddress
select * from PhysicalAddress

--muudame sp nimeks spUpdateAddress
alter proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON 12'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback tran
	end catch
end

spUpdateAddress
select * from MailingAddress
select * from PhysicalAddress

--kui teine uuendus ei l'he l'bi, siis esimene ei lähe ka läbi
--kõik uuendused peavad läbi minema

-- transaction ACID test

--edukas transaction peab läbima ACID testi:
-- A - atomic e aatomlikus
-- C - consistent e järjepidevus
-- I - isolated e isoleeritus
-- D - durable e vastupidav

--- Atomic - kõik tehingud transactionis on kas edukalt täidetud või need 
-- lükatakse tagasi. Nt, mõlemad käsud peaksid alati õnnesutma. Andmebaas 
-- teeb sellisel juhul: võtab esimese update tagasi ja veeretab selle algasendisse
-- e taastab algsed andmed

--- Consistent - kõik transactioni puudutavad andmed jäetakse loogiliselt 
-- järjepidevasse olekusse. Nt, kui laos saadaval olevaid esemete hulka 
-- vähendatakse, siis tabelis peab olema vastav kanne. Inventuur ei saa
-- lihtsalt kaduda

--- Isolated - transaction peab andmeid mõjutama, sekkumata teistesse
-- samaaegsetesse transactionitesse. See takistab andmete muutmist, mis 
-- põhinevad sidumata tabelitel. Nt, muudatused kirjas, mis hiljem tagasi 
-- muudetakse. Enamik DB-d kasutab tehingute isoleerimise säilitamiseks 
-- lukustamist

--- Durable - kui muudatus on tehtud, siis see on püsiv. Kui süsteemiviga või
-- voolukatkestus ilmneb enne käskude komplekti valmimist, siis tühistatkse need 
-- käsud ja andmed taastakse algsesse olekusse. Taastamine toimub peale 
-- süsteemi taaskäivitamist.

-- subqueries
-- tabel tühjaks teha
truncate table Product
truncate table ProductSales

create table Product
(
Id int identity primary key,
Name nvarchar(50),
Description nvarchar(250)
)

create table ProductSales
(
Id int primary key identity,
ProductId int foreign key references Product(Id),
UnitPrice int,
QuantitySold int
)

insert into Product values ( 'TV', '52 inch black color LCD TV')
insert into Product values ( 'Laptop', 'Very thin black color laptop')
insert into Product values ( 'Desktop', 'HP high performance desktop')

insert into ProductSales values(3, 450, 5)
insert into ProductSales values(2, 250, 7)
insert into ProductSales values(3, 450, 4)
insert into ProductSales values(3, 450, 9)

select * from Product
select * from ProductSales

--kirjutame päringu, mis annab infot müümata toodetest
select Id, Name, Description
from Product
where Id not in (select distinct ProductId from ProductSales)

--teha samasuguse tulemusega päring, aga kasuta JOIN-i
select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null

-- teeme suqueri, kus kasutame selecti. Kirjutame p'ringu, kus
-- saame teada NAME ja TotalQuantity veeru andmeid
select Name,
(select sum(QuantitySold) from ProductSales where ProductId = Product.Id) as
[Total Quantity]
from Product
order by Name

--sama p'ring left joiniga ja kasutame group by-d ja order by-d
select Name, sum(QuantitySold) as TotalQuantity
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
group by Name
order by Name

-- subqueryt saab subquery sisse panna
-- subquerid on alati sulgudes ja neid nimetatakse sisemisteks päringuteks

-- rohkete andmetega testimise tabel
truncate table Product
truncate table ProductSales

---
declare @Id int
set @Id = 1
while(@Id <= 1000000)
begin
	insert into Product values('Product - ' + cast(@Id as nvarchar(20)),
	'Product - ' + cast(@Id as nvarchar(20)) + ' Description')

	print @Id
	set @Id = @Id + 1
end

declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

-- productId
declare @LowerLimitForProductId int
declare @UpperLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 1000000

--unitprice
declare @LowerLimitForUnitPrice int
declare @UpperLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 1000

-- rida 2477
-- tund 12
-- 21.10.25
declare @LowerLimitForQuantitySold int
declare @UpperLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 20

declare @Counter int
set @Counter = 1

while(@Counter <= 1450000)
begin
	select @RandomProductId = round(((@UpperLimitForProductId - 
	@LowerLimitForProductId) * RAND() + @LowerLimitForProductId), 0)

	select @RandomUnitPrice = round(((@UpperLimitForUnitPrice -
	@LowerLimitForUnitPrice) * rand() + @LowerLimitForUnitPrice), 0)

	select @RandomQuantitySold = round(((@UpperLimitForQuantitySold -
	@LowerLimitForQuantitySold) * rand() + @LowerLimitForQuantitySold), 0)

	insert into ProductSales
	values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

	print @Counter
	set @Counter = @Counter + 1
end

select * from Product
select * from ProductSales

select Id, Name, Description
from Product
where Id in
(
select Product.Id from ProductSales
)

---peaaegu 10,7 miljonit rida tegi ära 38 sekundiga

--teeme cache puhtaks, et uut päringut ei oleks kuskile vahemällu salvestatud
checkpoint;
go
dbcc DROPCLEANBUFFERS; ---puhastab päringu cache-i
go
dbcc FREEPROCCACHE; --puhastab täitva planeeritud cache-i
go

--teeme sama tabeli peale inner join päringu
--distinct otsib veerus ülesse teatud väärtused, aga mitte korduvaid
--väga tihti on samas veerus korduvad väärtused
select distinct Product.Id, Name, Description
from Product
inner join ProductSales
on Product.Id = ProductSales.ProductId
--p'ring tehti ära 0 sekundiga
--teeme cache puhtaks

select Id, Name, Description
from Product
where not exists(select * from ProductSales where ProductId = Product.Id)
--päring tehti ära 38 sekundiga
-- teeme cache puhtaks

--kasutame left joini
--where tingimus, kus on Productid is null
select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is null
--võtab aega 42 sekundit

--CURSOR
--- relatsiooniliste DB-de haldussüsteemid saavad väga hästi hakkama 
--- SETS-ga. SETS lubab mitut päringut kombineerida üheks tulemuseks.
--- Sinna alla käivad UNION, INTERSECT ja EXCEPT.

update ProductSales set UnitPrice = 450
where ProductSales.ProductId = 3

--- kui on vaja rea kaupa andmeid töödelda, siis kõige parem oleks kasutada 
--- Cursoreid. Samas on need jõudlusele halvad ja võimalusel vältida. 
--- Soovitav oleks kasutada JOIN-i.

-- Cursorid jagunevad omakorda neljaks:
-- 1. Forward-Only e edasi-ainult
-- 2. Static e staatilised
-- 3. Keyset e võtmele seadistatud
-- 4. Dynamic e dünaamiline

--cursori näide:
if the ProductName = 'Product - 55', set UnitPrice to 55

--nüüd algab õige kursori näide
-------------------------------
declare @ProductId int
--deklareerime cursori
declare ProductIdCursor cursor for
select ProductId from ProductSales
-- open avaldusega täidab select avaldust
-- ja sisestab tulemuse
open ProductIdCursor

fetch next from ProductIdCursor into @ProductId
--kui tulemuses on veel ridu, siis @@FETCH_STATUS on 0
while(@@FETCH_STATUS = 0)
begin
	declare @ProductName nvarchar(50)
	select @ProductName = Name from Product where Id = @ProductId

	if(@ProductName = 'Product - 55')
	begin
		update ProductSales set UnitPrice = 55 where ProductId = @ProductId
	end

	else if(@ProductName = 'Product - 65')
	begin
		update ProductSales set UnitPrice = 65 where ProductId = @ProductId
	end

	else if(@ProductName = 'Product - 1000')
	begin
		update ProductSales set UnitPrice = 1000 where ProductId = @ProductId
	end

	fetch next from ProductIdCursor into @ProductId
end
-- tegi 19 sekundiga
close ProductIdCursor
-- vabastab ressursid, mis on seotud cursoriga
deallocate ProductIdCursor

--vaatame, kas read on uuendatud
select Name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product - 55' or Name = 'Product - 65' or Name = 'Product - 1000')

--- rida 2618
--- tund 13
--- 04.10.2025

update ProductSales
set UnitPrice = 
	case
		when Name = 'Product - 55' then 155
		when Name = 'Product - 65' then 165
		when Name like 'Product - 1000' Then 1001
	end
from ProductSales
join Product
on Product.Id = ProductSales.ProductId
where Name = 'Product - 55' or Name = 'Product - 65' or
Name like 'Product - 1000'

select Name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product - 55' or Name = 'Product - 65' or Name = 'Product - 1000')


create table Employee
(
Id int primary key,
Name nvarchar(30),
ManagerId int
)

--kas soovitud nimega tabelit on olemas
if not exists (select * from INFORMATION_SCHEMA.TABLES 
where TABLE_NAME = 'Employee123456')
begin
	create table Employee123456
	(
	Id int primary key,
	Name nvarchar(30),
	ManagerId int
	)
	print 'Table Employee created'
	end
	else
	begin
		print 'Table Employee already exists'
end

--tahame sama nimega tabeli ära kustutada ja siis uuesti luua
if OBJECT_ID('Employee') is not null
begin
	drop table Employee
end
create table Employee
(
Id int primary key,
Name nvarchar(30),
ManagerId int
)

--lisada tabelile Employee Email veerg,
--mis on nvarchar ja 50 tähemärki läheb sinna
alter table Employee
add Email nvarchar(50)

--kui veergu ei ole, siis loo veerg nimega Email nvarchar(50)
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where
COLUMN_NAME = 'Email' and TABLE_NAME = 'Employee' and TABLE_SCHEMA = 'dbo')
begin
	alter table Employee
	add Email nvarchar(50)
end
else
begin
	print 'Column already exists'
end

--kontrollime, kas mingi nimega veerg on olemas
if COL_LENGTH('Employee', 'Email13') is not null
begin
	print 'Column already exists'
end
else
begin
	print 'Column does not exists'
end

---MERGE
--- tutvustati aastal 2008, mis lubab teha sisestamist, uuendamist ja kustutamist
--- ei pea kasutama mitut käsku

-- merge puhul peab alati olema vähemalt kaks tabelit:
-- 1. algallika tabel e source table
-- 2. sihtmärk tabel e target table

-- ühendab sihttabeli lähtetabeliga ja kasutab mõlemas tabelis ühist veergu
-- koodinäide:
merge [TARGET] as T
using [SOURCE] as S
	on [JOIN_CONDITIONS]
when matched then
	[UPDATE_STATEMENT]
when not matched by target then
	[INSERT_STATEMENT]
when not matched by source then
	[DELETE_STATEMENT]

create table StudentSource
(
Id int primary key,
Name nvarchar(20)
)
go
insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'Sara')
go
create table StudentTarget
(
Id int primary key,
Name nvarchar(20)
)
go
insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(3, 'John')
go

select * from StudentTarget
select * from StudentSource

-- 1. kui leitakse klappiv rida, siis StudentTarget tabel on uuendatud
-- 2. kui read on StudentSource tabelis olemas, aga neid ei ole StudentTarget-s,
-- siis puuduolevad read sisestatakse 
-- 3. kui read on olemas StudentTarget-s, aga mitte StudentSource-s, 
-- siis StudentTarget tabelis read kustutatakse ära
merge Studenttarget as T
using StudentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert (Id, Name) values (S.Id, S.Name)
when not matched by source then
	delete;

select * from StudentTarget
select * from StudentSource

--tabelid teeme tühjaks
truncate table StudentTarget
truncate table StudentSource

insert into StudentSource values(1, 'Mike')
insert into StudentSource values(2, 'Sara')
go
insert into StudentTarget values(1, 'Mike M')
insert into StudentTarget values(3, 'John')
go

merge StudentTarget as T
using StudentSource as S
on T.Id = S.Id
when matched then
	update set T.Name = S.Name
when not matched by target then
	insert (Id, Name) values(S.Id, S.Name);

--- transaction-d

-- mis see on?
-- on rühm käske, mis muudavad DB-s salvestatuid andmeid. Tehingut käsitletakse
-- ühe tööüksusena. Kas kõik käsud õnnestuvad või mitte. 
-- Kui üks tehing sellest ebaõnnestub
-- siis kõik juba muudetud andmed muudetakse tagasi

create table Account
(
Id int primary key,
AccountName nvarchar(25),
Balance int
)

insert into Account values(1, 'Mark', 1000)
insert into Account values(2, 'Mary', 1000)

--transaction tagab, et mõlemad uuendatavad käsud saavad ära tehtud

begin try
	begin transaction
		update Account set Balance = Balance - 100 where Id = 1
		update Account set Balance = Balance + 100 where Id = 2
	commit transaction
	print 'Transaction Commited'
end try
begin catch
	rollback tran
	print 'Transaction rolled back'
end catch

select * from Account

--- mõned levinumad probleemid:
-- 1. Dirty read e must lugemine
-- 2. Lost Updates e kadunud uuendused
-- 3. Nonreapeatable reads e kordumatud lugemised
-- 4. Phantom read e fantoom lugmine

--- kõik eelnevad probleemid lahendaks ära, kui lubaksite igal ajal 
--- korraga ühel kasutajal ühe tehingu teha. Selle tulemusel kõik tehingud
--- satuvad järjekorda ja neil võib tekkida vajadus kaua oodata, enne
--- kui võimalus tehingut teha saabub.

--- kui lubada samaaegselt kõik tehingud ära teha, siis see omakorda tekitab probleeme
--- Probleemi lahendamiseks pakub MSSQL server erinevaid tehinguisolatsiooni tasemeid,
--- et tasakaalustada samaaegsete andmete CRUD(create, read, update ja delete) probleeme:

-- 1. read uncommited e lugemine ei ole teostatud
-- 2. read commited e lugemine tehtud
-- 3. repeatable read e korduv lugemine
-- 4. snapshot e kuvatõmmis
-- 5. serializable e serialiseerimine

--dirty read n'ide
create table Inventory
(
Id int identity primary key,
Product nvarchar(100),
ItemsInStock int
)
go
insert into Inventory values ('iPhone', 10)
select * from Inventory

-- 1. käsklus
-- 1 transaction
begin tran
update Inventory set ItemsInStock = 9 where Id = 1
--kliendile tuleb arve
waitfor delay '00:00:15'
-- ebapiisav saldojääk, teeb rollback-i
rollback tran

-- 2. käsklus
-- samal ajal tegin uue päringu akna,
-- kus kohe peale esimest käklust käivitan teise
-- 2 transaction
set tran isolation level read uncommitted
select * from Inventory where Id = 1

-- 3.k'sklus
--nüüd panen selle käskluse tööle
--käivita, kui käsklus 1 on möödas
select * from Inventory (nolock)
where Id = 1

--- muutsin esimese käsuga 9 iPhone peale, aga
--- ikka on 10 tk.

--lost update probleem
select * from Inventory

set tran isolation level repeatable read
-- transaction 1
begin tran
declare @ItemsInStock int
select @ItemsInStock = ItemsInStock
from Inventory where Id = 1

waitfor delay '00:00:10'
set @ItemsInStock = @ItemsInStock - 1

update Inventory
set ItemsInStock = @ItemsInStock 
where Id = 1

print @ItemsInStock
commit transaction

--samal ajal panen teise transactioni
-- tööle teisest serverist

set tran isolation level repeatable read
begin tran
declare @ItemsInStock int

select @ItemsInStock = ItemsInStock
from Inventory where Id = 1

waitfor delay '00:00:01'
set @ItemsInStock = @ItemsInStock - 2

update Inventory
set ItemsinStock = @ItemsInStock where Id = 1

print @ItemsInStock
commit tran

--non repeatable read näide

--- see juhtub, kui üks transaction loeb samu andmeid kaks korda
--- ja teine transaction uuendab neid andmeid esimese ning 
--- teise käsu vahel esimese transactioni jooksutamise ajal

-- esimene transaction
set tran isolation level repeatable read
begin tran
select ItemsInStock from Inventory where Id = 1

waitfor delay '00:00:10'

select ItemsInStock from Inventory where Id = 1
commit tran

-- panen nüüd teise transactioni 
-- käima

update Inventory set ItemsInStock = 8
where Id = 1

select * from Inventory

--Phantom read näide
create table Employee
(
Id int primary key,
Name nvarchar(50)
)

insert into Employee values(1, 'Mark')
insert into Employee values(3, 'Sara')
insert into Employee values(100, 'Mary')

--- transaction 1

set tran isolation level serializable

begin tran
select * from Employee where Id between 1 and 3

waitfor delay '00:00:10'
select * from Employee where Id between 1 and 3
commit tran

--panen kohe teise serverist 
-- andmeid juurde
insert into Employee
values(2, 'Marcus')

--- vastuseks tuleb: Mark ja Sara. Marcust ei näita, aga peaks

--- erinevus korduvlugemisega ja serialiseerimisega
-- korduv lugemine hoiab ära ainult kordumatud lugemised
-- serialiseerimine hoiab ära kordumatud lugemised ja
-- phantom read probleemid
-- isolatsioonitase tagab, et ühe tehingu loetud andmed ei 
-- takistaks muid transactioneid

--- DEADLOCK
-- kui andmebaasis tekib ummikseis

create table TableA
(
Id int identity primary key,
Name nvarchar(50)
)
go
Insert into TableA values('Mark')
go
create table TableB
(
Id int identity primary key,
Name nvarchar(50)
)
go
insert into TableB values('Mary')

-- transaction 1
-- samm nr 1
begin tran
update TableA set Name = 'Mark Transaction 1' where Id = 1

-- samm nr 3
update TableB set Name = 'Mary Transaction 1' where Id = 1

commit tran

-- teine server
-- samm nr 2
begin tran
update TableA set Name = 'Mark Transaction 2' where Id = 1

--samm nr 4
update TableB set Name = 'Mary transaction 2' where id = 1

commit tran 

select * from TableA
select * from TableB

--- Kuidas SQL server tuvastab deadlocki?
--- Lukustatakse serveri lõim, mis töötab vaikimisi iga 5 sek järel
--- et tuvastada ummikuid. Kui leiab deadlocki, siis langeb 
--- deadlocki intervall 5 sek-lt 100 millisekundini.

--- mis juhtub deadlocki tuvastamisel
--- Tuvastamisel lõpetab DB-mootor deadlocki ja valib ühe lõime 
--- ohvriks. Seejärel keeratakse deadlockiohvri tehing tagasi ja 
--- tagastatakse rakendusele viga 1205. Ohvri tehingu tagasitõmbamine
--- vabastab kõik selle transactioni valduses olevad lukud.
--- See võimaldab teistel transactionitel blokeringut tühistada ja
--- edasi liikuda.

--- mis on DEADLOCK_PRIORITY
--- vaikimisi valib SQL server deadlockiohvri tehingu, mille 
--- tagasivõtmine on kõige odavam (võtab vähem ressurssi). Seanside 
--- prioriteeti saab muuta SET DEADLOCK_PRIORTY

--- Ohvri valimise kriteeriumid
--- 1. Kui prioriteedid on erinevad, siis kõige madalama 
--- tähtsusega valitakse ohvriks
--- 2. Kui mõlemal sessioonil on sama prioriteet, siis valitakse 
--- ohvriks transaction,
--- mille tagasi viimine on kõige vähem ressurssi nõudev.
--- 3. Kui mõlemal sessioonil on sama prioriteet ja sama 
--- ressursi kulutamine, siis ohver valitakse juhuslikuse alusel

truncate table TableA
truncate table TableB

--tran 1
--samm nr 1
begin tran
update TableA set Name = Name +
'Transaction 1' where Id in (1,2,3,4,5)

--samm nr 3
update TableB set Name = Name +
'Transaction 1' where Id = 1

-- samm nr 5
commit tran

-- server nr 2
-- 2 k'sklus
set deadlock_priority high
go
begin tran
update TableB set Name =
Name + 'Transaction 1' where Id = 1

--samm nr 4
update TableA set Name = 
Name + 'Transaction 1' where Id in (1,2,3,4,5)
--samm nr 6
commit tran

insert into TableA values('Mark')
insert into TableA values('Ben')
insert into TableA values('Todd')
insert into TableA values('Pam')
insert into TableA values('Sara')

insert into TableB values('Mary')

select * from TableA
select * from TableB


--deadlock vea käsitlemine
create proc spTransaction1
as begin
	begin tran
	begin try
		update TableA set Name = 'Mark Transaction 1' where Id = 1
		waitfor delay '00:00:05'
		update TableB set Name = 'Mary Transaction 1' where Id = 1

		commit tran
		select 'Transaction Successful'
	end try
	begin catch
		-- vaatab, kas see error on deadlocki oma
		if(ERROR_NUMBER() = 1205)
		begin 
			select 'Deadlock. Transaction failed. Please try'
		end

		rollback
	end catch
end

create proc spTransaction2
as begin
	begin tran
	begin try
		update TableA set Name = 'Mark Transaction 1' where Id = 1
		waitfor delay '00:00:05'
		update TableB set Name = 'Mary Transaction 1' where Id = 1

		commit tran
		select 'Transaction Successful'
	end try
	begin catch
		-- vaatab, kas see error on deadlocki oma
		if(ERROR_NUMBER() = 1205)
		begin 
			select 'Deadlock. Transaction failed. Please try'
		end

		rollback
	end catch
end
--esimeses serveris
spTransaction1
--teises serveris
spTransaction2


--teise serverisse kirjutame
select count(*) from TableA
delete from TableA where Id = 1
truncate table TableA
drop table TableA