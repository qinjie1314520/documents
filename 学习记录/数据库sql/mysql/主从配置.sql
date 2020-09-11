CREATE USER 'roo'@'%' IDENTIFIED BY 'roo';
flush privileges;
GRANT REPLICATION SLAVE ON *.* TO 'roo'@'%';
show master status;

