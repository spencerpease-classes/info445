SELECT TOP 5 WITH TIES s.StoreName, SUM(op.PriceExtended) AS RazzyTotal

    FROM STORE s

    JOIN [ORDER] o
        ON s.StoreID = o.StoreID
    JOIN ORDER_PRODUCT op
        ON o.OrderID = op.OrderID
    JOIN PRODUCT p
        ON op.ProductID = p.ProductID

    WHERE p.ProductName = 'Razzy Special'
        AND o.OrderDate BETWEEN '2016-3-1' AND '2017-11-3'

    GROUP BY s.StoreID

    ORDER BY RazzyTotal desc

