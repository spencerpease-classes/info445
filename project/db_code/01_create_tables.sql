
/*
 Table Definitions
*/

-- Entities section

CREATE TABLE [tblCUSTOMER] (
  [CustomerID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [CustomerFName] Varchar(40) NOT NULL,
  [CustomerLName] Varchar(40) NOT NULL,
  [CustomerDOB] DATE,
);

CREATE TABLE [tblSUPPLIER] (
  [SupplierID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [SupplierName] Varchar(40) NOT NULL,
);

CREATE TABLE [tblEMPLOYEE_TYPE] (
  [EmployeeTypeID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [EmployeeTypeName] VarChar(40) NOT NULL,
  [EmployeeTypeDesc] Varchar(200) NULL
);

CREATE TABLE [tblEMPLOYEE] (
  [EmployeeID] INT IDENTITY(1,1) PRIMARY KEY  NOT NULL,
  [EmployeeTypeID] INT FOREIGN KEY REFERENCES [tblEMPLOYEE_TYPE] (EmployeeTypeID) NOT NULL,
  [EmployeeFName] VarChar(40) NOT NULL,
  [EmployeeLName] VarChar(40) NOT NULL,
  [EmployeeDOB] DATE NOT NULL
);


-- Location Section

CREATE TABLE [tblLOCATION_TYPE] (
  [LocationTypeID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [LocationTypeName] Varchar(40) NOT NULL,
  [LocationTypeDesc] VARCHAR(200)
);

CREATE TABLE [tblLOCATION] (
  [LocationID] INT IDENTITY(1,1)  PRIMARY KEY NOT NULL,
  [StreetAddress] Varchar(120) NOT NULL,
  [City] Varchar(75) NOT NULL,
  [State] varchar(25) NOT NULL,
  [Zip] varchar(25) NOT NULL,
  [LocationTypeID] INT FOREIGN KEY REFERENCES [tblLocation_Type] (LocationTypeID) NOT NULL
);

CREATE TABLE [tblEMPLOYEE_LOCATION] (
  [EmployeeLoationID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [EmployeeID] INT FOREIGN KEY REFERENCES [tblEmployee] (EmployeeID) NOT NULL,
  [LocationID] INT FOREIGN KEY REFERENCES [tblLocation] (LocationID) NOT NULL
);

CREATE TABLE [tblSUPPLIER_LOCATION] (
  [SupplierLocationID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [SupplierID] INT FOREIGN KEY REFERENCES [tblSupplier] (SupplierID) NOT NULL,
  [LocationID] INT FOREIGN KEY REFERENCES [tblLocation] (LocationID) NOT NULL
);

CREATE TABLE [tblCUSTOMER_LOCATION] (
  [CustomerLocationID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [CustomerID] INT FOREIGN KEY REFERENCES [tblCustomer] (CustomerID) NOT NULL,
  [LocationID] INT FOREIGN KEY REFERENCES [tblLocation] (LocationID) NOT NULL
);


-- Store Section

CREATE TABLE [tblSTORE] (
  [StoreID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [LocationID] INT FOREIGN KEY REFERENCES [tblLocation] (LocationID) NOT NULL,
  [StoreName] VarChar(40) NOT NULL,
);

CREATE TABLE [tblEMPLOYEE_STORE] (
  [EmployeeStoreID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [StartDate] DATE NOT NULL,
  [EndDate] DATE,
  [EmployeeID] INT FOREIGN KEY REFERENCES [tblEmployee] (EmployeeID) NOT NULL,
  [StoreID] INT FOREIGN KEY REFERENCES [tblStore] (StoreID) NOT NULL
);


-- Product Section

CREATE TABLE [tblPRODUCT_TYPE] (
  [ProductTypeID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [ProductTypeName] Varchar(40) NOT NULL,
  [ProductTypeDesc] Varchar(200)
);

CREATE TABLE [tblPRODUCT_SUBTYPE] (
  [ProductSubTypeID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [ProductTypeID] INT FOREIGN KEY REFERENCES [tblPRODUCT_TYPE] (ProductTypeID) NOT NULL,
  [ProductSubTypeName] VARCHAR (40) NOT NULL,
  [ProductSubTypeDesc] VARCHAR(200)
)

CREATE TABLE [tblBRAND] (
  [BrandID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [BrandName] VarChar(40) NOT NULL,
  [BrandDesc] VarChar(255)
);

CREATE TABLE [tblPRODUCT] (
  [ProductID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [ProductSubTypeID] INT FOREIGN KEY REFERENCES [tblPRODUCT_SUBTYPE] (ProductSubTypeID) NOT NULL,
  [BrandID] INT FOREIGN KEY REFERENCES [tblBRAND] (BrandID) NOT NULL,
  [Price] NUMERIC(6,2) NOT NULL,
  [ProductName] Varchar(150) NOT NULL,
  [ProductDesc] Varchar(255)
);

CREATE TABLE [tblPRODUCT_SUPPLIER] (
  [ProductSupplierID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [SupplierID] INT FOREIGN KEY REFERENCES [tblSupplier] (SupplierID) NOT NULL,
  [ProductID] INT FOREIGN KEY REFERENCES [tblProduct] (ProductID) NOT NULL
);


-- Ordering section

CREATE TABLE [tblORDER] (
  [OrderID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [OrderDate] Datetime NOT NULL,
  [EmployeeID] INT FOREIGN KEY REFERENCES [tblEmployee] (EmployeeID) NOT NULL,
  [CustomerID] INT FOREIGN KEY REFERENCES [tblCustomer] (CustomerID) NOT NULL
);

CREATE TABLE [tblCART] (
  [CartID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [Quantity] INT NOT NULL,
  [DateAdded] DATE NOT NULL,
  [CustomerID] INT FOREIGN KEY REFERENCES [tblCustomer] (CustomerID) NOT NULL,
  [ProductID] INT FOREIGN KEY REFERENCES [tblProduct] (ProductID) NOT NULL
);

CREATE TABLE [tblORDER_PRODUCT] (
  [OrderProductID] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  [Quantity] INT NOT NULL,
  [ProductID] INT FOREIGN KEY REFERENCES [tblProduct] (ProductID) NOT NULL,
  [OrderID] INT FOREIGN KEY REFERENCES [tblOrder] (OrderID) NOT NULL
);

