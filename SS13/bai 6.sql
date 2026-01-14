create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending','accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);
delimiter //
create trigger tg_follow_after_insert
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end //
delimiter ;
delimiter //

create trigger tg_follow_after_delete
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end //

delimiter ;
delimiter //

create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending','accepted')
)
begin
    -- không được tự follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'khong the tu follow chinh minh';
    end if;

    -- đã tồn tại quan hệ
    if exists (
        select 1 from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        -- nếu tồn tại thì coi như unfollow
        delete from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id;
    else
        -- chưa tồn tại thì follow
        insert into friendships(follower_id, followee_id, status)
        values (p_follower_id, p_followee_id, p_status);
    end if;
end //

delimiter ;

create view user_profile as
select 
    u.user_id,
    u.username,
    u.follower_count,
    count(distinct p.post_id) as post_count,
    count(l.post_id) as total_likes,
    group_concat(distinct p.content order by p.created_at desc separator ' | ') as recent_posts
from users u
left join posts p on u.user_id = p.user_id
left join likes l on p.post_id = l.post_id
group by u.user_id, u.username, u.follower_count;

call follow_user(1, 2, 'accepted');
select follower_count from users where user_id = 2;

select * from user_profile where user_id = 2;