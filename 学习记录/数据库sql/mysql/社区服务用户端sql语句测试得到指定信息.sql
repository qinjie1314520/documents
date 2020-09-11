use community;
select * from tb_goods;
select c1.id, c2.id from tb_category c1, tb_category c2 where c1.id = c2.pid;

select * from tb_goods where id in (select c2.id from tb_category c1, tb_category c2 where c1.id = 1 and c1.id = c2.pid)
