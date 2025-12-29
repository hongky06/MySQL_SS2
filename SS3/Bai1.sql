create database SS3; 
use SS3; 

drop table if exists student;

create table student (
	student_id varchar(20) primary key, 
    full_name varchar(50) not null, 
    date_of_birth date, 
    email varchar(30) unique  
);

insert into student (student_id, full_name, date_of_birth, email)
values ('1', 'dohongky', '2006-12-25', 'ky@gmail.com');
