drop database if exists social_network;
create database social_network;
use social_network;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    posts_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

insert into users (username) values ('nguyen_van_a');

delimiter //
create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        select concat('thất bại: user_id ', p_user_id, ' không tồn tại hoặc lỗi hệ thống. đã rollback!') as ket_qua;
    end;

    start transaction;
    insert into posts (user_id, content) 
    values (p_user_id, p_content);

    update users 
    set posts_count = posts_count + 1 
    where user_id = p_user_id;
    
    commit;
    select 'thành công: bài viết đã được đăng và cập nhật số lượng.' as ket_qua;

end //

delimiter ;

call sp_create_post(1, 'đây là bài viết hợp lệ đầu tiên');

select * from users;
select * from posts;

call sp_create_post(999, 'bài viết này sẽ bị rollback');

select * from users;
select * from posts;