USE spease_Lab2
GO

-- Create stored procedures

CREATE PROCEDURE usp_GetPetTypeID

@PetTypeName VARCHAR(255),
@PetTypeID INT OUTPUT

AS

SET @PetTypeID = (
    SELECT PetTypeID FROM [PET_TYPE]
    WHERE PetTypeName = @PetTypeName
)

GO

CREATE PROCEDURE usp_GetCountryID

@CountryName VARCHAR(255),
@CountryID INT OUTPUT

AS

Set @CountryID = (
    SELECT CountryID FROM [COUNTRY]
    WHERE CountryName = @CountryName
)

GO

CREATE PROCEDURE usp_GetGenderID

@GenderName VARCHAR(255),
@GenderID INT OUTPUT

AS

SET @GenderID = (
    SELECT GenderID FROM [GENDER]
    WHERE GenderName = @GenderName 
)

GO

CREATE PROCEDURE usp_GetTemperamentID

@TemperamentName VARCHAR(255),
@TemperamentID INT OUTPUT

AS

SET @TemperamentID = (
    SELECT TempID FROM [TEMPERAMENT]
    WHERE TempName = @TemperamentName
)

GO
