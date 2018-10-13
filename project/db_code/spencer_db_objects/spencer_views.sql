/*
* Create Views
*
* - v_mostPopBrandByType
*     - Displays the most popular brand for each 
*       product type (by revenue) for the past 90 days
* - v_prodsSoldInPriceCategory
*     - Calculates the number of products sold in each 
*       price category in the last 30 days
* 
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