/* 
CREATE DATABASE OTTER_spease
*/

USE OTTER_spease
GO

/* Create db tables */

CREATE TABLE tblCUSTOMER_TYPE (
    CustomerTypeID INT IDENTITY(1,1) primary key not null,
    CustomerTypeName varchar(50) not null,
    CustomerTypeDescr varchar(50) not null)

GO
CREATE TABLE tblCUSTOMER (
    CustomerID INT IDENTITY(1,1) primary key not null,
    CustFname varchar(50) not null,
    CustLname varchar(50) not null,
    CustBirthDate Date not null,
    CustomerTypeID INT FOREIGN KEY REFERENCES tblCUSTOMER_TYPE (CustomerTypeID) not null)

GO
CREATE TABLE tblORDER (
    OrderID INT IDENTITY(1,1) primary key not null,
    ORderDate DATE DEFAULT GetDate() not null,
    CustomerID INT FOREIGN KEY REFERENCES tblCUSTOMER (CustomerID) not null)

GO
CREATE TABLE tblPRODUCT (
    ProductID INT IDENTITY(1,1) primary key not null,
    ProductName varchar(50) not null,
    ProductPrice numeric not null,
    ProductDescr varchar(50) not null)

GO
CREATE TABLE tblORDER_PRODUCT (
    OrderProdID INT IDENTITY(1,1) primary key not null,
    OrderID INT FOREIGN KEY REFERENCES tblORDER (OrderID) not null,
    ProductID INT not null,
    Quantity INT not null)

GO 
-- Another way of adding primary keys
-- usefull if key is based on multiple columns
CREATE TABLE tblPRODUCT_TYPE (
    ProductTypeID INT IDENTITY(1,1) not null,
    ProductTypeName varchar(30) not null,
    PRoductTypeDesc varchar(50) not null,
    PRIMARY KEY (ProductTypeID)
    )

-- Other ways of adding foreign keys
ALTER TABLE tblPRODUCT
ADD ProductTypeID INT
FOREIGN KEY REFERENCES tblPRODUCT_TYPE (ProductTypeID)

ALTER TABLE tblORDER_PRODUCT
ADD CONSTRAINT FK_tblORDER_PRODUCT_ProductID
FOREIGN KEY (ProductID) REFERENCES tblPRODUCT (ProductID)
