CREATE PROC spease_GetPositionTypeID

@PositionTypeNameInput varchar (50),
@PositionTypeID INT OUTPUT --or OUT

AS

SET @PositionTypeID = (
    SELECT PT.PositionTypeID FROM tblPOSITION_TYPE PT
    WHERE PT.PositionTypeName = @PositionTypeNameInput
    )

/* Handle errors */
GO

--------------------------------

DECLARE @PositionTypeID INT
EXEC spease_GetPositionTypeID 
    'Full-Time', 
    @PositionTypeID = @PositionTypeID OUTPUT

PRINT @PositionTypeID
