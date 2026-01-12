delimiter $$
create procedure calculateuseractivityscore(in p_user_id int, out activity_score int, out activity_level varchar(50))
begin
    declare v_post_count int default 0;
    declare v_comment_count int default 0;
    declare v_like_received_count int default 0;
    
    select count(*) into v_post_count 
    from posts 
    where user_id = p_user_id;

    select count(*) into v_comment_count 
    from comments 
    where user_id = p_user_id;

    select count(*) into v_like_received_count 
    from likes l
    join posts p on l.post_id = p.post_id
    where p.user_id = p_user_id;

    set activity_score = (v_post_count * 10) + (v_comment_count * 5) + (v_like_received_count * 3);

    case 
        when activity_score > 500 then set activity_level = 'rất tích cực';
        when activity_score >= 200 then set activity_level = 'tích cực';
        else set activity_level = 'bình thường';
    end case;
end $$
delimiter ;

call calculateuseractivityscore(1, @score, @lvl);
select @score as activity_score, @lvl as activity_level;

drop procedure if exists calculateuseractivityscore;