delimiter $$
create procedure calculatebonuspoints(in p_user_id int, inout p_bonus_points int)
begin
    declare v_post_count int; -- tao bien 
    select count(*) into v_post_count -- gan count vaof bien
    from posts 
    where user_id = p_user_id;
    if v_post_count >= 20 then
        set p_bonus_points = p_bonus_points + 100;
    elseif v_post_count >= 10 then
        set p_bonus_points = p_bonus_points + 50;
    end if;
end $$
delimiter ;

set @diem = 100;
call calculatebonuspoints(1, @diem);
select @diem as diem_sau_khi_thuong;
drop procedure calculatebonuspoints;