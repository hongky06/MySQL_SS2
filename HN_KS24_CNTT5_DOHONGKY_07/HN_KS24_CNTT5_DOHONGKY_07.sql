CREATE DATABASE HN_KS24_CNTT5_DOHONGKY_07;
USE HN_KS24_CNTT5_DOHONGKY_07;

CREATE TABLE PATIENTS (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    phone_number VARCHAR(15),
    gender VARCHAR(10),
    date_of_birth DATE
);

CREATE TABLE DOCTORS (
    doctor_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    specialty VARCHAR(50),
    phone_number VARCHAR(15),
    rating FLOAT
);

CREATE TABLE APPOINTMENTS (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_time DATETIME,
    fee INT,
    status VARCHAR(20)
);

CREATE TABLE MEDICAL_RECORDS (
    record_id INT PRIMARY KEY,
    appointment_id INT,
    symptoms VARCHAR(255),
    diagnosis VARCHAR(255),
    prescription VARCHAR(255),
    record_date DATETIME
);


CREATE TABLE VISIT_LOG (
    log_id INT PRIMARY KEY,
    record_id INT,
    doctor_id INT,
    log_time DATETIME,
    note VARCHAR(255)
);
--  PHẦN 2: DML – INSERT, UPDATE, DELETE (20 ĐIỂM)
--   Câu 1 – INSERT (10 điểm)
--   Viết câu lệnh chèn dữ liệu cho tất cả các bảng

INSERT INTO PATIENTS VALUES
(1,'Nguyen Thi Lan','0901234567','Female','1999-03-12'),
(2,'Tran Van Minh','0902345678','Male','1996-11-25'),
(3,'Le Hoai Phuong','0913456789','Female','2001-07-08'),
(4,'Pham Duc Anh','0984567890','Male','1998-01-19'),
(5,'Hoang Ngoc Mai','0975678901','Female','2000-09-30');

-- INSERT DOCTORS
INSERT INTO DOCTORS VALUES
(1,'BS. Nguyen Van Hai','Noi','0931112223',4.8),
(2,'BS. Tran Thu Ha','Nhi','0932223334',5.0),
(3,'BS. Le Quoc Tuan','Ngoai','0933334445',4.6),
(4,'BS. Pham Minh Chau','Da lieu','0934445556',4.9),
(5,'BS. Hoang Gia Bao','Tim mach','0935556667',4.7);

INSERT INTO APPOINTMENTS VALUES
(7001,1,1,'2024-05-20 08:00:00',200000,'Booked'),
(7002,2,2,'2024-05-20 09:30:00',250000,'Completed'),
(7003,3,3,'2024-05-20 10:15:00',300000,'Booked'),
(7004,4,5,'2024-05-21 07:00:00',350000,'Completed'),
(7005,5,4,'2024-05-21 08:45:00',220000,'Cancelled');

INSERT INTO MEDICAL_RECORDS VALUES
(8001,7002,'Sot cao','Viem hong','Thuoc ha sot','2024-05-20 10:00:00'),
(8002,7004,'Dau nguc','Theo doi tim','Tai kham','2024-05-21 08:00:00'),
(8003,7001,'Dau bung','Roi loan tieu hoa','Men tieu hoa','2024-05-20 09:00:00'),
(8004,7003,'Dau vai','Cang co','Thuoc giam dau','2024-05-20 11:00:00'),
(8005,7005,'Ngua da','Di ung','Thuoc boi','2024-05-21 09:00:00');

INSERT INTO VISIT_LOG VALUES
(1,8003,1,'2024-05-20 09:05:00','Da kham'),
(2,8001,2,'2024-05-20 10:05:00','Hoan tat'),
(3,8004,3,'2024-05-20 11:10:00','Tu van'),
(4,8002,5,'2024-05-21 08:10:00','Tai kham'),
(5,8005,4,'2024-05-21 09:05:00','Huy hen');

-- Câu 2 – UPDATE & DELETE (10 điểm)
UPDATE APPOINTMENTS
SET fee = fee * 1.1
WHERE status = 'Completed'
AND patient_id IN (
    SELECT patient_id
    FROM PATIENTS
    WHERE YEAR(date_of_birth) < 2000
);

-- Viết câu lệnh xóa các bản ghi trong visit_log thỏa mãn:
-- Có log_time trước ngày 20/05/2024
DELETE FROM VISIT_LOG
WHERE log_time < '2024-05-20';



-- PHẦN 3: TRUY VẤN CƠ BẢN (15 ĐIỂM)
-- Câu 1
SELECT full_name, specialty, rating
FROM DOCTORS
WHERE rating > 4.7 OR specialty = 'Nhi';

-- Câu 2
SELECT full_name, phone_number
FROM PATIENTS
WHERE date_of_birth BETWEEN '1998-01-01' AND '2001-12-31'
AND phone_number LIKE '090%';

-- Câu 3
SELECT appointment_id, appointment_time, fee
FROM APPOINTMENTS
ORDER BY fee DESC
LIMIT 2 OFFSET 2;



-- PHẦN 4: TRUY VẤN NÂNG CAO (15 ĐIỂM)
-- Câu 1
SELECT
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    d.specialty,
    a.fee,
    a.appointment_time
FROM PATIENTS p, DOCTORS d, APPOINTMENTS a
WHERE p.patient_id = a.patient_id
AND d.doctor_id = a.doctor_id;

-- Câu 2
SELECT
    d.full_name,
    SUM(a.fee) AS total_fee
FROM DOCTORS d, APPOINTMENTS a
WHERE d.doctor_id = a.doctor_id
AND a.status = 'Completed'
GROUP BY d.doctor_id
HAVING total_fee > 500000;

-- Câu 3
SELECT doctor_id, full_name, rating
FROM DOCTORS
WHERE rating = (SELECT MAX(rating) FROM DOCTORS);

-- PHẦN 5: INDEX & VIEW (10 ĐIỂM)
CREATE INDEX idx_status_fee
ON APPOINTMENTS(status, fee);
CREATE VIEW doctor_summary AS
SELECT
    d.full_name,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(a.fee) AS total_revenue
FROM DOCTORS d
LEFT JOIN APPOINTMENTS a
ON d.doctor_id = a.doctor_id
AND a.status <> 'Cancelled'
GROUP BY d.doctor_id;



-- PHẦN 6: TRIGGER (10 ĐIỂM)
-- câu 1 
DELIMITER $$

CREATE TRIGGER trg_after_update_appointment
AFTER UPDATE ON APPOINTMENTS
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed' THEN
        INSERT INTO VISIT_LOG (record_id, doctor_id, note, log_time)
        SELECT 
            record_id,
            NEW.doctor_id,
            'Visit completed',
            NOW()
        FROM MEDICAL_RECORDS
        WHERE appointment_id = NEW.appointment_id;
    END IF;
END $$

DELIMITER ;


-- Câu 2 (5 điểm): Viết một trigger sao cho khi thêm mới một bản ghi vào bảng appointments
-- có trạng thái Completed thì hệ thống tự động tăng điểm đánh giá của bác sĩ tương
DELIMITER $$
CREATE TRIGGER trg_after_insert_appointment
AFTER INSERT ON APPOINTMENTS
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed' THEN
        UPDATE DOCTORS
        SET rating = IF(rating + 0.1 > 5.0, 5.0, rating + 0.1)
        WHERE doctor_id = NEW.doctor_id;
    END IF;
END $$
DELIMITER ;



