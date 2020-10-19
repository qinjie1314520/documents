-- Check Intance is active and open  检查实例状态是否可用
select count(*) retvalue from v$instance where status = 'OPEN' and logins = 'ALLOWED'  and database_status = 'ACTIVE';

-- Total size(MB) of all datafiles (without temp)	数据库文件占用的总大小
select round(sum(bytes/1024/1024)) || ' MB' retvalue from dba_data_files;

-- Total size(MB) of all datafiles have been used (without temp)	数据库已经使用的大小
select round(sum(a.bytes - f.bytes)/1024/1024) || ' MB' retvalue from 
	  (select tablespace_name, sum(bytes) bytes from dba_data_files group by tablespace_name) a, 
	  (select tablespace_name, sum(bytes) bytes from dba_free_space group by tablespace_name) f 
	  where a.tablespace_name = f.tablespace_name;
							
-- List tablespace names in JSON format for Zabbix auto discover		
select tablespace_name from dba_tablespaces where contents <> 'TEMPORARY'; 

-- Get tablespace size(MB) has been used 表空间使用大小
select a.tablespace_name,round(sum(a.bytes - f.bytes)/1024/1024) || ' MB' retvalue from 
	  (select tablespace_name, sum(bytes) bytes from dba_data_files group by tablespace_name) a,
	  (select tablespace_name, sum(bytes) bytes from dba_free_space group by tablespace_name) f 
	  where a.tablespace_name = f.tablespace_name GROUP BY a.tablespace_name;
		
	-- Get tablespace usage 某个表空间使用率
select a.tablespace_name,round((a.bytes_alloc - f.bytes_free)*100/a.bytes_total)||'%' retvalue from 
	  (select tablespace_name, sum(bytes) bytes_alloc, sum(greatest(bytes,maxbytes)) bytes_total 
	  from dba_data_files group by tablespace_name) a, 
	  (select tablespace_name, sum(bytes) bytes_free from dba_free_space group by tablespace_name) f 
	  where a.tablespace_name = f.tablespace_name; 
		
	-- List temporary tablespace names in JSON format for Zabbix auto discover 所有临时表空间名称
select tablespace_name from dba_tablespaces where contents = 'TEMPORARY';

-- Get temporary tablespace usage 临时表空间使用率
select a.tablespace_name,nvl(round(used*100/total)||'%', '0') retvalue from 
	  (select tablespace_name, sum(greatest(bytes, maxbytes)) total from dba_temp_files 
	  group by tablespace_name) a, 
	  (select tablespace, sum(blocks*8192) used from v$tempseg_usage group by tablespace) f 
	  where a.tablespace_name = f.tablespace;

-- List ASM volumes in JSON format for Zabbix auto discover asm磁盘组名字
select name from v$asm_diskgroup;

-- Get ASM volume usage asm磁盘组使用率
select name,round(100 * (1 - usable_file_mb*(decode(type,'EXTERN',1,'NORMAL',3,'HIGH',5))/total_mb))||'%'
	  retvalue from v$asm_diskgroup;
		
	-- Query the Fast Recovery Area usage  闪回区（快速回复区）使用率
select round(space_used*100/space_limit)||'%' retvalue from v$recovery_file_dest

-- List open user in JSON format for Zabbix auto discover 所有状态为 open 的用户
select username from dba_users where account_status = 'OPEN';

-- If user status not change, then 1, otherwise 0 用户是否被锁
select username,decode(account_status, 'OPEN', '1', '0') retvalue from dba_users;         
								   
-- Query active sessions 活动会话数
select count(*) retvalue from v$session where status = 'ACTIVE';   

-- Query max processes  最大的进程  啥意思？
select round(max_utilization*100/limit_value) retvalue from v$resource_limit where resource_name = 'processes'              
-- Query table is locked over 10 minites 超过10分钟的表锁或行锁 
select count(*) retvalue from v$lock where type in('TM', 'TX') and ctime > 600;
	
-- Deadlocks 死锁发生次数
select value retvalue from v$sysstat where name = 'enqueue deadlocks';    
		
-- Redo Writes lgwr写日志文件的次数
select value retvalue from v$sysstat  where name = 'redo writes';

-- User Commits 用户提交次数
select value retvalue from v$sysstat where name = 'user commits';

-- User Rollbacks 用户回滚次数
select value retvalue from v$sysstat  where name = 'user rollbacks';
			
-- Hard parse ratio 硬解析率
select round(h.value/t.value*100) || '%' retvalue from v$sysstat h, v$sysstat t 
	where h.name = 'parse count (hard)' and t.name = 'parse count (total)';
		  
-- Read Cache hit ratio 21/5000 读取缓存命中率
select round((1 - (phy.value - lob.value - dir.value)/ses.value) * 100) || '%' retvalue 
	  from v$sysstat ses, v$sysstat dir, v$sysstat lob, v$sysstat phy 
	  where ses.name = 'session logical reads' 
	  and dir.name = 'physical reads direct' 
	  and lob.name = 'physical reads direct (lob)' 
	  and phy.name = 'physical reads';

-- Disk sorts ratio 磁盘排序比率 啥意思
select round(d.value/(d.value + m.value) * 100) || '%' retvalue 
	  from v$sysstat m, v$sysstat d 
	  where m.name = 'sorts (memory)' and d.name = 'sorts (disk)';

-- Table scans (long tables) 大表（全表）扫描次数
select value retvalue from v$sysstat  where name = 'table scans (long tables)';

-- Index fast full scans (full) 索引快速全扫描次数
select value retvalue from v$sysstat  where name = 'index fast full scans (full)'; 

-- Bytes(MB) sent via SQL*Net to client 服务器发送给客户端字节数
select round(value/1024/1024) || ' MB' retvalue from v$sysstat  where name = 'bytes sent via SQL*Net to client';

-- Bytes(MB) received via SQL*Net from client 客户端发送给服务器的字节数
select round(value/1024/1024) || ' MB' retvalue from v$sysstat 
	  where name = 'bytes received via SQL*Net from client';

-- CPU的消耗在用户级别调用上的比例
select intsize_csec,value from v$sysmetric where metric_name = 'Database CPU Time Ratio' and  intsize_csec > 3000;
-- CPU的消耗在非空闲等待上的比例
select intsize_csec,value from v$sysmetric where metric_name = 'Database Wait Time Ratio' and  intsize_csec > 3000;
-- CPU运行时间，单位毫秒/每秒
select intsize_csec,value from v$sysmetric where metric_name = 'Database Time Per Sec' and  intsize_csec > 3000;
	
-- Get session event name which more than 20 获取超过20个的会话事件名称
select event from (select wait_class, event, count(*) from v$session 
	  where wait_class <> 'Idle' group by wait_class, event having count(*) > 20 
	  order by count(*) desc) where rownum <= 1;
		  
-- Free buffer waits 空闲缓冲区等待
select nvl(time_waited, '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'free buffer waits';

-- Buffer busy waits 缓冲繁忙等待
select nvl(time_waited, '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'buffer busy waits';

-- Log file switch completion 日志文件切换完成
select nvl(time_waited, '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'log file switch completion';

-- Log file sync 日志文件同步
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'log file sync';

-- Log file parallel write 日志文件并行写入
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'log file parallel write';

-- DB file sequential read 文件顺序读取
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'db file sequential read';

-- DB file scattered read 文件分散读取
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'db file scattered read';

-- DB file single write 文件单写
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'db file single write';

-- DB file parallel write 文件并行写入
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'db file parallel write';

-- Direct path read 直接路径读取
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'direct path read';

-- Direct path write 直接路径写入
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'direct path write';

-- latch free 无闩锁
select nvl(to_char(time_waited, 'FM99999999999999990'), '0') retvalue 
	  from v$system_event se, v$event_name en 
	  where se.event(+) = en.name and en.name = 'latch free';