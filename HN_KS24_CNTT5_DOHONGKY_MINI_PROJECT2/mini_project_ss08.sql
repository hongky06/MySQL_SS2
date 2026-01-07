CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) 
VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) 
VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) 
VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày


-- Liệt kê tên khách và số điện thoại của tất cả khách hàng
select guest_name, phone from guests ;

-- Liệt kê các loại phòng khác nhau trong khách sạn  
select * from rooms ;

-- Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần
select * from rooms  ;

-- Hiển thị các phòng có giá thuê lớn hơn 1.000.000

 select * from rooms 
 where  price_per_day >  1000000 ; 
 
 
 -- Liệt kê các lần đặt phòng diễn ra trong năm 2024
 
 select * from bookings 
 where check_in >= '2024-01-01' and check_out < '2025-01-01';


-- Cho biết số lượng phòng của từng loại phòng 
 select room_type ,  count(*) from rooms
 group by room_type ;
 
 
-- PHẦN II – TRUY VẤN NÂNG CAO
-- Hãy liệt kê danh sách các lần đặt phòng, Với mỗi lần đặt phòng, hãy hiển thị:
-- Tên khách hàng
-- Loại phòng đã đặt
-- Ngày nhận phòng (check_in)

-- danh sách các lần đặt phòng (tên khách, loại phòng, ngày nhận)
select g.guest_name,
       r.room_type,
       b.check_in
from bookings b
join guests g on b.guest_id = g.guest_id
-- gộp tất cả những khách hàng nếu như trong danh sách đặt hàng có id của khách hàng
join rooms r on b.room_id = r.room_id;
-- gộp tất cả những đơn hàng nếu như id của đơn đặt hàng có trong dánh phòng

-- mỗi khách đã đặt phòng bao nhiêu lần
select g.guest_name,
       count(b.booking_id) as so_lan_dat
from guests g
left join bookings b on g.guest_id = b.guest_id
group by g.guest_id;

-- doanh thu của mỗi phòng
select r.room_id,
       r.room_type,
       (b.check_out - b.check_in) * r.price_per_day as doanh_thu
from bookings b
join rooms r on b.room_id = r.room_id;

-- tổng doanh thu của từng loại phòng
select r.room_type,
       sum((b.check_out - b.check_in) * r.price_per_day) as tong_doanh_thu
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_type;

-- khách đặt phòng từ 2 lần trở lên
select g.guest_name,
       count(b.booking_id) as so_lan_dat
from guests g
join bookings b on g.guest_id = b.guest_id
group by g.guest_id
having count(b.booking_id) >= 2;

-- loại phòng có số lượt đặt nhiều nhất
select r.room_type,
       count(b.booking_id) as so_luot_dat
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_type
having count(b.booking_id) = (
    select max(sl)
    from (
        select count(*) as sl
        from bookings b2
        join rooms r2 on b2.room_id = r2.room_id
        group by r2.room_type
    ) as tmp
);



-- PHẦN III – TRUY VẤN LỒNG
-- phòng có giá thuê cao hơn giá trung bình
select *
from rooms
where price_per_day > (
    select avg(price_per_day)
    from rooms
);

-- Hiển thị những khách chưa từng đặt phòng
select *
from guests
where guest_id not in (
    select guest_id
    from bookings
);

-- Tìm phòng được đặt nhiều lần nhất
select r.room_id,
       r.room_type,
       count(b.booking_id) as so_lan_dat
from rooms r
join bookings b on r.room_id = b.room_id
group by r.room_id
having count(b.booking_id) = (
    select max(sl)
    from (
        select count(*) as sl
        from bookings
        group by room_id
    ) as t
);
 

 
 