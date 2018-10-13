/*
CASE statement EC
2-27-18
*/

SELECT (CASE

    WHEN (o.Quantity * p.ProductPrice) < 10.00
    THEN 'Cheap'
    WHEN (o.Quantity * p.ProductPrice) BETWEEN 10.00 AND 20.00
    THEN 'Moderate'
    WHEN (o.Quantity * p.ProductPrice) > 200.00
    THEN 'Expensive'
    ELSE 'Unkown'
    END
)
AS 'PriceCategory', Count(*) AS 'TotalOrders'
FROM tblORDER o
    JOIN tblProduct p on o.ProductID = p.ProductID

GROUP BY (CASE

    WHEN (o.Quantity * p.ProductPrice) < 10.00
    THEN 'Cheap'
    WHEN (o.Quantity * p.ProductPrice) BETWEEN 10.00 AND 20.00
    THEN 'Moderate'
    WHEN (o.Quantity * p.ProductPrice) > 200.00
    THEN 'Expensive'
    ELSE 'Unkown'
    END
)
