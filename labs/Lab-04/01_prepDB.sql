/* ----------------------------- 
Create intitial database for Lab
----------------------------- */

-- Drop any existing database
USE master
GO
DROP DATABASE Lab3_445_spease
GO

-- Restore template to database
RESTORE DATABASE Lab3_445_spease FROM DISK = 'C:\SQL\Lab3_445_Template.bak'
WITH 
MOVE 'Lab3_445' TO 'C:\SQL\Lab3_445_spease.mdf',
MOVE 'Lab3_445_log' TO 'C:\SQL\Lab3_445_spease.ldf', RECOVERY, STATS
GO

USE Lab3_445_spease
GO


/* ---------------------
Create stored procedures
--------------------- */


-- Get Customer ID
CREATE PROCEDURE uspGetCustID

    @CustFName VARCHAR(60),
    @CustLName VARCHAR(60),
    @CustDOB DATE,
    @CustZIP VARCHAR(25),
    @CustID INT OUTPUT

    AS

    SET @CustID = (
        SELECT CustomerID FROM tblCUSTOMER
        WHERE CustomerFname = @CustFName 
        AND CustomerLname = @CustLName
        AND DateOfBirth = @CustDOB
        AND CustomerZIP = @CustZIP
    )

    IF @CustID IS NULL
    BEGIN
        PRINT 'Could not find CustomerID'
        RAISERROR('@CustID cannot be NULL', 11, 1)
        RETURN
    END

GO

-- Get Product ID
CREATE PROCEDURE uspGetProdID

    @ProdName VARCHAR(100),
    @ProdID INT OUTPUT

    AS

    SET @ProdID = (
        SELECT ProductID FROM tblPRODUCT
        WHERE ProductName = @ProdName
    )

    IF @ProdID IS NULL
    BEGIN
        PRINT 'Could not find ProductID'
        RAISERROR('@ProdID cannot be NULL', 11, 1)
        RETURN
    END

GO

-- Insert a new row into ORDER
CREATE PROCEDURE uspInsertOrder

@CustFName VARCHAR(60),
@CustLName VARCHAR(60),
@CustDOB DATE,
@CustZIP VARCHAR(25),
@ProdName VARCHAR(100),
@Quantity NUMERIC(5,0),
@OrderDate DATE

AS

DECLARE @P_ID INT
DECLARE @C_ID INT

IF @OrderDate IS NULL
BEGIN
    SET @OrderDate = (SELECT GetDate())
END

EXEC uspGetProdID
@ProdName = @ProdName,
@ProdID = @P_ID OUTPUT

EXEC uspGetCustID
@CustFName = @CustFName,
@CustLName = @CustLName,
@CustDOB = @CustDOB,
@CustZIP = @CustZIP,
@CustID = @C_ID OUTPUT

IF @C_ID IS NULL
BEGIN
    PRINT '@C_ID IS NULL and will fail on insert statement; process terminated'
    RAISERROR ('CustomerID variable @C_ID cannot be NULL', 11,1)
    RETURN
END

IF @P_ID IS NULL
BEGIN
    PRINT '@P_ID IS NULL and will fail on insert statement; process terminated'
    RAISERROR ('ProductID variable @P_ID cannot be NULL', 11,1)
    RETURN
END

BEGIN TRAN T1

INSERT INTO tblORDER (OrderDate, CustomerID, ProductID, Quantity)
VALUES (@OrderDate, @C_ID, @P_ID, @Quantity)

IF @@ERROR <> 0
	ROLLBACK TRAN T1
ELSE 
	COMMIT TRAN T1

GO
