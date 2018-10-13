/*
Spencer Pease
Lab 1
*/

--CREATE DATABASE spease_Lab1

USE spease_Lab1
GO

-- Create tables

CREATE TABLE tblPATIENT (
    PatientID INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    PatientFName VARCHAR(50) NOT NULL,
    PatientLName VARCHAR(50) NOT NULL,
    PatientDOB DATE NOT NULL
)

CREATE TABLE tblDOCTOR (
    DoctorID INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    DoctorFName VARCHAR(50) NOT NULL,
    DoctorLName VARCHAR(50) NOT NULL
)

CREATE TABLE tblAPPOINTMENT (
    AppointmentID INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    PatientID INT FOREIGN KEY REFERENCES tblPATIENT (PatientID) NOT NULL,
    DoctorID INT FOREIGN KEY REFERENCES tblDOCTOR (DoctorID) NOT NULL,
    AppointmentDate DATE not NULL
)

GO

-- Populate lookup tables

INSERT INTO tblPATIENT 
    ([PatientFName], [PatientLName], [PatientDOB])
SELECT TOP 5 
    CBCust.[CustomerFname], 
    CBCust.[CustomerLname], 
    CBCust.[DateOfBirth]
FROM 
    [CUSTOMER_BUILD].[dbo].[tblCUSTOMER] AS CBCust

GO

INSERT INTO tblDOCTOR
    ([DoctorFName], [DoctorLName])
SELECT
    CBCust.[CustomerFname], 
    CBCust.[CustomerLname]
FROM 
    [CUSTOMER_BUILD].[dbo].[tblCUSTOMER] AS CBCust
ORDER BY CBCust.[CustomerID] 
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY

GO

-- Create usp

CREATE PROCEDURE usp_getDoctorID

@DocFName VARCHAR(50),
@DocLName VARCHAR(50),
@DocID INT OUTPUT

AS

SET @DocID = (
    SELECT TOP 1 D.DoctorID FROM tblDOCTOR D
    WHERE 
        D.DoctorFName = @DocFName AND
        D.DoctorLName = @DocLName
)

GO

CREATE PROCEDURE usp_getPatientID

@PatFName VARCHAR(50),
@PatLName VARCHAR(50),
@PatDOB DATE,
@PatID INT OUTPUT

AS

SET @PatID = (
    SELECT TOP 1 P.PatientID FROM tblPATIENT P
    WHERE
        P.PatientFName = @PatFName AND
        P.PatientLName = @PatLName AND
        P.PatientDOB = @PatDOB
)

GO

CREATE PROCEDURE usp_makeAppointment

@FNamePat VARCHAR(50),
@LNamePat VARCHAR(50),
@DOBPat DATE,
@FNameDoc VARCHAR(50),
@LNameDoc VARCHAR(50),
@AptDate DATE

AS

DECLARE @IDPat INT
DECLARE @IDDoc INT

EXEC usp_getPatientID
    @PatFName = @FNamePat,
    @PatLName = @LNamePat,
    @PatDOB = @DOBPat,
    @patID = @IDPat OUTPUT

EXEC usp_getDoctorID
    @DocFName = @FNameDoc,
    @DocLName = @LNameDoc,
    @DocID = @IDDoc OUTPUT

BEGIN TRAN
INSERT INTO tblAPPOINTMENT ([PatientID], [DoctorID], [AppointmentDate])
VALUES (@IDPat, @IDDoc, @AptDate)

IF @@ERROR <> 0
    ROLLBACK TRAN
ELSE 
    COMMIT TRAN
GO

-- Test appointment usp

EXEC usp_makeAppointment
    @FNamePat = 'Kym',
    @LNamePat = 'Feig',
    @DOBPat = '1933-01-20',
    @FNameDoc = 'Larry',
    @LNameDoc = 'Ochinang',
    @AptDate = '2018-01-25'

SELECT * FROM tblAPPOINTMENT
