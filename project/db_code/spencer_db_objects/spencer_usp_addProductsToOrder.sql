-- Add products to an order

CREATE PROCEDURE usp_addProductsToOrder

    @OrderID INT,
    @NumProducts INT

    AS

    IF @OrderID IS NULL
    BEGIN
        PRINT 'Cannot find OrderID';
        RAISERROR('OrderID cannot be NULL', 11, 1);
        RETURN;
    END

    IF @NumProducts IS NULL
    BEGIN
        PRINT 'Cannot find number of products';
        RAISERROR('NumProducts cannot be NULL', 11, 1);
        RETURN;
    END

    -- parameters to pass wrapped stored procedure
    DECLARE @ProductName VARCHAR(200)
    DECLARE @ProductTypeName VARCHAR(40)
    DECLARE @ProductSubTypeName VARCHAR(40)
    DECLARE @BrandName VARCHAR(40)

    DECLARE @ProductID INT
  
    DECLARE @Quantity INT


    -- Variables to hold random pks
    DECLARE @RandPID INT

    -- Get the size of the tables that are being drawn from
    DECLARE @CountProd INT = (SELECT COUNT(*) FROM tblPRODUCT)

    -- Insert @NumProducts products into tblORDER_PRODUCT
    WHILE @NumProducts > 0
    BEGIN

        -- Get random productID to look up
        -- This assumes no wasted ids in the tables
        SET @RandPID = (SELECT (@CountProd * RAND() + 1))

        -- Look up parameters for ProductID

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

        -- Get ProductID
        EXEC usp_getProductID
            @ProductName = @ProductName,
            @ProductTypeName = @ProductTypeName,
            @ProductSubTypeName = @ProductSubTypeName,
            @BrandName = @BrandName,
            @ProductID = @ProductID OUTPUT

        SET @Quantity = (SELECT (5 * RAND() + 1))

        BEGIN TRAN T1

            INSERT INTO tblORDER_PRODUCT (OrderID, ProductID, Quantity)
            VALUES (@OrderID, @ProductID, @Quantity)

            IF @@ERROR <> 0
                ROLLBACK TRAN T1
            ELSE
                COMMIT TRAN T1

        SET @NumProducts = @NumProducts - 1
        
    END

GO