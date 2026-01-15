use social_network;

create table if not exists likes (
    like_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id),
    unique key unique_like (post_id, user_id)
);

alter table posts add column likes_count int default 0;

delimiter //

create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        select 'thất bại: đã like rồi hoặc id không tồn tại. rollback!' as trang_thai;
    end;
    start transaction;

    insert into likes (user_id, post_id)
    values (p_user_id, p_post_id);

    update posts 
    set likes_count = likes_count + 1 
    where post_id = p_post_id;

    commit;
    select 'thành công: đã like bài viết.' as trang_thai;

end //
delimiter ;

insert into users (username) values ('nguyen_van_b');

call sp_like_post(1, 1);

select * from likes;
select post_id, content, likes_count from posts where post_id = 1;


call sp_like_post(1, 1);

select post_id, content, likes_count from posts where post_id = 1;