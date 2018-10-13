-- Spencer Pease
-- Midterm practice extra credit

/*
Write a stored procedure to populate the CLASS table. 
You must use an explicit transaction and three examples of error handling. 
Nested procedures are optional.
*/


CREATE PROCEDURE usp_populateClass

    @ClassName varchar(50),
    @ClassYear Date,
    @Section varchar(5),
    @CourseName varchar(50),
    @Quarter varchar(10),
    @RoomName varchar(50),
    @BuildingName varchar(50),
    @ScheduleName varchar(50),
    @FormatName varchar(50),
    @BeginDate Date

    AS

    -- business rule to not allow classes in Condon during the summer
    IF (@BuildingName = 'Condon' AND @QUARTER = 'Summer')
    BEGIN
        THROW('Why would you want to take a class in Condon over the Summer?')
    END

    -- parameters for ids

    DECLARE @CourseID INT
    DECLARE @QuarterID INT
    DECLARE @RoomID INT
    DECLARE @ScheduleID INT
    DECLARE @FormatID INT

    -- Look up ids

    SET @CourseID = (
        SELECT CourseID FROM [COURSE]
        WHERE CourseName = @CourseName
    )

    -- Null error handling
    IF @CourseID IS Null
    BEGIN
        THROW('Could not find a course ID for the given course name')
    END

    SET @QuarterID = (
        SELECT QuarterID FROM [QUARTER]
        WHERE QuarterName = @Quarter
    )

    SET @RoomID = (
        SELECT RoomID FROM [ROOM] r
            JOIN [BUILDING] b on r.BuilingID = b.BuilingID
        WHERE b.BuildingName = @BuildingName
        AND r.RoomName = @RoomName
    )

    SET @ScheduleID = (
        SELECT ScheduleID FROM [SCHEDULE]
        WHERE ScheduleName = @ScheduleName
    )

    SET @FormatID = (
        SELECT FormatID FROM [FORMAT]
        WHERE FormatName = @FormatName
    )

    -- Insert into CLASS table
    BEGIN TRAN T1

        INSERT INTO [CLASS] (ClassName, ClassYear, Section, CourseID, QuarterID, RoomID, ScheduleID, FormatID, BeginDate)
        VALUES (@ClassName, @ClassYear, @Section, @CourseID, @QuarterID, @RoomID, @ScheduleID, @FormatID, @BeginDate)

        IF @@ERROR <> 0
            COMMIT TRAN T1
        ELSE
            ROLLBACK TRAN T1

    END


/*
Write code for the business rule: 
If the class year is 2020, students cannot register for more than 
two 400-level info courses.
*/


CREATE FUNCTION  fn_regRestriction()

RETURNS INT

AS
BEGIN

DECLARE @ret = 0

IF EXISTS (
    SELECT * FROM [CLASS_LIST] clli
        JOIN [CLASS] cl on clli.ClassID = cl.ClassID
        JOIN [COURSE] co on cl.CourseID = co.CourseID
        JOIN [DEPARTMENT] de on co.DeptID = de.DeptID

    WHERE de.DeptName = 'INFO'
    AND co.CourseName = '400'
    AND cl.ClassYear = '2020'

    GROUP BY clli.PersonRoleID
    HAVING COUNT(clli.ClassListID) > 2
)

    SET @ret = 1

RETURN @ret

END

ALTER TABLE [ClassYear]
ADD CONSTRAINT  regRestriction
CHECK (dbo.fn_regRestriction() = 0)


/*
Write code to create the following report in a view: 
Return the list of all colleges and the number of classes they have held on 
West Campus year-to-date. Minimum of 2 classes.
*/

CREATE VIEW v_westCampusColleges

SELECT col.CollegeName as 'College', COUNT(cla.ClassID) as 'Number of classes' FROM [COLLEGE] col
    JOIN [DEPARTMENT] dep on dep.CollegeID = col.CollegeID
    JOIN [COUSRE] cou on cou.DeptID = dep.DeptID
    JOIN [CLASS] cla on cla.CourseID = cou.CourseID
    JOIN [ROOM] roo on roo.RoomID = cla.RoomID
    JOIN [BUILDING] bld on bld.BuilingID = roo.BuilingID
    JOIN [LOCATION] loc on loc.LoactionID = bld.BuilingID

WHERE loc.LocationName = 'West Campus'

GROUP BY col.CollegeID
HAVING COUNT(cla.ClassID) >= 2
