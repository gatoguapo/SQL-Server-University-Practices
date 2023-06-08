create DATABASE Sam
go
Use Sam
go
Create table Users(
UserID int not null,
Username nvarchar(30) not null,
Bio nvarchar(100),
Position nvarchar(100),
Pronouns nvarchar(10) not null,
Link nvarchar(30),
GH nvarchar(30),
Country nvarchar(30) not null)
go
Create Table Followers(
UserID int, 
FollowsTo int)
go
Alter table Users add constraint PK_Users_UserID
primary key (UserID)
go
Alter table Followers add constraint FK_Followers_UserID
foreign key (UserID) references Users(UserID)
go
insert Users values(1,'gatoguapo', 'Un gato muy guapo', null, 'He','gatoguapo.com','gh','Mexico')
insert Users values(2,'sam', 'cute boy', null, 'He','sam.com','gh','Francia')
insert Users values(3,'bardack', 'soy tonto', null, 'He','bardack.com','gh','Italia')
insert Users values(4,'cronando', 'soy el sexnando', null, 'He','sexxxnando.com','gh','Alemania')
insert Users values(5,'alan', 'pretty boy', null, 'He','anal.com','gh','USA')
go
insert Followers values(1, 2)
insert Followers values(1, 3)
insert Followers values(1, 4)
insert Followers values(1, 5)
insert Followers values(2, 1)
insert Followers values(3, 1)
insert Followers values(4, 1)
insert Followers values(5, 1)
insert Followers values(2, 1)
insert Followers values(2, 3)
insert Followers values(2, 4)
insert Followers values(2, 5)
go
alter table Users add Relacion nvarchar(30)
update Users set Relacion = 'Sin Relacion'

select * from Users
select * from Followers

select u.UserID,u.Username, 'Sigue a' = f.FollowsTo from Users u
inner join Followers f on U.UserID = F.UserID

select Usuario = f.FollowsTo, 'Seguido por' = f.UserID, u.Username from Users u
inner join Followers f on U.UserID = F.UserID