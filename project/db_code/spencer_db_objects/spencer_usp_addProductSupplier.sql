-- usp_addSupplierProduct

CREATE PROCEDURE usp_addProductSupplier

    @SupplierName VARCHAR(40),

    @ProductName VARCHAR(200),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeName VARCHAR(40),
    @BrandName VARCHAR(40)

    AS

    DECLARE @SupplierID INT
    DECLARE @ProductID INT

    EXEC usp_getSupplierID
        @SupplierName = @SupplierName,
        @SupplierID = @SupplierID OUTPUT
    
    EXEC usp_getProductID
        @ProductName = @ProductName,
        @ProductTypeName = @ProductTypeName,
        @ProductSubTypeName = @ProductSubTypeName,
        @BrandName = @BrandName,
        @ProductID = @ProductID OUTPUT
    
    BEGIN TRAN T1

        INSERT INTO tblPRODUCT_SUPPLIER (SupplierID, ProductID)
        VALUES (@SupplierID, @ProductID)
    
        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
            
GO


-- usp_addSupplierProduct_WRAPPER

CREATE PROCEDURE usp_addSupplierProduct_WRAPPER

    @Run INT

    AS

    -- Parameters to look up
    DECLARE @SupplierName VARCHAR(40)

    DECLARE @ProductName VARCHAR(200)
    DECLARE @ProductTypeName VARCHAR(40)
    DECLARE @ProductSubTypeName VARCHAR(40)
    DECLARE @BrandName VARCHAR(40)

    -- Randoms ids to look up
    DECLARE @RandSupplierID INT
    DECLARE @RandProductID INT

    -- Range of random ids to select from
    DECLARE @SupplierCount INT = (SELECT COUNT(*) FROM tblSUPPLIER) 
    DECLARE @ProductCount INT = (SELECT COUNT(*) FROM tblPRODUCT)

    -- Do @Run random inserts
    WHILE @Run > 0
    BEGIN

        -- get random id
        SET @RandSupplierID = (SELECT (@SupplierCount * RAND() + 1))
        SET @RandProductID = (SELECT (@ProductCount * RAND() + 1))

        -- set parameters based on random id
        SET @SupplierName = (
            SELECT SupplierName FROM tblSUPPLIER
            WHERE SupplierID = @RandSupplierID
        )

        SET @ProductName = (
            SELECT ProductName FROM tblPRODUCT
            WHERE ProductID = @RandProductID
        )

        SET @ProductTypeName = (
            SELECT ProductTypeName FROM tblPRODUCT_TYPE pt
                JOIN tblPRODUCT_SUBTYPE pst on pst.ProductTypeID = pt.ProductTypeID
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE p.ProductID = @RandProductID
        )

        SET @ProductSubTypeName = (
            SELECT ProductSubTypeName FROM tblPRODUCT_SUBTYPE pst
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE p.ProductID = @RandProductID
        )

        SET @BrandName = (
            SELECT BrandName FROM tblBRAND b 
                JOIN tblPRODUCT p on p.BrandID = b.BrandID
            WHERE p.ProductID = @RandProductID
        )

        -- insert into table
        EXEC usp_addProductSupplier
            @SupplierName = @SupplierName,
            @ProductName = @ProductName,
            @ProductTypeName = @ProductTypeName,
            @ProductSubTypeName = @ProductSubTypeName,
            @BrandName = @BrandName
    
        SET @Run = @Run - 1

    END

GO
