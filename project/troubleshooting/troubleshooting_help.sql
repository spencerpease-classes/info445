/*
Backup stuff
*/

-- Full backup
BACKUP DATABASE group9_project TO DISK = 'C:\SQL\group9_project.bak'
GO

-- take diff backup
BACKUP DATABASE group9_project TO DISK = 'C:\SQL\group9_project.bak'
WITH DIFFERENTIAL
GO

-- take log backup
BACKUP LOG group9_project TO DISK = 'C:\SQL\group9_project.bak'
GO

-- Full restore
RESTORE DATABASE group9_project FROM DISK = 'C:\SQL\group9_project.bak'


-- Other stuff
RESTORE HEADERONLY FROM DISK = 'C:\SQL\group9_project.bak'

RESTORE DATABASE group9_project
FROM DISK = 'C:\SQL\group9_project.bak'
WITH NORECOVERY
GO

RESTORE DATABASE group9_project
FROM DISK = 'C:\SQL\group9_project.bak'
WITH FILE = ,
NORECOVERY 
GO

RESTORE LOG group9_project
FROM DISK = 'C:\SQL\group9_project.bak'
WITH FILE = ,
RECOVERY
GO

