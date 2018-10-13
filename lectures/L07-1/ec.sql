CREATE FUNCTION fn_bodumProds(@CustomerID INT)

RETURNS NUMERIC(7, 2)

AS
BEGIN

DECLARE @ret NUMERIC(7, 2)

SET @ret = (
    SELECT SUM(o.Quantity * p.ProductPrice) AS TotalSpent FROM tblCUSTOMER c
        JOIN tblORDER o on o.CustomerID = c.CustomerID
        JOIN tblPRODUCT p on p.ProductID = o.ProductID
        JOIN tblBRAND b on b.BrandID = p.BrandID

    WHERE b.BrandName = 'Bodum'
    AND c.CustomerID = @CustomerID
)

RETURN @ret
END

ALTER TABLE tblCUSTOMER
ADD SpentOnBodum NUMERIC(7,2)
AS (dbo.fn_bodumProds(CustomerID))
