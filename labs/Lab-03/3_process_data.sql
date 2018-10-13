USE spease_Lab2
GO

-- Create copy of working data

IF EXISTS (SELECT * from sys.sysobjects WHERE NAME = 'WorkingTable')
    BEGIN
        PRINT 'Dropping table WorkingTable'
        DROP TABLE WorkingTable
    END

CREATE TABLE WorkingTable (
    WorkingPetID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    PetName VARCHAR(255),
    PetType VARCHAR(255),
    Country VARCHAR (255),
    Temperament VARCHAR(255),
    DOB DATE,
    Gender VARCHAR(255)
)

INSERT INTO WorkingTable
SELECT [PetName], [Pet_Type], [Country], [Temperament], [DATE_BIRTH], [Gender]
FROM [dbo].[Raw_PetData]

-- Populate lookup tables

INSERT INTO [PET_TYPE] SELECT Distinct(PetType) 
FROM [WorkingTable] wt
WHERE 
    PetType IS NOT NULL
    AND NOT EXISTS (
        SELECT * FROM [PET_TYPE] pt
        WHERE wt.PetType = pt.PetTypeName
    )

INSERT INTO [COUNTRY] SELECT Distinct(Country) 
FROM [WorkingTable] wt
WHERE 
    Country IS NOT NULL
    AND NOT EXISTS (
        SELECT * FROM [COUNTRY] c
        WHERE wt.Country = c.CountryName
    )

INSERT INTO [TEMPERAMENT] SELECT Distinct(Temperament) 
FROM [WorkingTable] wt
WHERE 
    Temperament IS NOT NULL
    AND NOT EXISTS (
        SELECT * FROM [TEMPERAMENT] t
        WHERE wt.Temperament = t.TempName
    )

INSERT INTO [GENDER] SELECT Distinct(Gender) 
FROM [WorkingTable] wt
WHERE 
    Gender IS NOT NULL
    AND NOT EXISTS (
        SELECT * FROM [GENDER] g
        WHERE wt.Gender = g.GenderName
    )

-- Populate PETS table

-- Tracking variables
DECLARE @Run INT = (SELECT COUNT(*) FROM [WorkingTable])
DECLARE @minID INT

-- names to match to pks
DECLARE @_petName VARCHAR(255)
DECLARE @_petTypeName VARCHAR(255)
DECLARE @_temper VARCHAR(255)
DECLARE @_country VARCHAR(255)
DECLARE @_DOB DATE
DECLARE @_gender VARCHAR(255)

-- variables for output IDs
DECLARE @_petTypeID INT
DECLARE @_temperID INT
DECLARE @_countryID INT
DECLARE @_genderID INT

WHILE @Run > 0
BEGIN
    -- Get min ID
    SET @minID = (SELECT MIN(WorkingPetID) FROM [WorkingTable])

    -- Get names
    SET @_petName = (       SELECT PetName      FROM WorkingTable WHERE WorkingPetID = @minID)

    IF @_petName IS NULL
    BEGIN
        PRINT 'Pets must have a name'
        RAISERROR ('@_petName cannot be NULL', 11,1)
    END

    SET @_petTypeName = (   SELECT PetType      FROM WorkingTable WHERE WorkingPetID = @minID)
    SET @_temper = (        SELECT Temperament  FROM WorkingTable WHERE WorkingPetID = @minID)
    SET @_country = (       SELECT Country      FROM WorkingTable WHERE WorkingPetID = @minID)
    SET @_DOB = (           SELECT DOB          FROM WorkingTable WHERE WorkingPetID = @minID)
    SET @_gender = (        SELECT Gender       FROM WorkingTable WHERE WorkingPetID = @minID)

    -- Get IDs
    EXEC usp_GetPetTypeID
        @PetTypeName = @_petTypeName,
        @PetTypeID = @_petTypeID OUTPUT;

    IF @_petTypeID IS NULL
    BEGIN
        PRINT 'Pets must have a pet type';
        RAISERROR ('@_petTypeID must not be NULL', 11,1)
    END

    EXEC usp_GetTemperamentID
        @TemperamentName = @_temper,
        @TemperamentID = @_temperID OUTPUT;

    EXEC usp_GetCountryID
        @CountryName = @_country,
        @CountryID = @_countryID OUTPUT;

    EXEC usp_GetGenderID
        @GenderName = @_gender,
        @GenderID = @_genderID OUTPUT

    -- Insert into table
    BEGIN TRAN T1
        INSERT INTO [PET] (PetName, PetTypeID, CountryID, TempID, DOB, GenderID)
        VALUES (@_petName, @_petTypeID, @_countryID, @_temperID, @_DOB, @_genderID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1

    -- Delete row
    DELETE FROM [WorkingTable] WHERE WorkingPetID = @minID
    SET @Run = @Run - 1
END
