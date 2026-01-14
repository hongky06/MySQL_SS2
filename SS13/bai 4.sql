create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime default now(),
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade);)
delimiter //
create trigger before_post_update
before update on posts
for each row
begin
    if old.content != new.content then
        insert into post_history (post_id, old_content, new_content, changed_by_user_id)
        values (old.post_id, old.content, new.content, old.user_id);
    end if;
end;
//
delimiter ;

update posts 
set content = 'Hello world from Alice! (Edited)' 
where post_id = 1;

update posts 
set content = 'Alice second thoughts (Updated)' 
where post_id = 3;

select 'xem lich su chinh sua:' as trang_thai;
select * from post_history;

insert into likes (user_id, post_id, liked_at) values (3, 1, now());

select 'kiem tra posts sau khi edit va like:' as trang_thai;
select post_id, user_id, content, like_count from posts where post_id = 1;