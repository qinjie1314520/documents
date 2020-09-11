use one;
select * from tb_truck_type order by id asc limit 5,5;

select * from identity where identity like '/%' escape '/';

select * from identity;

select avg(num) from identity;

select sum(num) from identity;

select * from tb_driver group by gender;

select sname, sno, ssex from student where sname like '刘%' or sname like '王%';
				
select sname, sno, ssex from student where sname like '%DB_' and sname like '王%';

select t.*,tt.name  from tb_department t, tb_department tt where tt.pid = t.id;

 select avg(role_id), sum(resource_id) from tb_role_resource group by role_id having count(*)<5;
 