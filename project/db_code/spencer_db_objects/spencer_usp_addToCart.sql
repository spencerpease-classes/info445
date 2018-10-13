/*
* Create Stored Procedures
*
* - usp_addToCart
* - usp_wrapper_addToCart
*
*/ 


CREATE PROCEDURE usp_addToCart

    @ProductName VARCHAR(200),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeName VARCHAR(40),
    @BrandName VARCHAR(40),

    @CustomerFName VARCHAR(40),
    @CustomerLName VARCHAR(40),
    @CustomerDOB DATE,

    @Quantity INT,
    @DateAdded DATE = NULL

    AS

    IF @Quantity < 0
    BEGIN
        PRINT 'Cannot add a negative amount of a product to the cart';
        RAISERROR('Qantity cannot be negative', 11, 1);
        RETURN;
    END

    IF @DateAdded IS NULL
    BEGIN
        SET @DateAdded = GETDATE()
    END

    DECLARE @ProductID INT
    DECLARE @CustomerID INT

    EXEC usp_getProductID
        @ProductName = @ProductName,
        @ProductTypeName = @ProductTypeName,
        @ProductSubTypeName = @ProductSubTypeName,
        @BrandName = @BrandName,
        @ProductID = @ProductID OUTPUT

    EXEC usp_getCustomerID
        @CustomerFName = @CustomerFName,
        @CustomerLName = @CustomerLName,
        @CustomerDOB = @CustomerDOB,
        @CustomerID = @CustomerID OUTPUT

    BEGIN TRAN T1

        INSERT INTO tblCART (Quantity, DateAdded, CustomerID, ProductID)
        VALUES (@Quantity, @DateAdded, @CustomerID, @ProductID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
            
GO


CREATE PROCEDURE usp_wrapper_addToCart

    -- Number of inserts to make
    @Run INT

    AS

    -- parameters to pass wrapped stored procedure
    DECLARE @ProductName VARCHAR(200)
    DECLARE @ProductTypeName VARCHAR(40)
    DECLARE @ProductSubTypeName VARCHAR(40)
    DECLARE @BrandName VARCHAR(40)
 
    DECLARE @CustomerFName VARCHAR(40)
    DECLARE @CustomerLName VARCHAR(40)
    DECLARE @CustomerDOB DATE
 
    DECLARE @Quantity INT
    DECLARE @DateAdded DATE

    -- Variables to hold random pks
    DECLARE @RandPID INT
    DECLARE @RandCID INT

    -- Get the size of the tables that are being drawn from
    DECLARE @CountProd INT = (SELECT COUNT(*) FROM tblPRODUCT)
    DECLARE @CountCust INT = (SELECT COUNT(*) FROM tblCUSTOMER)

    -- Do @Run random inserts into tblCART
    WHILE @Run > 0
    BEGIN

        -- Get random pks to look up
        -- This assumes no wasted ids in the tables
        SET @RandPID = (SELECT (@CountProd * RAND() + 1))
        SET @RandCID = (SELECT (@CountProd * RAND() + 1))

        -- Look up parameters for insert

        SET @ProductName = (
            SELECT ProductName FROM tblPRODUCT
            WHERE ProductID = @RandPID
        )

        SET @ProductSubTypeName = (
            SELECT ProductSubTypeName FROM tblPRODUCT_SUBTYPE pst
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE ProductID = @RandPID
        )

        SET @ProductTypeName = (
            SELECT ProductTypeName FROM tblPRODUCT_TYPE pt
                JOIN tblPRODUCT_SUBTYPE pst on pst.ProductTypeID = pt.ProductTypeID
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE p.ProductID = @RandPID
        )

        SET @BrandName = (
            SELECT BrandName FROM tblBRAND b 
                JOIN tblPRODUCT p on p.BrandID = b.BrandID
            WHERE p.ProductID = @RandPID
        )

        SET @CustomerFName = (
            SELECT CustomerFName FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @CustomerLName = (
            SELECT CustomerLName FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @CustomerDOB = (
            SELECT CustomerDOB FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @Quantity = (SELECT (10 * RAND() + 1))
        SET @DateAdded = (SELECT DATEADD(day, RAND() * -3650, GETDATE()))


        -- Execute insert into tblCART
        EXEC usp_addToCart
            @ProductName = @ProductName,
            @ProductTypeName = @ProductTypeName,
            @ProductSubTypeName = @ProductSubTypeName,
            @BrandName = @BrandName,
            @CustomerFName = @CustomerFName,
            @CustomerLName = @CustomerLName,
            @CustomerDOB = @CustomerDOB,
            @Quantity = @Quantity,
            @DateAdded = @DateAdded

        SET @Run = @Run - 1
        
    END

GO
