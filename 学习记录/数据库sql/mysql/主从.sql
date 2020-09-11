stop slave;

change master to
master_host='127.0.0.1',
master_port=3306,
master_user='roo',
master_password='roo',
master_log_file='mysql-bin.000011',
master_log_pos=1667;

start slave;
show slave status;

show processlist;