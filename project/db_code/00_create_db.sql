USE master
GO

-- Make sure nothing is conneccted to db

DROP DATABASE spease_project_tmp
GO

CREATE DATABASE group9_project_tmp
GO

USE spease_project_tmp
GO

/*
Backup db:

BACKUP DATABASE group9_project_tmp TO DISK = 'C:\SQL\group9_project_tmp.bak'
GO

*/