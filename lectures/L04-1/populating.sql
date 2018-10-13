USE [gthay_Lab_2]
GO

IF EXISTS (SELECT * from sys.sysobjects WHERE NAME = "WorkingTable")
    BEGIN
        DROP TABLE WorkingTable
    END

CREATE TABLE [dbo].WorkingTable (
    PetID INT IDENTITY(1,1) PRIMARY KEY NOT NULL
)

INSERT INTO WorkingTable
SELECT -- stuff
FROM [dbo].[Raw_spreadsheetofpets]
