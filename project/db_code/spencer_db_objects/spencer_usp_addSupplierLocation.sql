-- usp_addSupplierLocation

CREATE PROCEDURE usp_addSupplierLocation

    @SupplierName VARCHAR(40),

    @StreetAddress VARCHAR(120),
    @City VARCHAR(75),
    @State VARCHAR(25),
    @Zip VARCHAR(25),
    @LocationTypeName VARCHAR(40)

    AS

    DECLARE @SupplierID INT
    DECLARE @LocationID INT

    EXEC usp_getSupplierID
        @SupplierName = @SupplierName,
        @SupplierID = @SupplierID OUTPUT
    
    EXEC usp_getLocationID
        @StreetAddress = @StreetAddress,
        @City = @City,
        @State = @State,
        @Zip = @Zip,
        @LocationTypeName = @LocationTypeName,
        @LocationID = @LocationID OUTPUT
    
    BEGIN TRAN T1

        INSERT INTO tblSUPPLIER_LOCATION (SupplierID, LocationID)
        VALUES (@SupplierID, @LocationID)
    
        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
            
GO


-- usp_addSupplierLocation_WRAPPER

CREATE PROCEDURE usp_addSupplierLocation_WRAPPER

    @Run INT

    AS

    -- Parameters to look up
    DECLARE @SupplierName VARCHAR(40)

    DECLARE @StreetAddress VARCHAR(120)
    DECLARE @City VARCHAR(75)
    DECLARE @State VARCHAR(25)
    DECLARE @Zip VARCHAR(25)
    DECLARE @LocationTypeName VARCHAR(40)

    -- Randoms ids to look up
    DECLARE @RandSupplierID INT
    DECLARE @RandLocationID INT

    -- Range of random ids to select from
    DECLARE @SupplierCount INT = (SELECT COUNT(*) FROM tblSUPPLIER) 
    DECLARE @LocationCount INT = (SELECT COUNT(*) FROM tblLOCATION)

    -- Do @Run random inserts
    WHILE @Run > 0
    BEGIN

        -- get random id
        SET @RandSupplierID = (SELECT (@SupplierCount * RAND() + 1))
        SET @RandLocationID = (SELECT (@LocationCount * RAND() + 1))

        -- set parameters based on random id
        SET @SupplierName = (
            SELECT SupplierName FROM tblSUPPLIER
            WHERE SupplierID = @RandSupplierID
        )

        SET @StreetAddress = (
            SELECT StreetAddress FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @City = (
            SELECT City FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @State = (
            SELECT [State] FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @Zip = (
            SELECT Zip FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @LocationTypeName = (
            SELECT LocationTypeName FROM tblLOCATION_TYPE lt
                JOIN tblLOCATION l on l.LocationTypeID = lt.LocationTypeID
            WHERE LocationID = @RandLocationID
        )

        -- insert into table
        EXEC usp_addSupplierLocation
            @SupplierName = @SupplierName,
            @StreetAddress = @StreetAddress,
            @City = @City,
            @State = @State,
            @Zip = @Zip,
            @LocationTypeName = @LocationTypeName 

        SET @Run = @Run - 1
    END
GO

