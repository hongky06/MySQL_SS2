use social_network;

create table if not exists comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

alter table posts add column comments_count int default 0;

delimiter //
create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    declare exit handler for sqlexception
    begin
        rollback to savepoint after_insert;
        commit;
        select 'lỗi update: đã rollback về after_insert (comment vẫn được lưu)' as ket_qua;
    end;

    start transaction;

    insert into comments (post_id, user_id, content) 
    values (p_post_id, p_user_id, p_content);

    savepoint after_insert;

    if p_content = 'test_loi' then
        signal sqlstate '45000' set message_text = 'lỗi giả định';
    else
        update posts 
        set comments_count = comments_count + 1 
        where post_id = p_post_id;
    end if;

    commit;
    select 'thành công: đã lưu comment và update count' as ket_qua;
end //
delimiter ;

call sp_post_comment(1, 1, 'bình luận hợp lệ');

select * from comments order by comment_id desc limit 1;
select post_id, comments_count from posts where post_id = 1;

call sp_post_comment(1, 1, 'test_loi');

select * from comments order by comment_id desc limit 1;
select post_id, comments_count from posts where post_id = 1;