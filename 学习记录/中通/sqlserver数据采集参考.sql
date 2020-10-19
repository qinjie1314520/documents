-- sqlserver 版本查看
-- Microsoft SQL Server 2017 (RTM) - 14.0.1000.169 (X64) 
SELECT @@VERSION;


-- sys.dm_os_sys_memory：从操作系统返回内存信息
-- total_physical_memory_kb ：可供操作系统使用的总物理内存大小，单位为千字节 (KB)。
-- available_physical_memory_kb ：可用物理内存的大小，单位为 KB。
-- total_page_file_kb ：操作系统报告的提交限制的大小，单位为 KB。
-- 
SELECT total_physical_memory_kb, available_physical_memory_kb, total_page_file_kb, available_page_file_kb 
from sys.dm_os_sys_memory;

-- 当前每个数据库所占用了多少数据缓存
SELECT CASE database_id WHEN 32767 THEN 'ResourceDb'
	ELSE DB_NAME(database_id) END AS 'Database',
COUNT(*)*8/1024 AS 'Cached Size(MB)'
FROM sys.dm_os_buffer_descriptors
GROUP BY DB_NAME(database_id),database_id ORDER BY 'Cached Size(MB)' DESC;


SELECT  
estimated_completion_time/1000/60, 
[start_time] AS '开始时间', 
[status] AS '状态', 
[command] AS '命令', 
dest.[text] AS 'sql语句', 
DB_NAME([database_id]) AS '数据库名', 
[blocking_session_id] AS '正在阻塞其他会话的会话ID', 
[wait_type] AS '等待资源类型', 
[wait_time] AS '等待时间', 
[wait_resource] AS '等待的资源', 
[reads] AS '物理读次数', 
[writes] AS '写次数', 
[logical_reads] AS '逻辑读次数', 
percent_complete 
FROM sys.[dm_exec_requests] AS der 
outer APPLY 
sys.[dm_exec_sql_text](der.[sql_handle]) AS dest 
left join sys.dm_exec_connections con 
on der.session_id=con.session_id 
--WHERE der.[session_id]>50 -- AND 
--DB_NAME(der.[database_id])='' 
ORDER BY [reads] DESC;


-- 查询SqlServer总体的内存使用情况
select  type
        , sum(virtual_memory_reserved_kb) VM_Reserved
        , sum(virtual_memory_committed_kb) VM_Commited
        , sum(awe_allocated_kb) AWE_Allocated
        , sum(shared_memory_reserved_kb) Shared_Reserved
        , sum(shared_memory_committed_kb) Shared_Commited
from   sys.dm_os_memory_clerks
group by type order by type;


-- 查询当前数据库缓存的所有数据页面，哪些数据表，缓存的数据页面数量
-- 从这些信息可以看出，系统经常要访问的都是哪些表，有多大？
select p.object_id, object_name=object_name(p.object_id), p.index_id, buffer_pages=count(*) 
from sys.allocation_units a, 
    sys.dm_os_buffer_descriptors b, 
    sys.partitions p 
where a.allocation_unit_id=b.allocation_unit_id 
    and a.container_id=p.hobt_id 
    and b.database_id=db_id()
group by p.object_id,p.index_id 
order by buffer_pages desc;
 
 
-- 查看数据库在数据缓存（data cache）中占用的空间大小
-- 由于每个数据页对应动态管理视图（dynamic management view，DMV）中的一行，为128 字节，为1/8个千字节（KB）
select count(*)*8/1024 as 'Cached Size(MB)',
       case database_id when 32767 then 'ResoureDb'
                        else DB_NAME(database_id) end as 'Database',
       database_id
from sys.dm_os_buffer_descriptors
group by DB_NAME(database_id),database_id
order by 'Cached Size(MB)' desc;

--数据库状态
select name,state_desc  from sys.databases;

--数据库大小
EXEC sp_spaceused;


--数据库服务器各数据库日志文件的大小及利用率
 DBCC SQLPERF(LOGSPACE);
 
 -- 数据库连接数
Select * from sys.dm_exec_connections;

-- 用户会话数(3种方式 都可)
-- 1：
	SP_WHO;
-- 2：
	select * from master.dbo.sysprocesses;

-- 3：
select session_id,status,login_name,login_time,* from sys.dm_exec_sessions;

-- 查询进程
/* 
blocked:
	-2 = 阻塞资源由孤立的分布式事务拥有。
	-3 = 阻塞资源由延迟的恢复事务拥有。
	-4 = 由于内部闩锁状态转换而无法确定阻塞闩锁所有者的会话 ID。
*/
select spid,blocked,waittime,cpu,physical_io,open_tran,status from sys.sysprocesses;


select DB_NAME(database_id) as DBNAME,
    database_id,
    file_id,
    io_stall,
    io_pending_ms_ticks,
    scheduler_address
from sys.dm_io_virtual_file_stats(null,null)i ,
sys.dm_io_pending_io_requests s
where s.io_handle = i.file_handle
