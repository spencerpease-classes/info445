USE [OTTER_spease]
GO

/*
Create business rul that restricts purchase of alcohol for anyone younger that 21
*/

CREATE FUNCTION fn_noBoozeYounger21()
RETURNS INT
AS

BEGIN
    DECLARE @Ret INT = 0
    IF EXISTS (
        SELECT *
        FROM tblPRODUCT_TYPE PT 
            JOIN tblPRODUCT P ON pt.ProductTypeID = P.ProductID
            JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
            JOIN tblORDER O ON OP.OrderID = OP.OrderID
            JOIN tblCUSTOMER C ON O.CustomerID = C.CustomerID
        WHERE C.CustBirthDate > (SELECT GetDate() - (365.25 * 21))
        AND PT.ProductTypeName = 'Alcohol'
    )

    SET @Ret = 1
    RETURN @Ret
END

SELECT dbo.fn_noBoozeYounger21()

ALTER TABLE tblORDER -- with nocheck -- doesn't check anything already in database
ADD CONSTRAINT CK_NoBooze21
CHECK (dbo.fn_noBoozeYounger21() = 0)


/*
While loop
*/

DECLARE @Num VARCHAR(4) = '25'
WHILE @Num > 0
BEGIN
    PRINT 'Greg needs coffee ' + @Num
    SET @Num = @Num - 1
END