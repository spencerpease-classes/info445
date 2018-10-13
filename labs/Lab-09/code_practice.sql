-- Spencer Pease
-- Code Practice for Final

/*
1) (Subqueries) During spring quarter of 2016, which department had the 
most classes that were scheduled before 10:30 AM or any time on Fridays? 
(Hint: Be careful of duplicates)
*/

SELECT TOP 1 WITH TIES dept.DeptID,  dept.DeptName, COUNT(Cl.ClassID) AS 'NumberOfClasses'

FROM DEPARTMENT dept
JOIN COURSE co on co.DeptID = Dept.DeptID
JOIN CLASS cl on cl.CourseID = co.CourseID
JOIN [QUARTER] qtr on qtr.QuarterID = cl.QuarterID
JOIN SCHEDULE sch on sch.ScheduleID = cl.ScheduleID
JOIN SCHEDULE_DAY sch_dy on sch_dy.sch.ScheduleID = sch.ScheduleID
JOIN [DAY] dy on dy.DayID = sch_dy.DayID

WHERE cl.ClassYear = '2016' 
AND qtr.QuarterName = 'Spring'
AND (dy.[DayName] = 'Friday' OR sch.BeginTime < CAST('10:30' AS time))

GROUP BY dept.DeptID, dept.DeptName

ORDER BY COUNT(Cl.ClassID) desc


/*
2) Given the stored procedure usp_InsertClass, which takes in the 
following parameters, write a synthetic stored procedure to 
generate a given number classes.

    - ClassName VARCHAR(50)
    - ClassYear CHAR(4)
    - Section VARCHAR(50)
    - CollegeName VARCHAR(50)
    - DeptName VARCHAR(50)
    - CourseName VARCHAR(50)
    - QuarterName VARCHAR(50)
    - BuildingName VARCHAR(50)
    - RoomName VARCHAR(50)
    - ScheduleName VARCHAR(50)
    - FormatName VARCHAR(50)
    - BeginDate DATE

*/

CREATE PROCEDURE usp_InsertClass_WRAPPER
    
    @Run INT

    AS

    -- parameters to directly insert
    DECLARE @ClassName VARCHAR(50)
    DECLARE @ClassYear CHAR(4)
    DECLARE @Section VARCHAR(50)
    DECLARE @BeginDate DATE

    -- parameters to look up
    DECLARE @CollegeName VARCHAR(50)
    DECLARE @DeptName VARCHAR(50)
    DECLARE @CourseName VARCHAR(50)
    DECLARE @QuarterName VARCHAR(50)
    DECLARE @BuildingName VARCHAR(50)
    DECLARE @RoomName VARCHAR(50)
    DECLARE @ScheduleName VARCHAR(50)
    DECLARE @FormatName VARCHAR(50)

    -- get relevant table sizes
    DECLARE @Count_Room INT = (SELECT COUNT(*) FROM ROOM)
    DECLARE @Count_Schedule INT = (SELECT COUNT(*) FROM SCHEDULE)
    DECLARE @Count_Course INT = (SELECT COUNT(*) FROM COURSE)
    DECLARE @Count_Quarter INT  = (SELECT COUNT(*) FROM QUARTER)
    DECLARE @Count_Format INT = (SELECT COUNT(*) FROM FORMAT)

    -- Declare pks to be looked up
    DECLARE @Rand_CourseID INT
    DECLARE @Rand_QuarterID INT
    DECLARE @Rand_RoomID INT
    DECLARE @Rand_ScheduleID INT
    DECLARE @Rand_FormatID INT 

    WHILE @Run > 0
    BEGIN

        -- get random pks
        SET @Rand_CourseID = (SELECT RAND() * @Count_Course + 1)
        SET @Rand_QuarterID = (SELECT RAND() * @Count_Quarter + 1)
        SET @Rand_RoomID = (SELECT RAND() * @Count_Room + 1)
        SET @Rand_ScheduleID = (SELECT RAND() * @Count_Schedule + 1)
        SET @Rand_FormatID = (SELECT RAND() * @Count_Format + 1)

        -- look up parameters using random pks
        SET @CollegeName = (
            SELECT CollegeName FROM COLLEGE col
                JOIN DEPARTMENT d on d.CollegeID = col.CollegeID
                JOIN COURSE c on c.DeptID = d.DeptID
            WHERE c.CourseID = @Rand_CourseID)

        SET @DeptName = (
            SELECT DeptName FROM DEPARTMENT d
                JOIN COURSE c on c.DeptID = d.DeptID
            WHERE c.CourseID = @Rand_CourseID)

        SET @CourseName = (
            SELECT CourseName FROM COURSE
            WHERE CourseID = @Rand_CourseID)

        SET @QuarterName = (
            SELECT QuarterID FROM QUARTER
            WHERE QuarterID = @Rand_QuarterID)

        SET @BuildingName = (
            SELECT b.BuildingName FROM BUILDING b
                JOIN ROOM r on r.BuildingID = b.BuildingID
            WHERE r.RoomID = @Rand_RoomID)

        SET @RoomName = (
            SELECT RoomName FROM ROOM
            WHERE RoomID = @Rand_RoomID)

        SET @ScheduleName = (
            SELECT ScheduleName FROM SCHEDULE
            WHERE ScheduleID = @Rand_ScheduleID)

        SET @FormatName = (
            SELECT FormatName FROM FORMAT
            WHERE FormatID = @Rand_FormatID)


        SET @ClassName = 'Class ' + SELECT(CAST(100 * RAND() AS VARCHAR))
        SET @Section = SELECT(CHAR(CAST((90 - 65 )*RAND() + 65 AS INT)))
        SET @BeginDate = (SELECT DATEADD(day, RAND() * -3650, GETDATE()))


        EXEC usp_InsertClass
            @ClassName = @ClassName,
            @ClassYear = @ClassYear,
            @Section = @Section,
            @BeginDate = @BeginDate,
            @CollegeName = @CollegeName,
            @DeptName = @DeptName,
            @CourseName = @CourseName,
            @QuarterName = @QuarterName,
            @BuildingName = @BuildingName,
            @RoomName = @RoomName,
            @ScheduleName = @ScheduleName,
            @FormatName = @FormatName

        SET @Run = @Run -1
    END
GO


/*
3) Create a business rule to enforce this business constraint: 
No classes can have more than 10 students registered nor more 
than 1 instructor who have a special need of "hard of hearing" 
in a room that has the amenity of "natural sound system"
*/

CREATE FUNCTION fn_classLimitHearing()
    
RETURNS INT

AS
BEGIN 

DECLARE @Ret INT = 0

IF EXISTS (
    SELECT cl.ClassID
    FROM CLASS c 
    JOIN CLASS_LIST cl on cl.ClassID = c.ClassID
    JOIN PERSON_ROLE pr on pr.PersonRoleID = cl.PersonRoleID
    JOIN ROLE r on r.RoleID = pr.RoleID
    JOIN PERSON p on p.PersonID = pr.RoleID
    JOIN STUDENT_SPECIAL_NEED ssn on ssn.PersonID = p.PersonID
    JOIN SPECIAL_NEED sn on sn.SpecialNeedID = ssn.SpecialNeedID
    JOIN ROOM r on r.RoomID = c.RoomID
    JOIN ROOM_AMENITY ra on ra.RoomID = r.RoomID
    JOIN AMENTIY a on a.AmenityID = ra.AmenityID

    WHERE sn.SpecialNeedName = 'Hard of Hearing'
    AND r.RoleName = 'Student'
    AND a.AmenityName = 'Natural Sound System'

    GROUP BY cl.ClassID 
    HAVING COUNT(*) > 10

    OR cl.ClassID IN (
        SELECT cl.ClassID, COUNT(*)
        FROM CLASS c 
        JOIN CLASS_LIST cl on cl.ClassID = c.ClassID
        JOIN PERSON_ROLE pr on pr.PersonRoleID = cl.PersonRoleID
        JOIN ROLE r on r.RoleID = pr.RoleID
        JOIN PERSON p on p.PersonID = pr.RoleID
        JOIN STUDENT_SPECIAL_NEED ssn on ssn.PersonID = p.PersonID
        JOIN SPECIAL_NEED sn on sn.SpecialNeedID = ssn.SpecialNeedID
        JOIN ROOM r on r.RoomID = c.RoomID
        JOIN ROOM_AMENITY ra on ra.RoomID = r.RoomID
        JOIN AMENTIY a on a.AmenityID = ra.AmenityID

        WHERE sn.SpecialNeedName = 'Hard of Hearing'
        AND r.RoleName = 'Instructor'
        AND a.AmenityName = 'Natural Sound System'

        GROUP BY pr.ClassID 
        HAVING COUNT(*) > 1
    )
)

    SET @Ret = 1 

RETURN @Ret
END

ALTER TABLE [CLASS]
ADD CONSTRAINT classLimitHearing
CHECK (dbo.fn_classLimitHearing() = 0)
