delimiter $$
create procedure notifyfriendsonnewpost(in p_user_id int, in p_content text)
begin
    declare v_sender_name varchar(100);
    declare v_message varchar(255);

    select full_name into v_sender_name 
    from users 
    where user_id = p_user_id;

    insert into posts(user_id, content) 
    values (p_user_id, p_content);

    if v_sender_name is not null then
        set v_message = concat(v_sender_name, ' đã đăng một bài viết mới');

        insert into notifications(user_id, type, content)
        select friend_id, 'new_post', v_message
        from friends 
        where user_id = p_user_id and status = 'accepted'
        union
        select user_id, 'new_post', v_message
        from friends 
        where friend_id = p_user_id and status = 'accepted';
    end if;
end $$
delimiter ;

call notifyfriendsonnewpost(1, 'hôm nay trời đẹp quá, đi code dạo thôi!');

select * from notifications 
where type = 'new_post' 
order by created_at desc 
limit 5;

drop procedure if exists notifyfriendsonnewpost;