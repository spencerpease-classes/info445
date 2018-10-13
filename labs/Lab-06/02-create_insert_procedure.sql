/*
* Create synthetic Transaction for populating tblCART
*
* Then Create a procedure for inserting into the cart
*    - usp_addToCart
*/

CREATE PROCEDURE usp_addToCart

    @ProductName VARCHAR(200),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeName VARCHAR(40),

    @CustomerFName VARCHAR(40),
    @CustomerLName VARCHAR(40),
    @CustomerBirthDate DATE,

    @Quantity INT,
    @DateAdded DATE = NULL

    AS

    IF @Quantity < 0
    BEGIN
        PRINT 'Cannot add a negative amount of a product to the cart';
        RAISERROR('Qantity cannot be negative', 11, 1);
        RETURN;
    END

    IF @DateAdded IS NULL
    BEGIN
        SET @DateAdded = GETDATE()
    END

    DECLARE @ProductID INT
    DECLARE @CustomerID INT

    EXEC usp_getProductID
        @ProductName = @ProductName,
        @ProductTypeName = @ProductTypeName,
        @ProductSubTypeName = @ProductSubTypeName,
        @ProductID = @ProductID OUTPUT

    EXEC usp_getCustomerID
        @CustomerFName = @CustomerFName,
        @CustomerLName = @CustomerLName,
        @CustomerBirthDate = @CustomerBirthDate,
        @CustomerID = @CustomerID OUTPUT

    BEGIN TRAN T1

        INSERT INTO tblCART (Quantity, DateAdded, CustomerID, ProductID)
        VALUES (@Quantity, @DateAdded, @CustomerID, @ProductID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
            
GO

