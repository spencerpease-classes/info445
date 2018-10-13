-- Creating a new order
EXEC usp_InsertOrderAndFill 
    @OrderDate='3/8/2018', 
    @EmpFName='Marvel', 
    @EmpLName='Devora', 
    @EmpTypeName='Cashier', 
    @EmpDOB='1937-10-23', 
    @CustFName='Glen', 
    @CustLName='Bookamer', 
    @CustDOB='1978-04-09', 
    @NumProducts=5

EXEC usp_addInsertOrderAndFill_WRAPPER
    @Run = 100


-- View
SELECT * from v_mostPopBrandByType

-- Business Rule Violation
INSERT INTO tblEMPLOYEE_STORE(StartDate, EmployeeID, StoreID) 
VALUES (
    '3/8/2018', 
    (SELECT TOP 1 EmployeeID 
        FROM tblEMPLOYEE e JOIN tblEMPLOYEE_TYPE et ON et.EmployeeTypeID = e.EmployeeTypeID 
        WHERE EmployeeDOB > '4/1/1993' AND et.EmployeeTypeName = 'Manager'), 
    (SELECT TOP 1 StoreID 
        FROM tblSTORE s JOIN tblLOCATION l ON l.LocationID = s.LocationID 
        WHERE l.State = 'Idaho')
    )
