-- NewFix is working table
-- raw_Booklist has many NULLs 


DECLARE @Middle VARCHAR(255)
DECLARE @Last VARCHAR(255)
DECLARE @ID INT
DECLARE @Count INT

SET @Count = (SELECT COUNT(*) FROM Shark)
SET @ID = (SELECT MIN(RawID) FROM Shark)

WHILE @Count > 0
BEGIN
    SET @Middle = ()
    SET @Last = ()

    IF @Last is NULL
    BEGIN
        SET Lnanme = @Middle
        Set Mname = @Last
        WHERE RawID = @ID
    END

    SET @ID = @ID + 1
    SET @COUNT = @COUNT - 1
END

SELECT * FROM NewFix


/*
Write code to populate schema for Authors

*/

INSERT INTO [tblAuthor] ([Fname],[Lname],[MiddleName])
SELECT DISTINCT(Fname, Lname, Mname)
FROM Shark