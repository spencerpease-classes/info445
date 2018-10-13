/*
* Populate Location tables
*
* Steps:
* - Start with tblLOCATION_TYPE
* - Get data from CUSTOMER_BUILD
* - Populate tblLOCATION with data from CUSTOMER_BUILD
*   and a random value for location type
* - Remove state abbreviation from location table
*
*/

INSERT INTO tblLOCATION_TYPE (LocationTypeName) 
VALUES
    ('Store'), 
    ('Apartment'),
    ('House'), 
    ('Warehouse');

GO

CREATE PROCEDURE usp_populateLocation

    @RUN INT

    AS

    DECLARE @_LocationTypeCount INT = (SELECT COUNT(*) FROM tblLOCATION_TYPE)
    DECLARE @_StreetAddress VARCHAR(120)
    DECLARE @_City VARCHAR(75)
    DECLARE @_State VARCHAR(25)
    DECLARE @_Zip VARCHAR(25)
    DECLARE @_Location_TypeID INT
    DECLARE @minID INT

    -- Create temp working table
    -- (delete and recreate if it already exists)
    IF OBJECT_ID('tempdb..#tblLOCATION_TMP') IS NOT NULL 
        BEGIN
            PRINT 'Dropping temporary location table'
            DROP TABLE #tblPRODUCT_TMP
        END

    CREATE TABLE #tblLOCATION_TMP (
        CustomerID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
        CustomerAddress VARCHAR(120),
        CustomerCity VARCHAR(75),
        CustomerState VARCHAR(25),
        CustomerZIP VARCHAR(25),
    )

    -- Populate working table
    INSERT INTO #tblLOCATION_TMP
    SELECT TOP 100000 CustomerAddress, CustomerCity, CustomerState, CustomerZIP 
    FROM CUSTOMER_BUILD.dbo.tblCUSTOMER

    -- Populate tblLOCATION
    WHILE @RUN > 0
    BEGIN

        SET @minID = (SELECT MIN(CustomerID) FROM #tblLOCATION_TMP)

        SET @_StreetAddress = (SELECT CustomerAddress from #tblLOCATION_TMP Where CustomerID = @minID)
        SET @_City = (SELECT CustomerCity from #tblLOCATION_TMP Where CustomerID = @minID)
        SET @_State = (SELECT CustomerState from #tblLOCATION_TMP Where CustomerID = @minID)
        SET @_Zip = (SELECT CustomerZIP from #tblLOCATION_TMP Where CustomerID = @minID)
        SET @_Location_TypeID = (SELECT(RAND() * @_LocationTypeCount + 1 ))

        BEGIN TRAN T1
        INSERT INTO tblLOCATION(StreetAddress, City, [State], Zip, LocationTypeID)
        VALUES(@_StreetAddress, @_City, @_State, @_Zip, @_Location_TypeID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE 
            COMMIT TRAN T1

        DELETE FROM #tblLOCATION_TMP where CustomerID = @minID

        SET @RUN = @RUN - 1
    END

GO


EXEC usp_populateLocation @RUN = 5000;
GO

/*
SELECT TOP 10 * FROM tblLOCATION
*/

CREATE PROCEDURE usp_stripStateID 
    AS

    DECLARE @LocCount INT = (SELECT COUNT(*) FROM tblLOCATION)
    DECLARE @Run INT = 1

    WHILE @Run <= @LocCount
    BEGIN

        DECLARE @NewState VARCHAR(40) = (
            SELECT SUBSTRING(State, 1, LEN(state) - 4) 
            FROM tblLOCATION 
            WHERE LocationID = @RUN
        )

        UPDATE tblLOCATION
        SET State = @NewState WHERE LocationID = @Run

        SET @Run = @Run + 1
    END

GO

EXEC usp_stripStateID

