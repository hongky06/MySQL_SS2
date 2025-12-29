create database SS3; 
use SS3; 

create table student (
	student_id varchar(20) primary key , 
    full_name varchar(50) not null , 
    date_of_birth date , 
    email varchar(30) unique  
);

insert into student(student_id, full_name, date_of_birth, email)
values 
('1', 'dohongky1', '2006-10-25', 'do@gmail.com'),
('2', 'dohongky2', '2006-11-25', 'hongky@gmail.com'),
('3', 'dohongky3', '2006-12-25', '2005@gmail.com'),
('4', 'dohongky3', '2006-12-25', '4@gmail.com'),
('5', 'dohongky3', '2006-12-25', '5@gmail.com');



UPDATE student
Set email = "email3@gmail.com" 
WHERE student_id = '3' ;  


UPDATE student 
Set date_of_birth = '1111-1-11'
WHERE student_id = '2' ;


DELETE FROM student
WHERE student_id = 5  ;


SELECT * FROM student ;


