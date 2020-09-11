use community;
select s.longitude, s.dimensionality, c.community_longitude, c.community_dimension from tb_supplier s, tb_community c;

select g.price,g.id as gid,g.name as gname,g.description,g.product_place,g.sales_num,g.create_time as gcreate_time,g.start_time,g.end_time, i.url,c.name as cname
              ,sg.supplier_id from tb_goods g, tb_image i, tb_category c, tb_supplier_goods sg,tb_supplier ss,tb_community co where co.id=2 and sqrt(ABS (power((co.community_longitude-ss.longitude), 2) - power((co.community_dimension-ss.dimensionality), 2))) < 5 and g.image_id = i.id and c.id = g.category_id and sg.goods_id = g.id;

select power(3,2);

select g.price,g.id as gid,g.name as gname,g.description,g.product_place,g.sales_num,g.create_time as gcreate_time,g.start_time,g.end_time, i.url,c.name as cname
              ,sg.supplier_id from tb_goods g, tb_image i, tb_category c, tb_supplier_goods sg;
              
use community;
select d.name as dname,dd.name as ddname  from tb_district d, tb_district dd where d.pid = 0 and d.id = dd.pid;
select c.username, c.phone, c.register_time as registerTime, c.profile, c.community_id  as communityId , count(ca.id) as cartsId,
(select count(id) from tb_order where customer_id = 1 and order_status = 1 and is_delete=1) as non_payment,
(select count(id) from tb_order where customer_id = 1 and order_status = 7 and is_delete=1) as not_yet_shipped,
(select count(id) from tb_order where customer_id = 1 and order_status = 12 and is_delete=1) as no_evaluation
from tb_customer c, tb_cart ca where c.id=1 and c.status=1 and ca.customer_id = c.id and ca.is_delete = 1;
select count(o.order_status),count(oo.order_status),count(oo.order_status),count(oo.order_status) from tb_order o, tb_order oo, tb_order ooo, tb_order oooo  where o.customer_id = 1 and oo.customer_id = o.customer_id;

select (select count(id) from tb_order where customer_id = 1 and order_status = 1) as non_payment, 
(select count(id) from tb_order where customer_id = 1 and order_status = 7) as not_yet_shipped,
(select count(id) from tb_order where customer_id = 1 and order_status = 12) as no_evaluation
;