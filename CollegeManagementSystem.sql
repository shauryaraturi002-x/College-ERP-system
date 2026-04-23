create database college_erp;
use college_erp;

create table Department(
Dept_id int primary key auto_increment,
Dept_Name varchar(50) unique not null
);

create table Student
(
Student_ID int primary key auto_increment,
Name varchar(100),
Email varchar(100) unique,
Phone varchar(50),
Gender enum('Male','Female','Other'),
DOB date,
Dept_ID int,
Admission_Date date default (CURRENT_DATE),
Foreign key(Dept_ID) references Department(Dept_ID)
);



create table Faculty
(
Faculty_ID int primary key auto_increment,
Name varchar(100),
Email varchar(100),
Salary decimal(10,2),
Dept_ID int,
foreign key(Dept_ID) references Department(Dept_ID)
);

create table Course
(
Course_ID int primary key auto_increment,
Course_Name varchar(100),
Credits int,
Dept_ID int,
Faculty_ID int,
foreign key(Dept_ID) references Department(Dept_ID),
foreign key(Faculty_ID) references Faculty(Faculty_ID)
);

create table Enrollment
(
Enrollment_ID int primary key auto_increment,
Student_ID int,
Course_ID int,
Enrollment_Date date default (CURRENT_DATE),
unique(Student_ID, Course_ID),
foreign key(Student_ID) references Student(Student_ID),
foreign key(Course_ID) references Course(Course_ID)
);

create table Attendance
(
Attendance_ID int primary key auto_increment,
Student_ID int,
Course_ID int,
Date date,
Status enum('Present','Absent'),
foreign key(Student_ID) references Student(Student_ID),
foreign key(Course_ID) references Course(Course_ID)
);

create table Marks
(
Marks_ID int primary key auto_increment,
Student_ID int,
Course_ID int,
Marks int check(marks between 0 and 100),
foreign key(Student_ID) references Student(Student_ID),
foreign key(Course_ID) references Course(Course_ID)
);

create table fees
(
Fee_ID int primary key auto_increment,
Student_ID int,
Total_Fee decimal(10,2),
Paid_Amount decimal(10,2),
foreign key(Student_ID) references Student(Student_ID)
);

-- Departments
INSERT INTO Department (Dept_Name) VALUES
('Computer Science'),
('Mechanical'),
('Civil');

-- Students
INSERT INTO Student (Name, Email, Phone, Gender, DOB, Dept_ID) VALUES
('Rahul Sharma','rahul@gmail.com','9876543210','Male','2002-05-10',1),
('Anita Verma','anita@gmail.com','9876543211','Female','2003-03-12',2),
('Suresh Kumar','suresh@gmail.com','9876543212','Male','2001-07-19',3),
('Priya Singh','priya@gmail.com','9876543213','Female','2002-11-25',1),
('Amit Patel','amit@gmail.com','9876543214','Male','2003-01-30',2),
('Vikram Joshi','vikram@gmail.com','9876543215','Male','2002-04-05',3),
('Rohan Das','rohan@gmail.com','9876543216','Male','2002-12-09',2),
('Meena Iyer','meena@gmail.com','9876543217','Female','2001-08-18',1),
('Arjun Nair','arjun@gmail.com','9876543218','Male','2003-02-27',3),
('Sneha Roy','sneha@gmail.com','9876543219','Female','2002-10-11',2);

-- Faculty
INSERT INTO Faculty (Name, Email, Salary, Dept_ID) VALUES
('Dr Singh','singh@gmail.com',80000,1),
('Prof Kumar','kumar@gmail.com',75000,2),
('Dr Mehta','mehta@gmail.com',82000,3),
('Prof Sharma','sharma@gmail.com',78000,1),
('Dr Gupta','gupta@gmail.com',76000,2),
('Prof Iyer','iyer@gmail.com',81000,3);

-- Courses
INSERT INTO Course (Course_Name, Credits, Dept_ID, Faculty_ID) VALUES
('Database Systems',4,1,1),
('Thermodynamics',3,2,2),
('Operating Systems',4,1,4),
('Fluid Mechanics',3,2,5),
('Data Structures',4,1,1),
('Heat Transfer',3,2,2),
('Computer Networks',4,1,4),
('Machine Design',3,2,5),
('Algorithms',4,1,1),
('Material Science',3,3,3);

-- Enrollment
INSERT INTO Enrollment (Student_ID, Course_ID) VALUES
(1,1),(2,2),(3,3),(4,5),(5,4),
(6,6),(7,7),(8,8),(9,9),(10,10);

-- Attendance (multiple dates for variety)
INSERT INTO Attendance (Student_ID, Course_ID, Date, Status) VALUES
(1,1,'2026-04-01','Present'),(1,1,'2026-04-02','Absent'),
(2,2,'2026-04-01','Absent'),(2,2,'2026-04-02','Present'),
(3,3,'2026-04-01','Present'),(3,3,'2026-04-02','Present'),
(4,5,'2026-04-01','Present'),(4,5,'2026-04-02','Absent'),
(5,4,'2026-04-01','Absent'),(5,4,'2026-04-02','Absent'),
(6,6,'2026-04-01','Present'),(6,6,'2026-04-02','Present'),
(7,7,'2026-04-01','Absent'),(7,7,'2026-04-02','Absent'),
(8,8,'2026-04-01','Present'),(8,8,'2026-04-02','Present'),
(9,9,'2026-04-01','Present'),(9,9,'2026-04-02','Absent'),
(10,10,'2026-04-01','Absent'),(10,10,'2026-04-02','Present');

-- Marks
INSERT INTO Marks (Student_ID, Course_ID, Marks) VALUES
(1,1,85),(2,2,77),(3,3,45),(4,5,66),(5,4,77),
(6,6,89),(7,7,98),(8,8,72),(9,9,67),(10,10,99);

-- Fees
INSERT INTO Fees (Student_ID, Total_Fee, Paid_Amount) VALUES
(1,50000,25000),(2,45000,20000),(3,60000,30000),(4,55000,40000),
(5,48000,48000),(6,52000,25000),(7,47000,35000),(8,62000,30000),
(9,50000,50000),(10,45000,15000);

-- Grade Calculation
select s.Name, c.Course_Name, m.marks,
case
when m.Marks>=90 then 'A+'
when m.Marks>=75 then 'A'
when m.Marks>=60 then 'B'
when m.Marks>=50 then 'C'
else 'F'
end as Grade from Marks m
join Student s on m.Student_ID = s.Student_ID
join Course c on m.Course_ID = c.Course_ID;

-- Fee status
select s.Name, f.Total_Fee, f.Paid_Amount,
f.Total_Fee-f.Paid_Amount as Due_Amount,
CASE
when (f.Total_Fee-f.Paid_Amount=0) then 'Paid'
else 'Pending' end as Status from fees f
join Student s on f.Student_ID=s.Student_ID;

-- Attendance Percentage
select s.Name,
c.Course_Name,
round(sum(a.Status='Present')*100/count(*),2) as 
Attendance_Percentage from Attendance a
join Student s on s.Student_ID=a.Student_ID
join Course c on c.Course_ID=a.Course_ID
group by s.Student_ID, c.Course_ID;

-- Topper Per Course
select s.Name,
       c.Course_Name,
       m.Marks
from Marks m
join Student s on m.Student_ID = s.Student_ID
join Course c on m.Course_ID = c.Course_ID
where m.Marks = (
    select max(Marks)
    from Marks
    where Course_ID = m.Course_ID
);

-- Low Attendance Students
select* from (
select s.Name,
round(sum(a.Status='Present')*100/count(*),2) as Attendance_Percentage
from Attendance a 
join Student s on s.Student_ID=a.Student_ID
group by s.Name) as temp where Attendance_Percentage<75;

-- Fee Defaulters
select s.Name,
f.Total_Fee-f.Paid_Amount as Due_Amount 
from Fees f
Join Student s on s.Student_ID=f.Student_ID
where f.Total_Fee-f.Paid_Amount>0;

-- Views
create view Report_Card as 
select s.Name,
c.Course_Name,
m.Marks,
case
when m.Marks>=90 then 'A+'
when m.Marks>=75 then 'A'
when m.Marks>=60 then 'B'
when m.Marks>=50 then 'C'
else 'F'
end as Grades from Marks m
join Student s on s.Student_ID= m.Student_ID
join Course c on c.Course_ID=m.Course_ID;

select* from Report_Card;

-- Stored Procedure
Delimiter //
create procedure GetStudentReport(IN sid int)
begin
select* from Report_Card 
where name = (select Name from student where Student_ID=sid);
end //
Delimiter ;

call GetStudentReport(10);




