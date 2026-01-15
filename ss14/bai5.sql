use social_network;

create table if not exists delete_log (
    log_id int primary key auto_increment,
    post_id int not null,
    deleted_by int not null,
    deleted_at datetime default current_timestamp
);

delimiter //
create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_check int default 0;

    declare exit handler for sqlexception
    begin
        rollback;
        select 'thất bại: lỗi hệ thống hoặc vi phạm ràng buộc' as ket_qua;
    end;

    start transaction;

    select count(*) into v_check 
    from posts 
    where post_id = p_post_id and user_id = p_user_id;

    if v_check = 0 then
        rollback;
        select 'thất bại: bài viết không tồn tại hoặc bạn không phải là chủ sở hữu' as ket_qua;
    else
        delete from likes where post_id = p_post_id;
        delete from comments where post_id = p_post_id;
        delete from posts where post_id = p_post_id;

        update users 
        set posts_count = posts_count - 1 
        where user_id = p_user_id;

        insert into delete_log(post_id, deleted_by) 
        values (p_post_id, p_user_id);

        commit;
        select 'thành công: đã xóa bài viết và cập nhật dữ liệu' as ket_qua;
    end if;

end //
delimiter ;

insert into posts (user_id, content) values (1, 'bài viết sắp bị xóa');
set @new_post_id = last_insert_id();
update users set posts_count = posts_count + 1 where user_id = 1;

call sp_delete_post(@new_post_id, 999);

select * from posts where post_id = @new_post_id;
select * from delete_log;

call sp_delete_post(@new_post_id, 1);

select * from posts where post_id = @new_post_id;
select * from users where user_id = 1;
select * from delete_log;