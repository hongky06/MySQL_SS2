drop trigger if exists before_user_insert;
drop procedure if exists add_user;

delimiter //
create trigger before_user_insert
before insert on users
for each row
begin
    if new.email not like '%@%' or new.email not like '%.%' then
        signal sqlstate '45000' 
        set message_text = 'error: email khong hop le (phai chua @ va .)';
    end if;

    if new.username not regexp '^[a-zA-Z0-9_]+$' then
        signal sqlstate '45000' 
        set message_text = 'error: username chua ky tu dac biet (chi chap nhan chu, so va _)';
    end if;
end //

create procedure add_user(
    in p_username varchar(50), 
    in p_email varchar(100), 
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end //
delimiter ;

call add_user('david_01', 'david.working@example.com', curdate());
call add_user('eve', 'eve@examplecom', curdate());
call add_user('frank $ dollar', 'frank@example.com', curdate());
select 'danh sach user hien tai:' as trang_thai;
select * from users;