/*
Views
*/

/*
Calvin
*/

create view v_StoreMostOrders AS
SELECT TOP 5 s.StoreName, COUNT(o.OrderID) AS NumberOfOrders
FROM tblSTORE s JOIN tblLOCATION l ON s.StoreID = l.LocationID
JOIN tblCUSTOMER_LOCATION cl ON l.LocationID = cl.LocationID
JOIN tblCUSTOMER c ON cl.CustomerID = c.CustomerID
JOIN tblORDER o ON c.CustomerID = o.CustomerID
GROUP BY s.StoreID, s.StoreName
ORDER BY COUNT(o.OrderID) DESC;


create view v_WashingtonCustomersWithMostTentOrders AS
SELECT TOP 10 c.CustomerID, COUNT(o.OrderID) AS TentORders
FROM tblCUSTOMER c
JOIN tblCUSTOMER_LOCATION cl ON c.CustomerID = cl.CustomerID
JOIN tblLOCATION l ON cl.LocationID = l.LocationID
JOIN tblORDER o ON c.CustomerID = o.CustomerID
JOIN tblORDER_PRODUCT op ON o.OrderID = op.OrderID
JOIN tblPRODUCT p ON op.ProductID = p.ProductID
WHERE l.State = 'WA'
AND p.ProductName LIKE '%Tent%'
GROUP BY c.CustomerID
ORDER BY COUNT(o.OrderID) DESC;

/*
Alex
*/

-- VIEW that will show the top 5 employees who have sold the most in WA stores
CREATE VIEW v_TopEmpWA AS
SELECT TOP 5 e.EmployeeID, e.EmployeeFName, e.EmployeeLName, o.OrderTotal FROM tblEMPLOYEE e JOIN tblEMPLOYEE_STORE es ON es.EmployeeID = e.EmployeeID JOIN tblSTORE s ON s.StoreID = es.StoreID JOIN tblLOCATION l ON l.LocationID = s.LocationID JOIN tblORDER o ON o.EmployeeID = e.EmployeeID WHERE l.State = 'Washington' ORDER BY o.OrderTotal

-- VIEW that will show the number of stores in each US census region
CREATE VIEW v_StoreRegion AS
SELECT (
    CASE WHEN l.State IN ('Washington', 'Oregon', 'California', 'Alaska', 'Hawaii') THEN 'Pacific'
    WHEN l.State IN ('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 'Wyoming') THEN 'Mountain'
    WHEN l.State IN ('Arkansas', 'Louisiana', 'Oklahoma', 'Texas') THEN 'West South Central'
    WHEN l.State IN ('Alabama', 'Kentucky', 'Mississippi', 'Tennessee') THEN 'East South Central'
    WHEN l.State IN ('Delaware', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 'Virginia', 'West Virginia') THEN 'South Atlantic'
    ELSE 'Other'
    END
) AS StoreRegion, COUNT(*) AS StoreCount FROM tblSTORE s JOIN tblLOCATION l ON l.LocationID = s.LocationID 
GROUP BY (
    CASE WHEN l.State IN ('Washington', 'Oregon', 'California', 'Alaska', 'Hawaii') THEN 'Pacific'
    WHEN l.State IN ('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 'Wyoming') THEN 'Mountain'
    WHEN l.State IN ('Arkansas', 'Louisiana', 'Oklahoma', 'Texas') THEN 'West South Central'
    WHEN l.State IN ('Alabama', 'Kentucky', 'Mississippi', 'Tennessee') THEN 'East South Central'
    WHEN l.State IN ('Delaware', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 'Virginia', 'West Virginia') THEN 'South Atlantic'
    ELSE 'Other'
    END
)

/*
David
*/

-- Shows Employees with more than ten orders within the last week in Washington
CREATE VIEW v_WashingtonEmployeesWithTenOrders AS

SELECT e.EmployeeFName, e.EmployeeLName, COUNT(*) As OrderNumber
FROM tblEMPLOYEE e JOIN tblORDER o ON e.EmployeeID = O.EmployeeID JOIN tblEMPLOYEE_LOCATION el ON e.EmployeeID = el.EmployeeID JOIN tblLocation l ON el.LocationID = l.LocationID 
WHERE l.state = 'Washington' AND O.OrderDate > (SELECT GETDATE() - 7)
GROUP BY e.EmployeeFName, e.EmployeeLName
HAVING COUNT(*) > 10

-- Shows product categories each supplier makes products for
CREATE VIEW  v_SupplierCategories AS
SELECT s.SupplierName,pt.ProductTypeName, count(*) AS ProductNumber
FROM tblSupplier s JOIN tblPRODUCT_SUPPLIER ps ON s.SupplierID = ps.SupplierID JOIN tblPRODUCT p ON ps.ProductID = p.ProductID JOIN tblPRODUCT_SUBTYPE psub ON p.ProductSubTypeID = psub.ProductSubTypeID JOIN tblPRODUCT_TYPE pt ON psub.ProductTypeID = pt.ProductTypeID
GROUP BY s.SupplierName, pt.ProductTypeName

/*
Spencer
*/

CREATE VIEW v_productBrandRevenue
AS

    SELECT pt.ProductTypeName, b.BrandName, SUM(op.Quantity * p.Price) AS 'Revenue'
    FROM tblORDER_PRODUCT op
        JOIN tblORDER o on o.OrderID = op.OrderID
        JOIN tblPRODUCT p on p.ProductID = op.OrderProductID
        JOIN tblPRODUCT_SUBTYPE pst on pst.ProductSubTypeID = p.ProductSubTypeID
        JOIN tblPRODUCT_TYPE pt on pt.ProductTypeID = pst.ProductTypeID
        JOIN tblBRAND b on b.BrandID = p.BrandID
    WHERE o.OrderDate BETWEEN DATEADD(day, -90, GETDATE()) AND GETDATE()
    GROUP BY pt.ProductTypeName, b.BrandName

GO

CREATE VIEW v_mostPopBrandByType
AS

    SELECT subq2.ProductTypeName, subq3.Brandname, subq2.Revenue
    FROM (
        SELECT subq.ProductTypeName, MAX(subq.Revenue) As 'Revenue'
        FROM v_productBrandRevenue AS subq
        GROUP BY subq.ProductTypeName
    ) AS subq2
    LEFT JOIN v_productBrandRevenue AS subq3 on subq3.Revenue = subq2.Revenue

GO


CREATE VIEW v_prodsSoldInPriceCategory
AS

    SELECT (CASE

        WHEN p.Price < 10.00
        THEN 'Less than $10'
        WHEN p.Price BETWEEN 10.00 AND 99.99
        THEN '$10 up to $100'
        WHEN p.Price BETWEEN 100.00 AND 999.99
        THEN '$100 up to $999.99'
        WHEN p.Price BETWEEN 1000.00 AND 9999.99
        THEN '$1,000 up to $9,999.99'
        WHEN p.Price BETWEEN 10000.00 AND 99999.99
        THEN '$10,000 up to $99,000'
        ELSE '$100,000 or above'
        END
    ) AS 'Logarithmic Price Category', SUM(op.Quantity) AS 'Number of Products Sold'

    FROM tblPRODUCT p
    JOIN tblORDER_PRODUCT op on op.ProductID = p.ProductID
    JOIN tblORDER o on o.OrderID = op.OrderID

    WHERE o.OrderDate BETWEEN DATEADD(day, -30, GETDATE()) AND GETDATE()

    GROUP BY (CASE

        WHEN p.Price < 10.00
        THEN 'Less than $10'
        WHEN p.Price BETWEEN 10.00 AND 99.99
        THEN '$10 up to $100'
        WHEN p.Price BETWEEN 100.00 AND 999.99
        THEN '$100 up to $999.99'
        WHEN p.Price BETWEEN 1000.00 AND 9999.99
        THEN '$1,000 up to $9,999.99'
        WHEN p.Price BETWEEN 10000.00 AND 99999.99
        THEN '$10,000 up to $99,000'
        ELSE '$100,000 or above'
        END
    )

GO



