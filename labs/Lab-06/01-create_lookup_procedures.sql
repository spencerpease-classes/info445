/*
* Create synthetic Transaction for populating tblCART
*
* 1) Start by creating lookup procedures:
*    - usp_getProductID
*       - usp_getProductTypeID
*       - usp_getProductSubTypeID
*    - usp_getCustomerID
*/

CREATE PROCEDURE usp_getProductTypeID

    @ProductTypeName VARCHAR(40),
    @ProductTypeID INT OUTPUT

    AS

    SET @ProductTypeID = (
        SELECT ProductTypeID FROM tblPRODUCT_TYPE
        WHERE ProductTypeName = @ProductTypeID
    )

    IF @ProductTypeID IS NULL
    BEGIN
        PRINT 'Could not find a matching product type';
        RAISERROR('ProductTypeID cannot be NULL', 11, 1);
        RETURN;
    END

GO;

CREATE PROCEDURE usp_getProductSubTypeID

    @ProductSubTypeName VARCHAR(40),
    @ProductSubTypeID INT OUTPUT

    AS

    SET @ProductSubTypeID = (
        SELECT ProductSubTypeID FROM tblPRODUCT_SUBTYPE
        WHERE ProductSubTypeName = @ProductSubTypeID
    )

    IF @ProductSubTypeID IS NULL
    BEGIN
        PRINT 'Could not find a matching product sub type';
        RAISERROR('ProductSubTypeID cannot be NULL', 11, 1);
        RETURN;
    END

GO;

CREATE PROCEDURE usp_getProductID

    @ProductName VARCHAR(200),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeName VARCHAR(40),
    @ProductID INT OUTPUT

    AS

    IF @ProductName IS NULL
    BEGIN  
        PRINT 'Cannot find product name';
        RAISERROR('Parameter ProductName cannot be NULL', 11, 1);
        RETURN;
    END

    DECLARE @ProductTypeID INT
    DECLARE @ProductSubTypeID INT

    EXEC usp_getProductSubTypeID
        @ProductSubTypeName = @ProductSubTypeName,
        @ProductSubTypeID = @ProductSubTypeID OUTPUT

    EXEC usp_getProductTypeID
        @ProductTypeName = @ProductTypeName,
        @ProductTypeID = @ProductTypeID OUTPUT

    SET @ProductID = (
        SELECT p.ProductID FROM tblPRODUCT p
            JOIN tblPRODUCT_SUBTYPE pst on pst.ProductSubTypeID = p.ProductSubTypeID
            JOIN tblPRODUCT_TYPE pt on pt.ProductTypeID = pst.ProductTypeID
        WHERE pt.ProductTypeID = @ProductTypeID
        AND pst.ProductSubTypeID = @ProductSubTypeID
        AND p.ProductName = @ProductName
    )

    IF @ProductID IS NULL
    BEGIN
        PRINT 'Could not find a matching product';
        RAISERROR('ProductID cannot be NULL', 11, 1);
        RETURN;
    END

GO;

CREATE PROCEDURE usp_getCustomerID

    @CustomerFName VARCHAR(40),
    @CustomerLName VARCHAR(40),
    @CustomerBirthDate DATE,
    @CustomerID INT OUTPUT

    AS

    SET @CustomerID = (
        SELECT CustomerID FROM tblCUSTOMER
        WHERE FName = @CustomerFName
        AND LName = @CustomerLName
        AND BirthDate = @CustomerBirthDate
    )

    IF @CustomerID IS NULL
    BEGIN
        PRINT 'Could not find a matching customer';
        RAISERROR('CustomerID cannot be NULL', 11, 1);
        RETURN;
    END

GO;

