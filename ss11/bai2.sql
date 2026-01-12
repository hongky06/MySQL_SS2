delimiter $$
create procedure CalculatePostLikes(In p_post_id int, Out total_likes int)
begin
	select count(*) into total_likes 
    from likes 
    where post_id = p_post_id;
    
end $$
delimiter ;

call calculatepostlikes(101, @likes);
select @likes as tong_so_like;

drop procedure if exists calculatepostlikes;