use social_network;
create table if not exists followers (
    follower_id int not null,
    followed_id int not null,
    created_at datetime default current_timestamp,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

create table if not exists follow_log (
    log_id int primary key auto_increment,
    follower_id int,
    followed_id int,
    error_message varchar(255),
    logged_at datetime default current_timestamp
);

alter table users add column following_count int default 0;
alter table users add column followers_count int default 0;


delimiter //

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
sp: begin
    declare v_user_check int default 0;
    declare exit handler for sqlexception
    begin
        rollback;
        insert into follow_log(follower_id, followed_id, error_message) 
        values (p_follower_id, p_followed_id, 'lỗi hệ thống (sql exception)');
        select 'thất bại: lỗi hệ thống, đã rollback' as ket_qua;
    end;

    start transaction;

    if p_follower_id = p_followed_id then
        rollback;
        insert into follow_log(follower_id, followed_id, error_message) 
        values (p_follower_id, p_followed_id, 'lỗi: không thể tự follow chính mình');
        select 'thất bại: tự follow' as ket_qua;
        leave sp;
    end if;
    select count(*) into v_user_check 
    from users 
    where user_id in (p_follower_id, p_followed_id);

    if v_user_check < 2 then
        rollback;
        insert into follow_log(follower_id, followed_id, error_message) 
        values (p_follower_id, p_followed_id, 'lỗi: một trong hai user không tồn tại');
        select 'thất bại: user không tồn tại' as ket_qua;
        leave sp;
    end if;

    if exists (select 1 from followers where follower_id = p_follower_id and followed_id = p_followed_id) then
        rollback;
        select 'thông báo: đã follow người này rồi' as ket_qua;
        leave sp;
    end if;
    
    insert into followers (follower_id, followed_id) values (p_follower_id, p_followed_id);

    update users set following_count = following_count + 1 where user_id = p_follower_id;

    update users set followers_count = followers_count + 1 where user_id = p_followed_id;

    commit;
    select 'thành công: đã follow và cập nhật số liệu' as ket_qua;

end //
delimiter ;

insert into users (username) values ('nguoi_dung_c'); 

call sp_follow_user(1, 3);

select user_id, username, following_count, followers_count from users where user_id in (1, 3);
select * from followers;

call sp_follow_user(1, 1);

call sp_follow_user(1, 9999);

select * from follow_log;