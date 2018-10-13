BACKUP DATABASE [name] TO DISK = 'C:\SQL\some_file.bak';

RESTORE DATABASE [new_name] 
FROM DISK = 'C:\SQL\some_file.bak';

BACKUP LOG [new_name] 
TO DISK = 'C:\SQL\some_log_file.bak';