use Nov21_gthay
GO

CREATE TABLE tblORDER_HISTORY_spease (
	OrderHistoryID INT IDENTITY(1,1) primary key not null,
	OrderID INT not null,
	OrderDate DATE not null,
	CustID INT not null,
	ProductID INT not null,
	ArchiveDate DATE DEFAULT GetDate() not null);

GO

/*
* Write stored procedure tgat will copy data from tblORDER into tblORDER_HISTORY
*	- takes in a parameter that determines number of days to go backwards (int)
*	- takes in a parameter Brandname and only archives products with that brand
*	- read all rows of tblORDER, write, and then DELETE
*	- be sure to wrap all steps in an explicit transaction
*/

CREATE PROCEDURE usp_archiveOrderDays_spease

@LookBackDays INT,
@BrandName VARCHAR(50)

AS

DECLARE @BrandID INT

IF @LookBackDays > 100 OR @LookBackDays < 1
BEGIN
	PRINT @LookBackDays + 'is too large... you numskull'
	RAISERROR('Lookback days must be from 1 to 99', 11, 1)
	RETURN
END

Set @BrandID = (
	SELECT BrandName FROM tblBRAND
	WHERE BrandName = @BrandName
)

IF @BrandID IS NULL
BEGIN
	PRINT 'Could not find brand: ' + @BrandName
	RAISERROR('Null BrandID for given BrandName', 11, 1)

BEGIN TRAN T1

INSERT INTO tblORDER_HISTORY_spease (OrderID, OrderDate, CustID, ProductID, ArchiveDate)
SELECT o.OrderID, o.OrderDate, o.CustID, o.ProductID, GETDATE()
FROM tblORDER o
	JOIN tblPRODUCT p on p.ProductID = o.productid
	JOIN tblBRAND b on b.BrandID = p.BrandID
WHERE o.OrderDate > (SELECT GETDATE() - @LookBackDays)
AND b.BrandID = @BrandID

PRINT 'Archiving Orders'


DELETE
FROM tblORDER
WHERE OrderID IN (SELECT OrderID FROM tblORDER_HISTORY_spease)

IF @@ERROR <> 0
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1