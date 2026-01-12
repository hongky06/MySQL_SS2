delimiter $$
create procedure createpostwithvalidation(in p_user_id int, in p_content text, out result_message varchar(255))
begin
    if char_length(p_content) < 5 then
        set result_message = 'nội dung quá ngắn';
    else
        insert into posts(user_id, content) values (p_user_id, p_content);
        set result_message = 'thêm bài viết thành công';
    end if;
end $$
delimiter ;

call createpostwithvalidation(1, 'alo', @thong_bao_1);
select @thong_bao_1 as ket_qua_test_1;

call createpostwithvalidation(1, 'xin chào, đây là bài viết test', @thong_bao_2);
select @thong_bao_2 as ket_qua_test_2;

select * from posts order by post_id desc limit 1;

drop procedure if exists createpostwithvalidation;