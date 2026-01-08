CREATE DATABASE HN_KS24_CNTT5_DOHONGKY_08;
USE HN_KS24_CNTT5_DOHONGKY_08;

CREATE TABLE Department (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(255)
);

CREATE TABLE Employee (
    employee_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    hire_date DATE,
    department_id VARCHAR(10)
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(150),
    budget DECIMAL(15,2),
    status VARCHAR(50)
);

CREATE TABLE Assignment (
    assignment_id INT PRIMARY KEY,
    employee_id VARCHAR(10),
    project_id INT,
    role VARCHAR(50),
    bonus_amount DECIMAL(10,2)
);
INSERT INTO Department VALUES
('D001','Information Technology','Floor 4, Building A'),
('D002','Human Resources','Floor 2, Building B'),
('D003','Finance & Accounting','Floor 3, Building A'),
('D004','Marketing & Sales','Floor 5, Building C'),
('D005','Research & Development','Floor 6, Building D');

INSERT INTO Employee VALUES
('E001','Nguyen Minh Anh','anh.nm@company.com','0912345678','2022-01-15','D001'),
('E002','Tran Thi Thanh','thanh.tt@company.com','0923456789','2021-05-20','D002'),
('E003','Pham Hoang Nam','nam.ph@company.com','0934567890','2023-03-10','D001'),
('E004','Le Thu Thao','thao.lt@company.com','0945678901','2020-11-25','D003'),
('E005','Vu Duc Cuong','cuong.vd@company.com','0956789012','2024-02-01','D005');

INSERT INTO Project VALUES
(1,'ERP System Upgrade',500000,'Active'),
(2,'Mobile App Launch',250000,'Pending'),
(3,'Annual Financial Audit',100000,'Completed'),
(4,'Market Expansion Asia',800000,'Active'),
(5,'AI Research Pilot',150000,'Pending');

INSERT INTO Assignment VALUES
(1,'E001',1,'Manager',2000),
(2,'E003',1,'Developer',1700),
(3,'E002',4,'Developer',1500),
(4,'E004',3,'Tester',1200),
(5,'E005',5,'Tester',1000);

-- 1.3 : 3. Thay đổi địa chỉ (location) của phòng ban có mã department_id = 'D003' thành "Landmark Tower, HCM City".(5 điểm) 
UPDATE Department
SET location = 'Landmark Tower, HCM City'
WHERE department_id = 'D003';

-- 1.4 : 4. Dự án có mã project_id = 1 được phê duyệt tăng ngân sách. Hãy cập nhật budget tăng thêm 20% và chuyển trạng thái status thành 'Active'.(5 điểm)
UPDATE Project
SET budget = budget * 1.2,
    status = 'Active'
WHERE project_id = 1;

-- Lỗi , em chưa sửa được
DELETE FROM Assignment
WHERE bonus_amount < 1200 AND project_id IN (
    SELECT project_id
    FROM Project
   --  WHERE status = 'Completed'
    WHERE status = 'Pending'
);




SELECT project_id, project_name
FROM Project
WHERE budget > 300000 AND status = 'Active';


SELECT full_name, email, phone_number
FROM Employee
WHERE full_name LIKE '%Anh%';


SELECT employee_id, full_name, hire_date
FROM Employee
ORDER BY hire_date DESC;


SELECT employee_id, full_name, hire_date
FROM Employee
ORDER BY hire_date ASC
LIMIT 3;


SELECT employee_id, full_name
FROM Employee
LIMIT 2 OFFSET 2;


SELECT e.employee_id, e.full_name, d.department_name
FROM Employee e, Department d
WHERE e.department_id = d.department_id;


SELECT d.department_name, e.employee_id
FROM Department d
LEFT JOIN Employee e
ON d.department_id = e.department_id;


SELECT status, SUM(budget) AS total_budget
FROM Project
GROUP BY status;


SELECT employee_id, COUNT(project_id) AS total_project
FROM Assignment
GROUP BY employee_id
HAVING COUNT(project_id) >= 2;


SELECT project_id, project_name, budget
FROM Project
WHERE budget > (SELECT AVG(budget) FROM Project);


SELECT e.full_name, e.email
FROM Employee e, Assignment a, Project p
WHERE e.employee_id = a.employee_id
AND a.project_id = p.project_id
AND p.project_name = 'ERP System Upgrade';


SELECT e.full_name, d.department_name, p.project_name, a.role, a.bonus_amount
FROM Employee e, Department d, Project p, Assignment a
WHERE e.department_id = d.department_id
AND e.employee_id = a.employee_id
AND a.project_id = p.project_id;
