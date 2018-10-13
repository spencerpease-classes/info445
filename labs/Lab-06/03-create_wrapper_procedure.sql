/*
* Create synthetic Transaction for populating tblCART
*
* Finally, Create a wrapper that calls usp_addToCart 
* a given number of times
*   - usp_wrapper_addToCart
*/


CREATE PROCEDURE usp_wrapper_addToCart

    -- Number of inserts to make
    @Run INT

    AS

    -- parameters to pass wrapped stored procedure
    DECLARE @ProductName VARCHAR(200)
    DECLARE @ProductTypeName VARCHAR(40)
    DECLARE @ProductSubTypeName VARCHAR(40)
 
    DECLARE @CustomerFName VARCHAR(40)
    DECLARE @CustomerLName VARCHAR(40)
    DECLARE @CustomerBirthDate DATE
 
    DECLARE @Quantity INT
    DECLARE @DateAdded DATE

    -- Variables to hold random pks
    DECLARE @RandPID INT
    DECLARE @RandCID INT

    -- Get the size of the tables that are being drawn from
    DECLARE @CountProd INT = (SELECT COUNT(*) FROM tblPRODUCT)
    DECLARE @CountCust INT = (SELECT COUNT(*) FROM tblCUSTOMER)

    -- Do @Run random inserts into tblCART
    WHILE @Run > 0
    BEGIN

        -- Get random pks to look up
        -- This assumes no wasted ids in the tables
        SET @RandPID = (SELECT (@CountProd * RAND() + 1))
        SET @RandCID = (SELECT (@CountProd * RAND() + 1))

        -- Look up parameters for insert

        SET @ProductName = (
            SELECT ProductName FROM tblPRODUCT
            WHERE ProductID = @RandPID
        )

        SET @ProductSubTypeName = (
            SELECT ProductSubTypeName FROM tblPRODUCT_SUBTYPE pst
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE ProductID = @RandPID
        )

        SET @ProductTypeName = (
            SELECT ProductTypeName FROM tblPRODUCT_TYPE pt
                JOIN tblPRODUCT_SUBTYPE pst on pst.ProductTypeID = pt.ProductTypeID
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE ProductID = @RandPID
        )

        SET @CustomerFName = (
            SELECT CustomerFName FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @CustomerLName = (
            SELECT CustomerLName FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @CustomerBirthDate = (
            SELECT CustomerBirthDate FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @Quantity = (SELECT (10 * RAND() + 1))
        SET @DateAdded = (SELECT DATEADD(day, RAND() * -3650, GETDATE()))


        -- Execute insert into tblCART
        EXEC usp_addToCart
            @ProductName = @ProductName,
            @ProductTypeName = @ProductTypeName,
            @ProductSubTypeName = @ProductSubTypeName,
            @CustomerFName = @CustomerFName,
            @CustomerLName = @CustomerLName,
            @CustomerBirthDate = @CustomerBirthDate,
            @Quantity = @Quantity,
            @DateAdded = @DateAdded

        SET @Run = @Run - 1
        
    END

GO