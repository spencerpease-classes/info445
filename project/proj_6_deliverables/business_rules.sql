/*
Business Rules
*/

/*
Calvin
*/

/* Business Rule 1 */
create function fn_noBeerForYouthsInIdaho()
returns int
as
BEGIN

declare @ret int = 0
if exists
(SELECT * FROM tblCUSTOMER c
JOIN tblORDER o ON c.CustomerID = o.CustomerID
JOIN tblORDER_PRODUCT op ON o.OrderID = op.OrderID
JOIN tblPRODUCT p ON op.ProductID = p.ProductID
JOIN tblPRODUCT_SUBTYPE pst on pst.ProductSubTypeID = p.ProductSubTypeID
JOIN tblPRODUCT_TYPE pt ON pt.ProductTypeID = pst.ProductTypeID
JOIN tblCUSTOMER_LOCATION cl ON c.CustomerID = cl.CustomerID
JOIN tblLOCATION l ON cl.LocationID = l.LocationID
WHERE l.State = 'ID'
AND pt.ProductTypeName = 'beverage'
AND p.ProductName LIKE '%beer%'
AND DATEDIFF(year, GETDATE(), c.CustomerDOB) >= 21)
SET @ret = 1
return @ret
end

GO

alter table tblORDER
add constraint NoBeersForIdahoans
CHECK (dbo.fn_noBeerForYouthsInIdaho() = 0)

GO


/* Business Rule 2 */
create function fn_noBoatOrdersNewEmployees()
returns int
as
BEGIN
declare @ret int = 0
if exists
(SELECT * FROM tblORDER o
JOIN tblORDER_PRODUCT op ON o.OrderID = op.OrderID
JOIN tblPRODUCT p ON op.ProductID = p.ProductID
JOIN tblPRODUCT_SUBTYPE pst on pst.ProductSubTypeID = p.ProductSubTypeID
JOIN tblPRODUCT_TYPE pt ON pt.ProductTypeID = pst.ProductTypeID
JOIN tblEmployee e ON o.EmployeeID = e.EmployeeID
JOIN tblEmployee_STORE es ON e.EmployeeID = es.EmployeeID
JOIN tblStore s ON es.StoreID = s.StoreID
WHERE s.StoreName = 'Seattle Flagship'
AND pt.ProductTypeName = 'boat'
AND DATEDIFF(year, es.StartDate, GETDATE()) < 2)
SET @ret = 1
return @ret
end

GO

alter table tblORDER
add constraint NoBoatOrdersForNewEmployees
CHECK (dbo.fn_noBoatOrdersNewEmployees() = 0)

GO

/*
Alex
*/

-- Function + Check that will prevent any product_supplier from being added if the product brand is REI and the supplier is from Texas
CREATE FUNCTION fn_NoREIFromTexas ()
RETURNS int
BEGIN
DECLARE @RET INT = 0

IF EXISTS (SELECT * FROM tblPRODUCT_SUPPLIER ps JOIN tblPRODUCT p ON ps.ProductID = p.ProductID JOIN tblBRAND b ON b.BrandID = p.BrandID JOIN tblSUPPLIER s ON s.SupplierID = ps.SupplierID JOIN tblSUPPLIER_LOCATION sl ON sl.SupplierID = s.SupplierID JOIN tblLOCATION l ON sl.LocationID = l.LocationID WHERE b.BrandName = 'REI' AND l.State = 'Texas')
SET @RET = 1

RETURN @RET
END

GO

ALTER TABLE tblProduct_Supplier
ADD CONSTRAINT chkREINoTexas
CHECK (dbo.fn_NoREIFromTexas() = 0)

GO

-- Function + Check that will prevent a customer from adding a product of type 'Pants' to an order if their last name is 'Smith' and they live in California
CREATE FUNCTION fn_NoPants()
RETURNS int AS
BEGIN
DECLARE @RET int = 0
IF EXISTS(SELECT * FROM tblORDER_PRODUCT op JOIN tblORDER o ON op.OrderID = o.OrderID JOIN tblCUSTOMER c ON o.CustomerID = c.CustomerID JOIN tblCUSTOMER_LOCATION cl ON cl.CustomerID = c. CustomerID JOIN tblLOCATION l ON l.LocationID = cl.LocationID 
JOIN tblPRODUCT p ON p.ProductID = op.ProductID 
JOIN tblPRODUCT_SUBTYPE ps ON p.ProductSubTypeID = ps.ProductSubTypeID
JOIN tblPRODUCT_TYPE pt ON pt.ProductTypeID = ps.ProductTypeID 
WHERE c.CustomerLName = 'Smith' AND l.State = 'California' AND pt.ProductTypeName = 'Pants')
SET @RET = 1

RETURN @RET
END


ALTER TABLE tblOrder_PRODUCT
    ADD CONSTRAINT chkNoPants
    CHECK (dbo.fn_NoPants() = 0)

GO

/*
David
*/

-- Business rule that Employees under the age of 25 cannot be managers if the store is in Idaho

CREATE FUNCTION fn_YoungManagerIdaho()
RETURNS INT
BEGIN 
DECLARE @RET INT = 0
IF EXISTS (SELECT * FROM tblEMPLOYEE e JOIN tblEMPLOYEE_TYPE et ON e.EmployeeTypeID = et.EmployeeTypeID JOIN tblEMPLOYEE_STORE es ON e.EmployeeID = es.EmployeeID JOIN tblSTORE s ON es.StoreID = S.StoreID JOIN tblLOCATION l ON s.LocationID = l.LocationID WHERE l.State = 'Idaho' AND e.EmployeeDOB > (SELECT GETDATE() - 365.25 * 25) AND et.EmployeeTypeName = 'Manager')
SET @RET = 1

RETURN @RET
END
GO

ALTER TABLE tblEMPLOYEE_STORE
ADD CONSTRAINT chkNoYoungIdahoManagers
CHECK (dbo.fn_YoungManagerIdaho() = 0)
GO

CREATE FUNCTION fn_SupplierMontanaNoHarleyBikes()
RETURNS INT
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT * FROM tblLocation l JOIN tblSUPPLIER_LOCATION sl ON l.LocationID = sl.LocationID JOIN tblSUPPLIER s ON sl.SupplierID = s.SupplierID JOIN tblPRODUCT_SUPPLIER ps ON s.SupplierID = ps.SupplierID JOIN PRODUCT p ON ps.ProductID = p.ProductID JOIN tblPRODUCT_SUBTYPE psub ON p.ProductSubTypeID = psub.ProductSubTypeID JOIN tblPRODUCT_TYPE pt ON psub.ProductTypeID = pt.ProductTypeID JOIN tblBRAND b ON p.BrandID = b.BrandID WHERE l.State = 'Montana' AND b.BrandName = 'Harley Davidson' AND pt.ProductTypeName = 'Bicycle')
SET @RET = 1

RETURN @RET
END

CREATE FUNCTION fn_SupplierMontanaNoHarleyBikes()
RETURNS INT
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT * FROM tblLocation l JOIN tblSUPPLIER_LOCATION sl ON l.LocationID = sl.LocationID JOIN tblSUPPLIER s ON sl.SupplierID = s.SupplierID JOIN tblPRODUCT_SUPPLIER ps ON s.SupplierID = ps.SupplierID JOIN tblPRODUCT p ON ps.ProductID = p.ProductID JOIN tblPRODUCT_SUBTYPE psub ON p.ProductSubTypeID = psub.ProductSubTypeID JOIN tblPRODUCT_TYPE pt ON psub.ProductTypeID = pt.ProductTypeID JOIN tblBRAND b ON p.BrandID = b.BrandID WHERE l.State = 'Montana' AND b.BrandName = 'Harley Davidson' AND pt.ProductTypeName = 'Bicycle')
SET @RET = 1

RETURN @RET
END


GO
ALTER TABLE tblPRODUCT_SUPPLIER
Add CONSTRAINT noBikesForGreg
CHECK (dbo.fn_SupplierMontanaNoHarleyBikes() = 0)
GO

/*
Spencer
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
