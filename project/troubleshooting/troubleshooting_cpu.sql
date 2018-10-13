SELECT * FROM sys.dm_os_performance_counters
WHERE counter_name LIKE '%CPU%'
ORDER BY counter_name
