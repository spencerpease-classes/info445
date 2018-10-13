/*
* Create Business Rules
*
* - fn_ageSpendingLimit
*     - Prevents anyone under 16 from spending more 
*       than $750 in a single order
* 
* - fn_cartLoyaltyLimit
*     - Prevents people who haven’t spent any money 
*       in the past 30 days from having more than 15 
*       different products in their cart and 60 items
*       total
* 
*/


CREATE FUNCTION fn_ageSpendingLimit()

RETURNS INT

AS
BEGIN

DECLARE @Ret INT = 0

IF EXISTS (
    SELECT c.CustomerID, o.OrderID FROM tblORDER o
        JOIN tblCUSTOMER c on c.CustomerID = o.CustomerID
        JOIN tblORDER_PRODUCT op on op.OrderID = o.OrderID
        JOIN tblPRODUCT p on p.ProductID = op.ProductID

    WHERE DATEADD(year, 16, c.CustomerDOB) > GETDATE()

    GROUP BY c.CustomerID, o.OrderID
    HAVING SUM(op.Quantity * p.Price) > 750.00
)

    SET @Ret = 1
RETURN @Ret
END

GO

ALTER TABLE tblORDER
ADD CONSTRAINT ageSpendingLimit
CHECK (dbo.fn_ageSpendingLimit() = 0)

GO


CREATE FUNCTION fn_cartLoyaltyLimit()

RETURNS INT

AS
BEGIN

DECLARE @Ret INT = 0

IF EXISTS (
    SELECT ca.CustomerID FROM tblCART ca
        JOIN tblCUSTOMER cu on cu.CustomerID = ca.CustomerID
        JOIN tblORDER o on o.CustomerID = ca.CustomerID
        JOIN tblPRODUCT p on p.ProductID = ca.ProductID

    WHERE DATEADD(day, 30, o.OrderDate) < GETDATE()

    GROUP BY ca.CustomerID
    HAVING COUNT(DISTINCT ca.ProductID) > 15
    AND SUM(ca.Quantity) > 60

)

    SET @Ret = 1
RETURN @Ret
END

GO

ALTER TABLE tblCART
ADD CONSTRAINT cartLoyaltyLimit
CHECK (dbo.fn_cartLoyaltyLimit() = 0)

GO
