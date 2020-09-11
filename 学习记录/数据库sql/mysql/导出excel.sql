use one;
select id, name, gender, number, phone, entry_time, license_grade, license_time, 
effective_time, status, deleted from tb_driver order by id asc into outfile "G:/2.xls" CHARACTER SET gbk;

