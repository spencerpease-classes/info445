/*
* Create lookup procedures:
*
* - usp_getProductTypeID    (done)
* - usp_getProductSubTypeID (done)
* - usp_getBrandID          (done)
* - usp_getProductID        (done)
*
* - usp_getLocationTypeID   (done)
* - usp_getLocationID       (done)
*
* - usp_getEmployeeTypeID   (done)
* - usp_getEmployeeID       (done)
* 
* - usp_getCustomerID       (done)
* - usp_getStoreID          (done)
* - usp_getSupplierID       (done)
* 
*/

CREATE PROCEDURE usp_getProductTypeID

    @ProductTypeName VARCHAR(40),
    @ProductTypeID INT OUTPUT

    AS

    SET @ProductTypeID = (
        SELECT ProductTypeID FROM tblPRODUCT_TYPE
        WHERE ProductTypeName = @ProductTypeName
    )

    IF @ProductTypeID IS NULL
    BEGIN
        PRINT 'Could not find a matching product type';
        RAISERROR('ProductTypeID cannot be NULL', 11, 1);
        RETURN;
    END

GO

CREATE PROCEDURE usp_getProductSubTypeID

    @ProductSubTypeName VARCHAR(40),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeID INT OUTPUT

    AS

    DECLARE @ProductTypeID INT

    EXEC usp_getProductTypeID
        @ProductTypeName = @ProductTypeName,
        @ProductTypeID = @ProductTypeID OUTPUT

    SET @ProductSubTypeID = (
        SELECT ProductSubTypeID FROM tblPRODUCT_SUBTYPE
        WHERE ProductSubTypeName = @ProductSubTypeName
        AND ProductTypeID = @ProductTypeID
    )

    IF @ProductSubTypeID IS NULL
    BEGIN
        PRINT 'Could not find a matching product sub type';
        RAISERROR('ProductSubTypeID cannot be NULL', 11, 1);
        RETURN;
    END

GO

CREATE PROCEDURE usp_getBrandID

    @BrandName VARCHAR(40),
    @BrandID INT OUTPUT

    AS

    SET @BrandID = (
        SELECT BrandID FROM tblBRAND
        WHERE BrandName = @BrandName
    )

    IF @BrandID IS NULL
    BEGIN
        PRINT 'Could not find a matching brand name';
        RAISERROR('BrandID cannot be NULL', 11, 1);
        RETURN;
    END

GO

CREATE PROCEDURE usp_getProductID

    @ProductName VARCHAR(200),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeName VARCHAR(40),
    @BrandName VARCHAR(40),
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
    DECLARE @BrandID INT

    EXEC usp_getProductSubTypeID
        @ProductSubTypeName = @ProductSubTypeName,
        @ProductTypeName = @ProductTypeName,
        @ProductSubTypeID = @ProductSubTypeID OUTPUT

    EXEC usp_getProductTypeID
        @ProductTypeName = @ProductTypeName,
        @ProductTypeID = @ProductTypeID OUTPUT

    EXEC usp_getBrandID
        @BrandName = @BrandName,
        @BrandID = @BrandID OUTPUT

    SET @ProductID = (
        SELECT p.ProductID FROM tblPRODUCT p
            JOIN tblPRODUCT_SUBTYPE pst on pst.ProductSubTypeID = p.ProductSubTypeID
            JOIN tblPRODUCT_TYPE pt on pt.ProductTypeID = pst.ProductTypeID
            JOIN tblBRAND b on b.BrandID = p.BrandID
        WHERE pt.ProductTypeID = @ProductTypeID
        AND pst.ProductSubTypeID = @ProductSubTypeID
        AND b.BrandID = @BrandID
        AND p.ProductName = @ProductName
    )

    IF @ProductID IS NULL
    BEGIN
        PRINT 'Could not find a matching product';
        RAISERROR('ProductID cannot be NULL', 11, 1);
        RETURN;
    END

GO

CREATE PROCEDURE usp_getCustomerID

    @CustomerFName VARCHAR(40),
    @CustomerLName VARCHAR(40),
    @CustomerDOB DATE,
    @CustomerID INT OUTPUT

    AS

    SET @CustomerID = (
        SELECT CustomerID FROM tblCUSTOMER
        WHERE CustomerFName = @CustomerFName
        AND CustomerLName = @CustomerLName
        AND CustomerDOB = @CustomerDOB
    )

    IF @CustomerID IS NULL
    BEGIN
        PRINT 'Could not find a matching customer';
        RAISERROR('CustomerID cannot be NULL', 11, 1);
        RETURN;
    END

GO


CREATE PROCEDURE usp_getLocationTypeID

    @LocationTypeName VARCHAR(40),
    @LocationTypeID INT OUTPUT

    AS

    IF @LocationTypeName IS NULL
    BEGIN  
        PRINT 'Location Type name must be provided ';
        RAISERROR('Parameter LocationTypeName cannot be NULL', 11, 1);
        RETURN;
    END

    SET @LocationTypeID = (
        SELECT LocationTypeID FROM tblLOCATION_TYPE
        WHERE LocationTypeName = @LocationTypeName
    )

    IF @LocationTypeID IS NULL
    BEGIN
        PRINT 'Could not find a matching location type';
        RAISERROR('LocationTypeID cannot be NULL', 11, 1);
        RETURN;
    END

GO


CREATE PROCEDURE usp_getLocationID

    @StreetAddress VARCHAR(120),
    @City VARCHAR(75),
    @State VARCHAR(25),
    @Zip VARCHAR(25),
    @LocationTypeName VARCHAR(40),
    @LocationID INT OUTPUT

    AS

    DECLARE @LocationTypeID INT

    IF @StreetAddress IS NULL
    BEGIN  
        PRINT 'Street Address must be provided';
        RAISERROR('Parameter StreetAddress cannot be NULL', 11, 1);
        RETURN;
    END

    IF @City IS NULL
    BEGIN  
        PRINT 'City must be provided ';
        RAISERROR('Parameter City cannot be NULL', 11, 1);
        RETURN;
    END

    IF @State IS NULL
    BEGIN  
        PRINT 'State must be provided ';
        RAISERROR('Parameter State cannot be NULL', 11, 1);
        RETURN;
    END

    IF @Zip IS NULL
    BEGIN  
        PRINT 'Zip must be provided ';
        RAISERROR('Parameter Zip cannot be NULL', 11, 1);
        RETURN;
    END

    EXEC usp_getLocationTypeID
        @LocationTypeName = @LocationTypeName,
        @LocationTypeID = @LocationTypeID OUTPUT

    SET @LocationID = (
        SELECT LocationID FROM tblLOCATION
        WHERE StreetAddress = @StreetAddress
        AND City = @City
        AND [State] = @State
        AND Zip = @Zip
        AND LocationTypeID = @LocationTypeID
    )

    IF @LocationID IS NULL
    BEGIN
        PRINT 'Could not find a matching location';
        RAISERROR('LocationID cannot be NULL', 11, 1);
        RETURN;
    END

GO


CREATE PROCEDURE usp_getEmployeeTypeID

    @EmployeeTypeName VARCHAR(40),
    @EmployeeTypeID INT OUTPUT

    AS

    IF @EmployeeTypeName IS NULL
    BEGIN  
        PRINT 'Employee type name must be provided ';
        RAISERROR('Parameter EmployeeTypeName cannot be NULL', 11, 1);
        RETURN;
    END

    SET @EmployeeTypeID = (
        SELECT EmployeeTypeID FROM tblEMPLOYEE_TYPE
        WHERE EmployeeTypeName = @EmployeeTypeName
    )

    IF @EmployeeTypeID IS NULL
    BEGIN
        PRINT 'Could not find a matching employee type';
        RAISERROR('EmployeeTypeID cannot be NULL', 11, 1);
        RETURN;
    END

GO


CREATE PROCEDURE usp_getEmployeeID

    @EmployeeFName VARCHAR(40),
    @EmployeeLName VARCHAR(40),
    @EmployeeDOB DATE,
    @EmployeeTypeName VARCHAR(40),
    @EmployeeID INT OUTPUT

    AS

    DECLARE @EmployeeTypeID INT

    IF @EmployeeFName IS NULL
    BEGIN  
        PRINT 'Employee first name must be provided ';
        RAISERROR('Parameter EmployeeFName cannot be NULL', 11, 1);
        RETURN;
    END

    IF @EmployeeLName IS NULL
    BEGIN  
        PRINT 'Employee last name must be provided ';
        RAISERROR('Parameter EmployeeLName cannot be NULL', 11, 1);
        RETURN;
    END

    IF @EmployeeDOB IS NULL
    BEGIN  
        PRINT 'Employee date of birth must be provided ';
        RAISERROR('Parameter DOB cannot be NULL', 11, 1);
        RETURN;
    END

    EXEC usp_GetEmployeeTypeID
        @EmployeeTypeName = @EmployeeTypeName,
        @EmployeeTypeID = @EmployeeTypeID OUTPUT

    SET @EmployeeID = (
        SELECT EmployeeID FROM tblEMPLOYEE
        WHERE EmployeeFName = @EmployeeFName
        AND EmployeeLName = @EmployeeLName
        AND EmployeeDOB = @EmployeeDOB
        AND EmployeeTypeID = @EmployeeTypeID
    )

    IF @EmployeeID IS NULL
    BEGIN
        PRINT 'Could not find a matching employee';
        RAISERROR('EmployeeID cannot be NULL', 11, 1);
        RETURN;
    END

GO


CREATE PROCEDURE usp_getStoreID

    @StoreName VARCHAR(40),
    @StoreID INT OUTPUT

    AS

    IF @StoreName IS NULL
    BEGIN  
        PRINT 'Store name must be provided ';
        RAISERROR('Parameter StoreName cannot be NULL', 11, 1);
        RETURN;
    END

    SET @StoreID = (
        SELECT StoreID FROM tblSTORE
        WHERE StoreName = @StoreName
    )

    IF @StoreID IS NULL
    BEGIN
        PRINT 'Could not find a matching store';
        RAISERROR('StoreID cannot be NULL', 11, 1);
        RETURN;
    END

GO


CREATE PROCEDURE usp_getSupplierID

    @SupplierName VARCHAR(40),
    @SupplierID INT OUTPUT

    AS

    IF @SupplierName IS NULL
    BEGIN  
        PRINT 'Supplier name must be provided ';
        RAISERROR('Parameter SupplierName cannot be NULL', 11, 1);
        RETURN;
    END

    SET @SupplierID = (
        SELECT SupplierID FROM tblSUPPLIER
        WHERE SupplierName = @SupplierName
    )

    IF @SupplierID IS NULL
    BEGIN
        PRINT 'Could not find a matching supplier';
        RAISERROR('SupplierID cannot be NULL', 11, 1);
        RETURN;
    END

GO


