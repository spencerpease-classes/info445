USE Lab3_445_spease
GO

/* -------------------------------------------------------------------
Create Wapper stored procedure to test transactional stored procedures
------------------------------------------------------------------- */ 

CREATE PROCEDURE uspInsertOrder_wrapper

-- number of inserts to make
@Run INT

AS

-- parameter for stored procedure
DECLARE @_fName VARCHAR(60)
DECLARE @_lName VARCHAR(60)
DECLARE @_DOB DATE
DECLARE @_ZIP VARCHAR(25)
DECLARE @_prod VARCHAR(100)
DECLARE @_qty NUMERIC(5,0)
DECLARE @_OrderDate DATE

-- pks to get data from
DECLARE @_pID INT
DECLARE @_cID INT

-- number of pks to draw from
DECLARE @_cCount INT
DECLARE @_pCount INT

SET @_cCount = (SELECT COUNT(*) FROM tblCUSTOMER)
SET @_pCount = (SELECT COUNT(*) FROM tblPRODUCT)

WHILE @Run > 0
BEGIN

    -- Get random IDs
    SET @_pID = (SELECT @_pCount * RAND())
    IF @_pID < 1
    BEGIN
        PRINT 'Product ID is less than 1; re-assigning value to another number'
        SET @_pID = (SELECT @_pCount * RAND())
    END

    SET @_cID = (SELECT @_cCount * RAND())
    IF @_cID < 1
    BEGIN
        PRINT 'Customer ID is less than 1; re-assigning value to another number'
        SET @_cID = (SELECT @_cCount * RAND())
    END

    SET @_OrderDate = (SELECT GetDate() - (4000 * RAND()))

    SET @_qty = (SELECT 6 * Rand()+1)

    -- Get parameters for insert
    SET @_fName = (
        SELECT CustomerFname FROM tblCUSTOMER
        WHERE CustomerID = @_cID
    )

    SET @_lName = (
        SELECT CustomerLname FROM tblCUSTOMER
        WHERE CustomerID = @_cID
    )

    SET @_DOB = (
        SELECT DateOfBirth FROM tblCUSTOMER
        WHERE CustomerID = @_cID 
    )

    SET @_ZIP = (
        SELECT CustomerZIP FROM tblCUSTOMER
        WHERE CustomerID = @_cID
    )

    SET @_prod = (
        SELECT ProductName FROM tblPRODUCT
        WHERE ProductID = @_pID
    )

    -- execute insert
    EXEC uspInsertOrder
        @CustFName = @_fName,
        @CustLName = @_lName,
        @CustDOB = @_DOB,
        @CustZIP = @_ZIP,
        @ProdName = @_prod,
        @Quantity = @_qty,
        @OrderDate = @_OrderDate

    SET @Run = @Run - 1
END

GO