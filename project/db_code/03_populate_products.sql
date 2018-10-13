/*
* Move raw products into relevant tables
*
* Preconditions:
* - Data in Raw table must already exist in DB
*/

-- Create temp working table
-- (delete and recreate if it already exists)
IF OBJECT_ID('tempdb..#tblPRODUCT_TMP') IS NOT NULL 
    BEGIN
        PRINT 'Dropping temporary product table'
        DROP TABLE #tblPRODUCT_TMP
    END

CREATE TABLE #tblPRODUCT_TMP (
    TmpProductID INT IDENTITY(1,1) NOT NULL,
    TmpProductName VARCHAR(150) NOT NULL,
    TmpCategory VARCHAR(40) NOT NULL,
    TmpSubCategory VARCHAR(40) NOT NULL,
    TmpBrand VARCHAR(40) NOT NULL,
    TmpPrice NUMERIC(6,2) NOT NULL,
    TmpProductDesc VARCHAR(255)
)

INSERT INTO #tblPRODUCT_TMP
SELECT [product_name], [category], [sub_category], [brand], [price], [description]
FROM [spease_project_tmp].dbo.tblPRODUCTS_RAW


-- Populate lookup tables
INSERT INTO tblBRAND SELECT DISTINCT (TmpBrand), NULL
FROM #tblPRODUCT_TMP p_tmp
WHERE
    TmpBrand IS NOT NULL
    AND NOT EXISTS (
        SELECT * FROM tblBRAND b
        WHERE b.BrandName = p_tmp.TmpBrand
    )

INSERT INTO tblPRODUCT_TYPE SELECT DISTINCT (TmpCategory), NULL
FROM #tblPRODUCT_TMP p_tmp
WHERE
    TmpCategory IS NOT NULL
    AND NOT EXISTS (
        SELECT * FROM tblPRODUCT_TYPE pt
        WHERE pt.ProductTypeName = p_tmp.TmpCategory
    )

INSERT INTO tblPRODUCT_SUBTYPE (ProductSubTypeName, ProductTypeID, ProductSubTypeDesc) SELECT  
    DISTINCT (TmpSubCategory),
    (SELECT ProductTypeID FROM tblPRODUCT_TYPE WHERE ProductTypeName = p_tmp.TmpCategory),
    NULL
FROM #tblPRODUCT_TMP p_tmp
WHERE
    TmpSubCategory IS NOT NULL
    AND NOT EXISTS (
        SELECT * FROM tblPRODUCT_SUBTYPE pst
        WHERE pst.ProductSubTypeName = p_tmp.TmpSubCategory
    )

-- Define tracking variables
DECLARE @Run INT = (SELECT COUNT(*) FROM #tblPRODUCT_TMP)
DECLARE @MinID INT

-- Define name varaibles to match in temp table
DECLARE @_ProdName VARCHAR(150)
DECLARE @_ProdTypeName VARCHAR(40)
DECLARE @_ProdSubTypeName VARCHAR(40)
DECLARE @_BrandName VARCHAR(40)
DECLARE @_Price NUMERIC(6,2)
DECLARE @_ProdDesc VARCHAR(255)

-- Define ID variables to lookup from names
DECLARE @_ProdSubTypeID INT
DECLARE @_BrandID INT

-- Iterate through the temp table, moving each row into tblPRODUCT
-- and delete the row from the temp table
WHILE @Run > 0
BEGIN

    -- Get the minimum ID in the temp table
    SET @MinID = (SELECT MIN(TmpProductID) FROM #tblPRODUCT_TMP)

    -- Get names from minimum row in the temp table
    SET @_ProdName =            (SELECT TmpProductName  FROM #tblPRODUCT_TMP WHERE TmpProductID = @MinID)
    SET @_ProdTypeName =        (SELECT TmpCategory     FROM #tblPRODUCT_TMP WHERE TmpProductID = @MinID)
    SET @_ProdSubTypeName =     (SELECT TmpSubCategory  FROM #tblPRODUCT_TMP WHERE TmpProductID = @MinID)
    SET @_BrandName =           (SELECT TmpBrand        FROM #tblPRODUCT_TMP WHERE TmpProductID = @MinID)    
    SET @_Price =               (SELECT TmpPrice        FROM #tblPRODUCT_TMP WHERE TmpProductID = @MinID)
    SET @_ProdDesc =            (SELECT TmpProductDesc  FROM #tblPRODUCT_TMP WHERE TmpProductID = @MinID)

    -- Lookup IDs based on name
    EXEC usp_getProductSubTypeID
        @ProductSubTypeName = @_ProdSubTypeName,
        @ProductTypeName = @_ProdTypeName,
        @ProductSubTypeID = @_ProdSubTypeID OUTPUT

    EXEC usp_getBrandID
        @BrandName = @_BrandName,
        @BrandID = @_BrandID OUTPUT

    -- Begin insert into tblProduct
    BEGIN TRAN T1
        INSERT INTO tblPRODUCT (ProductName, ProductSubTypeID, BrandID, Price, ProductDesc)
        VALUES (@_ProdName, @_ProdSubTypeID, @_BrandID, @_Price, @_ProdDesc)

        IF @@ERROR <> 0
            BEGIN
            ROLLBACK TRAN T1;

            PRINT 'Failure at ID: ' + CAST(@MinID AS VARCHAR);
            PRINT '   - Product Name: ' + @_ProdName;
            PRINT '   - Product subtype: ' + @_ProdSubTypeName;
            PRINT '   - Brand: ' + @_BrandName;
            PRINT '   - Price: ' + CAST(@_Price AS VARCHAR);
            PRINT '   - Description: ' + @_ProdDesc;
            END

        ELSE
            COMMIT TRAN T1
            

    -- Delete row from temp table and decrement
    DELETE FROM #tblPRODUCT_TMP WHERE TmpProductID = @MinID
    SET @Run = @Run - 1

END

/*
SELECT TOP 10 * FROM tblPRODUCTS_RAW

SELECT pt.ProductTypeName, COUNT(ProductSubTypeName) FROM tblPRODUCT_SUBTYPE pst JOIN tblPRODUCT_TYPE pt on pt.ProductTypeID = pst.ProductTypeID 
GROUP BY pst.ProductTypeID, pt.ProductTypeName
ORDER BY pt.ProductTypeName
*/

/*
SELECT COUNT(*) FROM tblPRODUCT

SELECT COUNT(*) FROM dbo.tblPRODUCTS_RAW

DELETE FROM tblPRODUCT
*/
