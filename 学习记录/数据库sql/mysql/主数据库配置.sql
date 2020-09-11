CREATE USER 'slave'@'%' IDENTIFIED BY 'slave';#创建用户
GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';#授权

show master status;



从数据库
change master to master_host='139.9.87.17',master_user='slave',master_password='slave',master_port=3306,master_log_file='mysql-bin.000003',master_log_pos=155;
start slave;
stop slave;
show slave status;