/*
Computed Columns
*/

/*
Calvin
*/

/* Computed Column 1 */
Create function fn_computeNonSeattleEmployees(
@StoreID int)

returns int
AS
BEGIN
   RETURN (
       SELECT COUNT(*) FROM tblEMPLOYEE e
       JOIN tblEMPLOYEE_STORE es ON e.EmployeeID = es.EmployeeID
       JOIN tblSTORE s ON es.StoreID = s.StoreID
       JOIN tblLOCATION l ON s.LocationID = l.LocationID
       JOIN tblEMPLOYEE_LOCATION el ON e.EmployeeID = el.EmployeeID
       JOIN tblLOCATION employeeLocation ON el.LocationID = employeeLocation.LocationID
       WHERE l.City LIKE 'Seattle'
       AND employeeLocation.City NOT LIKE 'Seattle'
       AND s.StoreID = @StoreID)
END

GO

ALTER TABLE tblSTORE
ADD NonSeattleEmployees AS dbo.fn_computeNonSeattleEmployees(StoreID);
GO



/* Computed Column 2 */
create function fn_computeWashingtonTentLovers(
   @CustomerID int)

   returns int
   as
   begin
   return (SELECT COUNT(*) from tblCUSTOMER c
           JOIN tblCUSTOMER_LOCATION cl ON c.CustomerID = cl.CustomerID
           JOIN tblLOCATION l ON cl.LocationID = l.LocationID
           JOIN tblORDER o ON c.CustomerID = o.CustomerID 
           JOIN tblORDER_PRODUCT op ON o.OrderID = op.OrderID
           JOIN tblPRODUCT p ON op.ProductID = p.ProductID
           JOIN tblPRODUCT_SUBTYPE pst on pst.ProductSubTypeID = p.ProductSubTypeID
           JOIN tblPRODUCT_TYPE pt ON pt.ProductTypeID = pst.ProductTypeID
           WHERE c.CustomerID = @CustomerID
           AND pt.ProductTypeName LIKE '%TENT%'
           AND l.State LIKE 'WA')
   END

GO

ALTER TABLE tblCustomer
ADD TentOrders AS
dbo.fn_computeWashingtonTentLovers(CustomerID)

GO

/*
Alex
*/

CREATE FUNCTION fn_CountSameLName(@ProductID int) RETURNS int AS
BEGIN
RETURN (SELECT COUNT(*) FROM tblPRODUCT p JOIN tblORDER_PRODUCT op ON op.ProductID = p.ProductID JOIN tblORDER o ON op.OrderID = o.OrderID JOIN tblCUSTOMER c ON o.CustomerID = c.CustomerID JOIN tblEMPLOYEE e ON e.EmployeeID = O.EmployeeID WHERE e.EmployeeLName = c.CustomerLName AND p.ProductID = @ProductID)
END

ALTER TABLE tblProduct
    ADD CountSameLName AS (dbo.fn_CountSameLName(ProductID))

CREATE FUNCTION fn_CountWarehouses(@SupplierID int) RETURNS int AS
BEGIN
RETURN (SELECT COUNT(*) FROM tblSUPPLIER s JOIN tblSUPPLIER_LOCATION sl ON sl.SupplierID = s.SupplierID JOIN tblLOCATION l ON l.LocationID = sl.LocationID JOIN tblLOCATION_TYPE lt ON lt.LocationTypeID = l.LocationTypeID WHERE lt.LocationTypeName = 'warehouse' AND s.SupplierID = @SupplierID)
END

ALTER TABLE tblSupplier
    ADD WarehouseCount AS (dbo.fn_CountWarehouses(SupplierID))

/*
David
*/

CREATE FUNCTION fn_StoreTotalSold(@StoreID int) RETURNS numeric(12,2) AS 
BEGIN
RETURN (SELECT SUM(o.OrderTotal) FROM tblSTORE s JOIN tblEMPLOYEE_STORE es ON s.StoreID = es.StoreID JOIN tblEMPLOYEE e ON es.EmployeeID = e.EmployeeID JOIN tblORDER o ON e.EmployeeID = o.EmployeeID WHERE s.StoreID = @StoreID)
END

GO

ALTER TABLE tblSTORE
    ADD TotalSold AS (dbo.fn_StoreTotalSold(StoreID))
-- Function and Computed Column that will count number of employees working at each store who have started working within the last year

CREATE FUNCTION fn_NewEmployees(@StoreID int) RETURNS int AS
BEGIN 
RETURN (SELECT COUNT(*) FROM tblEMPLOYEE e JOIN tblEMPLOYEE_STORE es ON e.EmployeeID = es.EmployeeID JOIN tblSTORE s ON es.StoreID = s.StoreID WHERE s.StoreID = @StoreID AND es.StartDate > (SELECT GETDATE() - 365.25))
END
GO

ALTER TABLE tblSTORE 
    ADD TotalNewbies AS (dbo.fn_NewEmployees(StoreID))

/*
Spencer
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


