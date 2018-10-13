RESTORE DATABASE Feb27_spease_data FROM DISK = 'C:\SQL\BreakingBad.bak'
WITH 
MOVE 'CUSTOMER_BUILD' TO 'C:\SQL\Customer_Build_speaseFeb27.mdf',
MOVE 'CUSTOMER_BUILD_LOG' TO 'C:\SQL\Customer_Build_speaseFeb27.ldf', stats
