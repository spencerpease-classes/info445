/*
* Populate the entity-related tables
* 
* - tblSUPPLIER
* - tblCUSTOMER
* - tblSTORE
* - tblEMPLOYEE_TYPE
* - tblEMPLOYEE
*
*/


/*
* Populate Supplier table
*/

INSERT INTO tblSUPPLIER(SupplierName) 
SELECT TOP 50 [BusinessName] 
FROM CUSTOMER_BUILD.dbo.[BusinessName];

GO

/*
* Populate Customer table
*/

INSERT INTO [tblCUSTOMER] (CustomerFName, CustomerLName, CustomerDOB) 
SELECT TOP 100000 [CustomerFname], [CustomerLname],[DateOfBirth] 
FROM CUSTOMER_BUILD.dbo.[tblCUSTOMER]

GO

/*
* Populate Store table
*/

CREATE PROCEDURE usp_populateStore

    @RUN INT

    AS

    DECLARE @_LocationID INT
    DECLARE @_StoreName VARCHAR(40)
    DECLARE @_LocationCount INT = (SELECT COUNT(*) FROM tblLOCATION)

    WHILE @RUN > 0
    BEGIN

        SET @_StoreName = CONCAT('Sporting goods ', @RUN)
        SET @_LocationID = (SELECT (@_LocationCount * RAND() + 1))

        BEGIN TRAN T1
        INSERT INTO tblSTORE(StoreName, LocationID)
        VALUES(@_StoreName, @_LocationID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE 
            COMMIT TRAN T1

        SET @RUN = @RUN - 1

    END

GO

EXEC usp_populateStore @RUN = 100;
GO

/*
* Populate Employee tables
*/

INSERT INTO tblEMPLOYEE_TYPE(EmployeeTypeName, EmployeeTypeDesc)
VALUES
    ('Manager', 'Manages the other employees'), 
    ('Janitor', 'Cleans up'), 
    ('Cashier', 'Handles the money'), 
    ('Shelf Stocker', 'Stocks the store'), 
    ('Security', 'Guards things')

GO

CREATE PROCEDURE usp_populateEmployee

    @RUN INT

    AS

    DECLARE @_Fname VARCHAR(40)
    DECLARE @_Lname VARCHAR(40)
    DECLARE @_DOB date
    DECLARE @_EmployeeTypeCount INT = (SELECT COUNT(*) FROM tblEMPLOYEE_TYPE)
    DECLARE @_EmployeeTypeID INT 

    IF OBJECT_ID('tempdb..#tblEMPLOYEE_TMP') IS NOT NULL 
    BEGIN
        PRINT 'Dropping temporary employee table'
        DROP TABLE #tblPRODUCT_TMP
    END

    CREATE TABLE #tblEMPLOYEE_TMP (
        CustomerID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
        CustomerFname VARCHAR(40) NOT NULL,
        CustomerLname VARCHAR(40) NOT NULL,
        DateOfBirth DATE
    )


    INSERT INTO #tblEMPLOYEE_TMP (CustomerFname, CustomerLname, DateOfBirth)
    SELECT TOP 100000 CustomerFname, CustomerLname, DateOfBirth
    FROM CUSTOMER_BUILD.dbo.[tblCUSTOMER]

    WHILE @RUN > 0
    BEGIN

        SET @_Fname =           (SELECT CustomerFname   FROM #tblEMPLOYEE_TMP WHERE CustomerID = @Run)
        SET @_Lname =           (SELECT CustomerLname   FROM #tblEMPLOYEE_TMP WHERE CustomerID = @Run)
        SET @_DOB =             (SELECT DateOfBirth     FROM #tblEMPLOYEE_TMP WHERE CustomerID = @Run)
        SET @_EmployeeTypeID =  ((SELECT RAND()) * @_EmployeeTypeCount + 1 )

        BEGIN TRAN T1
        INSERT INTO tblEMPLOYEE(EmployeeFName, EmployeeLName, EmployeeDOB, EmployeeTypeID)
        VALUES(@_Fname, @_Lname, @_DOB, @_EmployeeTypeID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE 
            COMMIT TRAN T1

        SET @RUN = @RUN - 1

    END

GO

EXEC usp_populateEmployee @RUN = 1000;
GO
