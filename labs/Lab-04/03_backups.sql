USE Lab3_445_spease
GO

/* ------------------------------------------------------------
Take backups of the database, alter it, drop it, and restore it
------------------------------------------------------------ */

-- initial full backup
BACKUP DATABASE Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
GO

-- insert rows in tblORDER
EXEC uspInsertOrder_wrapper
    @Run = 1000
GO

-- Take diff backup
BACKUP DATABASE Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
WITH DIFFERENTIAL
GO

-- take log backup
BACKUP LOG Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
GO

-- Alternate executing the wrapper and taking LOG or DIFFERENTIAL backups
EXEC uspInsertOrder_wrapper
    @Run = 5
GO

BACKUP LOG Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
GO

EXEC uspInsertOrder_wrapper
    @Run = 25
GO

BACKUP DATABASE Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
WITH DIFFERENTIAL
GO

EXEC uspInsertOrder_wrapper
    @Run = 50
GO

BACKUP LOG Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
GO

EXEC uspInsertOrder_wrapper
    @Run = 75
GO

BACKUP DATABASE Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
WITH DIFFERENTIAL
GO

EXEC uspInsertOrder_wrapper
    @Run = 5
GO

BACKUP LOG Lab3_445_spease TO DISK = 'C:\SQL\Lab3_445_spease.bak'
GO


-- drop and restore database
USE master
GO
DROP DATABASE Lab3_445_spease
GO

RESTORE HEADERONLY FROM DISK = 'C:\SQL\Lab3_445_spease.bak'

RESTORE DATABASE Lab3_445_spease
FROM DISK = 'C:\SQL\Lab3_445_spease.bak'
WITH NORECOVERY
GO

RESTORE DATABASE Lab3_445_spease
FROM DISK = 'C:\SQL\Lab3_445_spease.bak'
WITH FILE = 7,
NORECOVERY 
GO

RESTORE LOG Lab3_445_spease
FROM DISK = 'C:\SQL\Lab3_445_spease.bak'
WITH FILE = 8,
RECOVERY
GO

USE Lab3_445_spease
GO

SELECT COUNT(*) FROM tblORDER

