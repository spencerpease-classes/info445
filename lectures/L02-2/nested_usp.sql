USE [OTTER_spease]
GO

/*
write code for nested sp

1) get cust id when provided cust type name
2) populate cust and call getcusttypeid stored procedure
*/

CREATE PROC usp_GetCustomerTypeID

@CustTypeName VARCHAR(50),
@CustTypeID INT OUTPUT

AS

SET @CustTypeID = (
    SELECT CustomerTypeID
    FROM tblCUSTOMER_TYPE CT
    WHERE 
        CT.CustomerTypeName = @CustTypeName
)

GO

CREATE PROC usp_PopulateCustomer

@CustFName VARCHAR(50),
@CustLName VARCHAR(50),
@CustDOB DATE,
@CustType VARCHAR(50)

AS

DECLARE @IDCustType INT

EXEC usp_GetCustomerTypeID
    @CustTypeName = @CustType,
    @CustTyeID = @IDCustType OUTPUT

BEGIN TRAN
INSERT INTO tblCUSTOMER([CustFname], [CustLname], [CustBirthDate], [CustomerTypeID])
VALUES (@CustFName, @CustLName, @CustDOB, @IDCustType)

IF @@ERROR <> 0
    ROLLBACK TRAN
ELSE 
    COMMIT TRAN
GO