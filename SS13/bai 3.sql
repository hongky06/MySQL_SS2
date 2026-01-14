drop trigger if exists before_like_insert;
drop trigger if exists after_like_insert;
drop trigger if exists after_like_delete;
drop trigger if exists after_like_update;

delimiter //

create trigger before_like_insert
before insert on likes
for each row
begin
    declare post_owner_id int;
    select user_id into post_owner_id from posts where post_id = new.post_id;
    if new.user_id = post_owner_id then
        signal sqlstate '45000' set message_text = 'error: khong the like bai viet cua chinh minh!';
    end if;
end;
//

create trigger after_like_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end;
//

create trigger after_like_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end;
//

create trigger after_like_update
after update on likes
for each row
begin
    if old.post_id != new.post_id then
        update posts 
        set like_count = like_count - 1 
        where post_id = old.post_id;
        
        update posts 
        set like_count = like_count + 1 
        where post_id = new.post_id;
    end if;
end;
//

delimiter ;

insert ignore into likes (user_id, post_id, liked_at) values (1, 1, now());

insert into likes (user_id, post_id, liked_at) values (2, 1, now());

select post_id, content, like_count from posts where post_id = 1;

update likes 
set post_id = 3 
where user_id = 2 and post_id = 1;

select post_id, content, like_count from posts where post_id in (1, 3);

delete from likes where user_id = 2 and post_id = 3;

select post_id, content, like_count from posts where post_id = 3;

select * from user_statistics;