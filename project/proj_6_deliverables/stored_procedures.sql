/*
Stored Procedures
*/

/*
Calvin
*/

-- Stored Procedure 1
create procedure uspInsertEmployeeLocation
  @Street_Add varchar(40),
  @City varchar(40),
  @Fname varchar(40),
  @Lname varchar(40)
AS
DECLARE @E_ID int = (SELECT EmployeeID FROM tblEMPLOYEE WHERE EmployeeFName = @Fname AND EmployeeLName = @Lname)
DECLARE @L_ID int = (SELECT LocationID FROM tblLOCATION WHERE StreetAddress = @Street_Add AND City = @City)

IF @E_ID is null
begin
   print '@E_ID is null there is no matching name';
   raiserror('nulllll',11,1);
   return;
end

IF @L_ID is null
begin
   print '@L_ID is null there is no matching name';
   raiserror('l id is nulllll,',11,1);
   return;
end

insert into tblEMPLOYEE_LOCATION(EmployeeID, LocationID)
VALUES (@E_ID, @L_ID)

   IF @@error <> 0
       ROLLBACK Tran T1
   else
       commit tran T1

GO

-- Stored Procedure 2
CREATE PROCEDURE uspInsertEmployeeLocation_WRAPPER
  @RUN int
AS
declare @E_ID int -- Employee ID
declare @L_ID int -- Location ID
declare @E_TableSize int
declare @L_TableSize int
declare @L_Rand int

declare @F varchar(40)
declare @L varchar(40)
declare @SA varchar(40)
declare @C varchar(40)

While @RUN > 0 BEGIN

  -- Get Employee random ID --
  SET @E_TableSize = (SELECT COUNT(*) FROM tblEMPLOYEE)
  SET @E_ID = (SELECT RAND() * @E_TableSize)
  IF @E_ID < 1
      BEGIN PRINT 'Employee ID is less than 1'
      SET @E_ID = (SELECT RAND() * @E_TableSize)
      END

  -- Get Location random ID --
  SET @L_TableSize = (SELECT COUNT(*) FROM tblLOCATION)
  SET @L_ID= (SELECT RAND() * @L_TableSize)
  IF @L_ID < 1
      BEGIN PRINT 'Employee ID is less than 1'
      SET @L_ID = (SELECT RAND() * @L_TableSize)
      END

  PRINT @RUN

  SET @F =     (SELECT EmployeeFName   FROM tblEMPLOYEE WHERE EmployeeID = @E_ID)
  SET @L =     (SELECT EmployeeLName   FROM tblEMPLOYEE WHERE EmployeeID = @E_ID)
  SET @SA =    (SELECT StreetAddress   FROM tblLOCATION WHERE LocationID = @L_ID)
  SET @C =     (SELECT City            FROM tblLOCATION WHERE LocationID = @L_ID)

  exec uspInsertEmployeeLocation
   @Street_Add = @SA,
   @City = @C,
   @Fname = @F,
   @Lname = @L

  SET @Run = @Run - 1
end

GO

/*
Alex 
*/

CREATE PROCEDURE usp_HireEmployee
@FName varchar(40),
@LName varchar(40),
@DOB date,
@StartDate date,
@EndDate date,
@StoreName varchar(40)
AS
DECLARE @NewEmpID int
DECLARE @StoreID int

IF @FName IS NULL
BEGIN
RAISERROR('FName cannot be null', 11, 1)
RETURN
END

IF @LName IS NULL
BEGIN
RAISERROR('LName cannot be null', 11, 1)
RETURN
END

IF @DOB IS NULL
BEGIN
RAISERROR('DOB cannot be null', 11, 1)
RETURN
END

IF @StartDate IS NULL
BEGIN
RAISERROR('StartDate cannot be null', 11, 1)
RETURN
END

IF @EndDate IS NULL
BEGIN
RAISERROR('EndDate cannot be null', 11, 1)
RETURN
END

IF @StoreName IS NULL
BEGIN
RAISERROR('StoreName cannot be null', 11, 1)
RETURN
END


BEGIN TRAN T1
INSERT INTO tblEMPLOYEE(EmployeeFName, EmployeeLName, EmployeeDOB) VALUES (@FName, @LName, @DOB)
SET @NewEmpID = (SELECT SCOPE_IDENTITY())

EXEC usp_GetStoreID @StoreName = @StoreName, @StoreID = @StoreID OUTPUT

INSERT INTO tblEMPLOYEE_STORE(StartDate, EndDate, StoreID, EmployeeID) VALUES (@StartDate, @EndDate, @StoreID, @NewEmpID)

IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1

GO

CREATE PROCEDURE usp_InsertNewLoc
@StreetAddress varchar(120),
@City varchar(75),
@State varchar(25),
@Zip varchar(25),
@LocTypeName varchar(40)
AS
DECLARE @LocTypeID int

IF @StreetAddress IS NULL
BEGIN
RAISERROR('StreetAddress cannot be null', 11, 1)
RETURN
END

IF @City IS NULL
BEGIN
RAISERROR('City cannot be null', 11, 1)
RETURN
END

IF @State IS NULL
BEGIN
RAISERROR('State cannot be null', 11, 1)
RETURN
END

IF @Zip IS NULL
BEGIN
RAISERROR('Zip cannot be null', 11, 1)
RETURN
END

EXEC usp_getLocationTypeID @LocationTypeName=@LocTypeName, @LocationTypeID=@LocTypeID OUTPUT

BEGIN TRAN T1
INSERT INTO tblLOCATION(StreetAddress, City, State, Zip, LocationTypeID) VALUES (@StreetAddress, @City, @State, @Zip, @LocTypeID)

IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1

/*
David
*/

CREATE PROCEDURE usp_PopulateEmployeeStore
@FName VarChar(40),
@LName VarChar(40),
@EmpTypeName varchar(40),
@DOB DATE,
@_StoreName VarChar(40),
@StreetAddress varchar(120),
@City varchar(75),
@State varchar(25),
@Zip varchar(25),
@LocationTypeName varchar(40),
@StartDate DATE,
@EndDate DATE

AS
BEGIN
DECLARE @_EmployeeID INT
DECLARE @_StoreID INT

EXEC usp_getEmployeeID
@EmployeeFName = @FName,
@EmployeeLName = @LName,
@EmployeeDOB = @DOB,
@EmployeeTypeName = @EmpTypeName,
@EmployeeID = @_EmployeeID OUTPUT

if @_EmployeeID is null
   Throw 50001, 'Employee Not Found', 1

EXEC usp_getStoreID
@StoreName = @_StoreName,
@StoreID = @_StoreID OUTPUT

if @_StoreID is null
   Throw 50001, 'Store Not Found', 1

BEGIN TRAN T1
INSERT INTO tblEMPLOYEE_STORE(StartDate, EndDate, EmployeeID, StoreID)
Values(@StartDate, @EndDate, @_EmployeeID, @_StoreID)

IF @@ERROR <> 0
   ROLLBACK TRAN T1
ELSE
   COMMIT TRAN T1

END

CREATE PROCEDURE usp_EmployeeStore_Wrapper
@RUN int
AS
BEGIN
   DECLARE @Fname varchar(40)
   DECLARE @Lname varchar(40)
   DECLARE @Dob date
   DECLARE @StoreName varchar(40)
   DECLARE @StreetAddress varchar(120)
   DECLARE @City varchar(70)
   DECLARE @State varchar(70)
   DECLARE @Zip varchar(25)
    DECLARE @LocationTypeName varchar(40)
    DECLARE   @StartDate Date
     DECLARE  @EndDate Date
    DECLARE   @_EmployeeRowCount int = (SELECT COUNT(*) FROM tblEMPLOYEE)
     DECLARE  @_StoreRowCount int = (SELECT COUNT(*) FROM tblSTORE)
     DECLARE  @_LocationRowCount int = (SELECT COUNT(*) FROM tblLOCATION)
      DECLARE @_LocationTypeRowCount int = (SELECT COUNT(*) FROM tblLOCATION_TYPE)
    DECLARE @EmpTypeName varchar(40)
   DECLARE    @_RAND numeric(4,4)
     DECLARE  @_ID int
  

   WHILE @RUN > 0
       BEGIN
           SET @_RAND = (SELECT RAND())
           SET @_ID = (@_RAND * @_EmployeeRowCount + 1)
           SET @Fname = (SELECT EmployeeFname FROM tblEMPLOYEE WHERE EmployeeID = @_ID)
           SET @Lname = (SELECT EmployeeLname FROM tblEMPLOYEE WHERE EmployeeID = @_ID)
           SET @DOB = (SELECT EmployeeDOB FROM tblEMPLOYEE WHERE EmployeeID = @_ID)

           SET @EmpTypeName = (SELECT EmployeeTypeName FROM tblEMPLOYEE_TYPE et JOIN tblEMPLOYEE e ON e.EmployeeTypeID = et.EmployeeTypeID WHERE EmployeeID = @_ID)

           SET @_RAND = (SELECT RAND())
           SET @_ID = (@_RAND * @_StoreRowCount + 1)
           SET @StoreName = (SELECT StoreName FROM tblSTORE WHERE StoreID = @_ID)

           SET @_RAND = (SELECT RAND())
           SET @_ID = (@_RAND * @_LocationRowCount + 1)
           SET @StreetAddress = (SELECT StreetAddress FROM tblLOCATION WHERE LocationID = @_ID)
           SET @City = (SELECT City FROM tblLOCATION WHERE LocationID = @_ID)
           SET @State = (SELECT State FROM tblLOCATION WHERE LocationID = @_ID)
           SET @Zip = (SELECT Zip FROM tblLOCATION WHERE LocationID = @_ID)


           SET @_RAND = (SELECT RAND())
           SET @_ID = (@_RAND * @_LocationTypeRowCount + 1)
           SET @LocationTypeName = (SELECT LocationTypeName FROM tblLOCATION_TYPE WHERE LocationTypeID = @_ID)

           SET @_RAND = (SELECT RAND())
           SET @StartDate = ((SELECT GetDate()) - 365.25 * @_RAND)
           SET @EndDate =  (SELECT CASE
                               WHEN @_RAND < 0.5 THEN null
                               ELSE (SELECT GetDate())
                           END)

           EXEC usp_PopulateEmployeeStore
               @EmpTypeName = @EmpTypeName,
               @FName = @Fname,
               @LName = @Lname,
               @DOB = @DOB,
               @_StoreName = @StoreName,
               @StreetAddress = @StreetAddress,
               @City = @City,
               @State = @State,
               @Zip = @Zip,
               @LocationTypeName = @LocationTypeName,
               @StartDate = @StartDate,
               @EndDate = @EndDate

           SET @RUN = @RUN - 1
       END
END

/*
Spencer
*/

-- usp_addSupplierLocation

CREATE PROCEDURE usp_addSupplierLocation

    @SupplierName VARCHAR(40),

    @StreetAddress VARCHAR(120),
    @City VARCHAR(75),
    @State VARCHAR(25),
    @Zip VARCHAR(25),
    @LocationTypeName VARCHAR(40)

    AS

    DECLARE @SupplierID INT
    DECLARE @LocationID INT

    EXEC usp_getSupplierID
        @SupplierName = @SupplierName,
        @SupplierID = @SupplierID OUTPUT
    
    EXEC usp_getLocationID
        @StreetAddress = @StreetAddress,
        @City = @City,
        @State = @State,
        @Zip = @Zip,
        @LocationTypeName = @LocationTypeName,
        @LocationID = @LocationID OUTPUT
    
    BEGIN TRAN T1

        INSERT INTO tblSUPPLIER_LOCATION (SupplierID, LocationID)
        VALUES (@SupplierID, @LocationID)
    
        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
            
GO


-- usp_addSupplierLocation_WRAPPER

CREATE PROCEDURE usp_addSupplierLocation_WRAPPER

    @Run INT

    AS

    -- Parameters to look up
    DECLARE @SupplierName VARCHAR(40)

    DECLARE @StreetAddress VARCHAR(120)
    DECLARE @City VARCHAR(75)
    DECLARE @State VARCHAR(25)
    DECLARE @Zip VARCHAR(25)
    DECLARE @LocationTypeName VARCHAR(40)

    -- Randoms ids to look up
    DECLARE @RandSupplierID INT
    DECLARE @RandLocationID INT

    -- Range of random ids to select from
    DECLARE @SupplierCount INT = (SELECT COUNT(*) FROM tblSUPPLIER) 
    DECLARE @LocationCount INT = (SELECT COUNT(*) FROM tblLOCATION)

    -- Do @Run random inserts
    WHILE @Run > 0
    BEGIN

        -- get random id
        SET @RandSupplierID = (SELECT (@SupplierCount * RAND() + 1))
        SET @RandLocationID = (SELECT (@LocationCount * RAND() + 1))

        -- set parameters based on random id
        SET @SupplierName = (
            SELECT SupplierName FROM tblSUPPLIER
            WHERE SupplierID = @RandSupplierID
        )

        SET @StreetAddress = (
            SELECT StreetAddress FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @City = (
            SELECT City FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @State = (
            SELECT [State] FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @Zip = (
            SELECT Zip FROM tblLOCATION
            WHERE LocationID = @RandLocationID
        )

        SET @LocationTypeName = (
            SELECT LocationTypeName FROM tblLOCATION_TYPE lt
                JOIN tblLOCATION l on l.LocationTypeID = lt.LocationTypeID
            WHERE LocationID = @RandLocationID
        )

        -- insert into table
        EXEC usp_addSupplierLocation
            @SupplierName = @SupplierName,
            @StreetAddress = @StreetAddress,
            @City = @City,
            @State = @State,
            @Zip = @Zip,
            @LocationTypeName = @LocationTypeName 

        SET @Run = @Run - 1
    END
GO

-- usp_addSupplierProduct

CREATE PROCEDURE usp_addProductSupplier

    @SupplierName VARCHAR(40),

    @ProductName VARCHAR(200),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeName VARCHAR(40),
    @BrandName VARCHAR(40)

    AS

    DECLARE @SupplierID INT
    DECLARE @ProductID INT

    EXEC usp_getSupplierID
        @SupplierName = @SupplierName,
        @SupplierID = @SupplierID OUTPUT
    
    EXEC usp_getProductID
        @ProductName = @ProductName,
        @ProductTypeName = @ProductTypeName,
        @ProductSubTypeName = @ProductSubTypeName,
        @BrandName = @BrandName,
        @ProductID = @ProductID OUTPUT
    
    BEGIN TRAN T1

        INSERT INTO tblPRODUCT_SUPPLIER (SupplierID, ProductID)
        VALUES (@SupplierID, @ProductID)
    
        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
            
GO


-- usp_addSupplierProduct_WRAPPER

CREATE PROCEDURE usp_addSupplierProduct_WRAPPER

    @Run INT

    AS

    -- Parameters to look up
    DECLARE @SupplierName VARCHAR(40)

    DECLARE @ProductName VARCHAR(200)
    DECLARE @ProductTypeName VARCHAR(40)
    DECLARE @ProductSubTypeName VARCHAR(40)
    DECLARE @BrandName VARCHAR(40)

    -- Randoms ids to look up
    DECLARE @RandSupplierID INT
    DECLARE @RandProductID INT

    -- Range of random ids to select from
    DECLARE @SupplierCount INT = (SELECT COUNT(*) FROM tblSUPPLIER) 
    DECLARE @ProductCount INT = (SELECT COUNT(*) FROM tblPRODUCT)

    -- Do @Run random inserts
    WHILE @Run > 0
    BEGIN

        -- get random id
        SET @RandSupplierID = (SELECT (@SupplierCount * RAND() + 1))
        SET @RandProductID = (SELECT (@ProductCount * RAND() + 1))

        -- set parameters based on random id
        SET @SupplierName = (
            SELECT SupplierName FROM tblSUPPLIER
            WHERE SupplierID = @RandSupplierID
        )

        SET @ProductName = (
            SELECT ProductName FROM tblPRODUCT
            WHERE ProductID = @RandProductID
        )

        SET @ProductTypeName = (
            SELECT ProductTypeName FROM tblPRODUCT_TYPE pt
                JOIN tblPRODUCT_SUBTYPE pst on pst.ProductTypeID = pt.ProductTypeID
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE p.ProductID = @RandProductID
        )

        SET @ProductSubTypeName = (
            SELECT ProductSubTypeName FROM tblPRODUCT_SUBTYPE pst
                JOIN tblPRODUCT p on p.ProductSubTypeID = pst.ProductSubTypeID
            WHERE p.ProductID = @RandProductID
        )

        SET @BrandName = (
            SELECT BrandName FROM tblBRAND b 
                JOIN tblPRODUCT p on p.BrandID = b.BrandID
            WHERE p.ProductID = @RandProductID
        )

        -- insert into table
        EXEC usp_addProductSupplier
            @SupplierName = @SupplierName,
            @ProductName = @ProductName,
            @ProductTypeName = @ProductTypeName,
            @ProductSubTypeName = @ProductSubTypeName,
            @BrandName = @BrandName
    
        SET @Run = @Run - 1

    END

GO


CREATE PROCEDURE usp_addToCart

    @ProductName VARCHAR(200),
    @ProductTypeName VARCHAR(40),
    @ProductSubTypeName VARCHAR(40),
    @BrandName VARCHAR(40),

    @CustomerFName VARCHAR(40),
    @CustomerLName VARCHAR(40),
    @CustomerDOB DATE,

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
        @BrandName = @BrandName,
        @ProductID = @ProductID OUTPUT

    EXEC usp_getCustomerID
        @CustomerFName = @CustomerFName,
        @CustomerLName = @CustomerLName,
        @CustomerDOB = @CustomerDOB,
        @CustomerID = @CustomerID OUTPUT

    BEGIN TRAN T1

        INSERT INTO tblCART (Quantity, DateAdded, CustomerID, ProductID)
        VALUES (@Quantity, @DateAdded, @CustomerID, @ProductID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1
            
GO


CREATE PROCEDURE usp_wrapper_addToCart

    -- Number of inserts to make
    @Run INT

    AS

    -- parameters to pass wrapped stored procedure
    DECLARE @ProductName VARCHAR(200)
    DECLARE @ProductTypeName VARCHAR(40)
    DECLARE @ProductSubTypeName VARCHAR(40)
    DECLARE @BrandName VARCHAR(40)
 
    DECLARE @CustomerFName VARCHAR(40)
    DECLARE @CustomerLName VARCHAR(40)
    DECLARE @CustomerDOB DATE
 
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
            WHERE p.ProductID = @RandPID
        )

        SET @BrandName = (
            SELECT BrandName FROM tblBRAND b 
                JOIN tblPRODUCT p on p.BrandID = b.BrandID
            WHERE p.ProductID = @RandPID
        )

        SET @CustomerFName = (
            SELECT CustomerFName FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @CustomerLName = (
            SELECT CustomerLName FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @CustomerDOB = (
            SELECT CustomerDOB FROM tblCUSTOMER
            WHERE CustomerID = @RandCID
        )

        SET @Quantity = (SELECT (10 * RAND() + 1))
        SET @DateAdded = (SELECT DATEADD(day, RAND() * -3650, GETDATE()))


        -- Execute insert into tblCART
        EXEC usp_addToCart
            @ProductName = @ProductName,
            @ProductTypeName = @ProductTypeName,
            @ProductSubTypeName = @ProductSubTypeName,
            @BrandName = @BrandName,
            @CustomerFName = @CustomerFName,
            @CustomerLName = @CustomerLName,
            @CustomerDOB = @CustomerDOB,
            @Quantity = @Quantity,
            @DateAdded = @DateAdded

        SET @Run = @Run - 1
        
    END

GO


-- Add products to an order

CREATE PROCEDURE usp_addProductsToOrder

    @OrderID INT,
    @NumProducts INT

    AS

    IF @OrderID IS NULL
    BEGIN
        PRINT 'Cannot find OrderID';
        RAISERROR('OrderID cannot be NULL', 11, 1);
        RETURN;
    END

    IF @NumProducts IS NULL
    BEGIN
        PRINT 'Cannot find number of products';
        RAISERROR('NumProducts cannot be NULL', 11, 1);
        RETURN;
    END

    -- parameters to pass wrapped stored procedure
    DECLARE @ProductName VARCHAR(200)
    DECLARE @ProductTypeName VARCHAR(40)
    DECLARE @ProductSubTypeName VARCHAR(40)
    DECLARE @BrandName VARCHAR(40)

    DECLARE @ProductID INT
  
    DECLARE @Quantity INT


    -- Variables to hold random pks
    DECLARE @RandPID INT

    -- Get the size of the tables that are being drawn from
    DECLARE @CountProd INT = (SELECT COUNT(*) FROM tblPRODUCT)

    -- Insert @NumProducts products into tblORDER_PRODUCT
    WHILE @NumProducts > 0
    BEGIN

        -- Get random productID to look up
        -- This assumes no wasted ids in the tables
        SET @RandPID = (SELECT (@CountProd * RAND() + 1))

        -- Look up parameters for ProductID

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
            WHERE p.ProductID = @RandPID
        )

        SET @BrandName = (
            SELECT BrandName FROM tblBRAND b 
                JOIN tblPRODUCT p on p.BrandID = b.BrandID
            WHERE p.ProductID = @RandPID
        )

        -- Get ProductID
        EXEC usp_getProductID
            @ProductName = @ProductName,
            @ProductTypeName = @ProductTypeName,
            @ProductSubTypeName = @ProductSubTypeName,
            @BrandName = @BrandName,
            @ProductID = @ProductID OUTPUT

        SET @Quantity = (SELECT (5 * RAND() + 1))

        BEGIN TRAN T1

            INSERT INTO tblORDER_PRODUCT (OrderID, ProductID, Quantity)
            VALUES (@OrderID, @ProductID, @Quantity)

            IF @@ERROR <> 0
                ROLLBACK TRAN T1
            ELSE
                COMMIT TRAN T1

        SET @NumProducts = @NumProducts - 1
        
    END

GO






