USE OTTER_spease
GO

/* Populate database */

INSERT INTO tblCUSTOMER_TYPE ([CustomerTypeName], [CustomerTypeDescr])
VALUES ('Retail', 'Old people'),
('Online', 'everyone else')

INSERT INTO tblPRODUCT_TYPE ([ProductTypeName], [ProductTypeDesc])
VALUES ('Accessory', 'its an accessory, yo')

-- Pull from Super_store db, with lots of customers
INSERT INTO tblCUSTOMER (
    [CustFname],
    [CustLname],
    [CustBirthDate],
    [CustomerTypeID]
)
SELECT TOP 2500000
    [CustomerFname],
    [CustomerLname],
    [DateOfBirth],
    (
        SELECT CustomerTypeID
        FROM tblCUSTOMER_TYPE
        WHERE CustomerTypeName = 'Online'
    )
FROM Super_Store.dbo.tblCUSTOMER

/* Nested stored procedure example */

CREATE PROCEDURE uspGetProdTypeID
@P_TYPE_NAME2 varchar(100),
@PT_ID2 INT OUTPUT
AS
SET @PT_ID2 = (
    SELECT TOP 1 ProductTypeID FROM tblPRODUCT_TYPE WHERE ProductTypeName = @P_TYPE_NAME2
    )
GO


CREATE PROCEDURE uspADDProduct
@ProdName varchar(100),
@Price numeric(10, 2),
@P_TYPE_NAME varchar(100),
@ProdDescr varchar(500)
AS 

DECLARE @PT_ID INT

EXEC uspGetProdTypeID @P_TYPE_NAME2 = @P_TYPE_NAME, @PT_ID2 = @PT_ID OUTPUT

IF @PT_ID is null
    BEGIN
    PRINT 'Hey.. lookup for ProductTypeID has no value'
    RAISERROR('@PT_ID cannot be NULL; session terminating',11,1)
    RETURN
    END


BEGIN TRAN
INSERT INTO tblPRODUCT (ProductName, ProductPrice, ProductTypeID, ProductDescr)
VALUES (@ProdName, @Price, @PT_ID, @ProdDescr)

IF @@ERROR <> 0
    ROLLBACK TRAN
ELSE 
    COMMIT TRAN
GO

EXEC uspADDProduct
@ProdName = 'Special Deluxe Wool Snowboard',
@Price = '24.99',
@P_TYPE_NAME = 'Accessory',
@ProdDescr = 'its a great hat'

EXEC uspADDProduct
@ProdName = 'Purple Sheepskin Deluxe Gloves',
@Price = '49.99',
@P_TYPE_NAME = 'Accessory',
@ProdDescr = 'Fantastic gloves'


/* Scope identity example */

BEGIN TRAN
INSERT INTO tblPRODUCT_TYPE (ProductTypeName, PRoductTypeDesc)
VALUES ('Helmet', 'Anything that keeps the head in one piece')

DECLARE @PTID INT
SET @PTID = (SELECT scope_identity())
INSERT INTO tblPRODUCT (ProductName, ProductPrice, ProductTypeID, ProductDescr)
VALUES ('Green hornet Helmet', 34.99, @PTID, 'Super fantastic head saver')

IF @@ERROR <> 0
    ROLLBACK TRAN
ELSE 
    COMMIT TRAN