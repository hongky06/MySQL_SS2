use social_network;

create table if not exists friend_requests (
    request_id int primary key auto_increment,
    from_user_id int not null,
    to_user_id int not null,
    status enum('pending','accepted','rejected') default 'pending',
    foreign key (from_user_id) references users(user_id),
    foreign key (to_user_id) references users(user_id)
);

create table if not exists friends (
    user_id int not null,
    friend_id int not null,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);

alter table users add column friends_count int default 0;

delimiter //
create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from_user_id int;
    
    declare exit handler for sqlexception
    begin
        rollback;
        select 'thất bại: lỗi hệ thống hoặc dữ liệu không hợp lệ' as ket_qua;
    end;

    set transaction isolation level repeatable read;

    start transaction;

    select from_user_id into v_from_user_id
    from friend_requests
    where request_id = p_request_id 
      and to_user_id = p_to_user_id 
      and status = 'pending'
    for update;

    if v_from_user_id is null then
        rollback;
        select 'thất bại: yêu cầu không tồn tại hoặc trạng thái không đúng' as ket_qua;
    else
        insert into friends (user_id, friend_id) values (v_from_user_id, p_to_user_id);
        insert into friends (user_id, friend_id) values (p_to_user_id, v_from_user_id);

        update users 
        set friends_count = friends_count + 1 
        where user_id = v_from_user_id;

        update users 
        set friends_count = friends_count + 1 
        where user_id = p_to_user_id;

        update friend_requests 
        set status = 'accepted' 
        where request_id = p_request_id;

        commit;
        select 'thành công: đã chấp nhận lời mời kết bạn' as ket_qua;
    end if;

end //
delimiter ;

insert into users (username) values ('nguoi_gui');
set @user_a = last_insert_id();
insert into users (username) values ('nguoi_nhan');
set @user_b = last_insert_id();

insert into friend_requests (from_user_id, to_user_id, status) values (@user_a, @user_b, 'pending');
set @req_id = last_insert_id();

call sp_accept_friend_request(@req_id, @user_b);

select * from friend_requests where request_id = @req_id;
select * from friends where user_id in (@user_a, @user_b);
select user_id, username, friends_count from users where user_id in (@user_a, @user_b);

call sp_accept_friend_request(@req_id, @user_b);