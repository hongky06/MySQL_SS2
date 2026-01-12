delimiter $$
create procedure getUser(p_user_id int )
begin
	select post_id, content, created_at from posts where user_id = p_user_id;
end $$
delimiter ;

CALL getUser(9);
drop procedure getUser;