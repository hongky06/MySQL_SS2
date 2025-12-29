CREATE DATABASE SS3;
USE SS3;
create table student (
	Student_id varchar(20) primary key , 
    namestudent varchar(100) not null 
);
INSERT INTO student(Student_id, namestudent)
VALUES
('1', 'van a '),
('2', 'hongky'),
('3', 'van b');

CREATE TABLE Subject (
    subject_id VARCHAR(20) PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT CHECK (credit > 0)
);

INSERT INTO Subject(subject_id, subject_name, credit)
VALUES
('1', 'Database', 3),
('2', 'Programming C', 2),
('3', 'Web Development', 4);


create TABLE Enrollment (
Student_id varchar(20),
Subject_id varchar(20),
Enroll_date date  ,
foreign key (Student_id) references student(Student_id),
foreign key (Subject_id) references Subject(Subject_id)
);

INSERT INTO Enrollment(Student_id, Subject_id, Enroll_date)
VALUES
('1','1','2025-01-01'),
('1','2','2025-01-02'),
('2','1','2025-01-03');




