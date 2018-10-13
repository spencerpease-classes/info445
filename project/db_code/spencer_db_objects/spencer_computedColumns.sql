/*
* Create Computed Columns
*
* - fn_prodsSoldLastMonth
*     - Calculates the quantity of a product 
*       sold in the last month
* - fn_brandExpensiveProdTypes
*     - Counts the number of product types a 
*       brand has in the product catalog that
*       have an average product cost of at
*       least $100
* - fn_orderTotal
*     - Computes the total cost of an order
* 
*/


CREATE FUNCTION fn_prodsSoldLastMonth(@ProductID INT)

RETURNS INT
AS
BEGIN

DECLARE @Ret INT

SET @Ret = (
    SELECT SUM(op.Quantity) FROM tblPRODUCT p
        JOIN tblORDER_PRODUCT op on op.ProductID = p.ProductID
    WHERE op.ProductID = @ProductID
)

RETURN @Ret
END

GO

ALTER TABLE tblPRODUCT
ADD NumberSoldLastMonth
AS dbo.fn_prodsSoldLastMonth(ProductID)

GO


CREATE FUNCTION fn_brandExpensiveProdTypes(@BrandID INT)

RETURNS INT
AS
BEGIN

DECLARE @Ret INT

SET @Ret = (

    SELECT COUNT(*)
    FROM (

        SELECT COUNT(*) AS 'NumTypes' FROM tblBRAND b
        JOIN tblPRODUCT p on p.BrandID = b.BrandID
        JOIN tblPRODUCT_SUBTYPE pst on pst.ProductSubTypeID = p.ProductSubTypeID
        JOIN tblPRODUCT_TYPE pt on pt.ProductTypeID = pst.ProductTypeID

        WHERE b.BrandID = @BrandID

        GROUP BY pt.ProductTypeID
        HAVING AVG(p.Price) >= 100
    ) AS subq
)

RETURN @Ret
END

GO

ALTER TABLE tblBrand
ADD NumberExpensiveProdTypes
AS dbo.fn_brandExpensiveProdTypes(BrandID)

GO


CREATE FUNCTION fn_orderTotal(@OrderID INT)

RETURNS NUMERIC(12,2)
AS
BEGIN

DECLARE @Ret NUMERIC(12,2)

SET @Ret = (

    SELECT SUM(op.Quantity * p.Price) FROM tblORDER o
        JOIN tblORDER_PRODUCT op on op.OrderID = o.OrderID
        JOIN tblPRODUCT p on p.ProductID = op.ProductID

    WHERE o.OrderID = @OrderID
)

RETURN @Ret
END

GO

ALTER TABLE tblORDER
ADD OrderTotal
AS dbo.fn_orderTotal(OrderID)
