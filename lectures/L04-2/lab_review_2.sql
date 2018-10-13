USE gthay_Lab_2

SELECT * FROM [dbo].[WorkingTable]

DECLARE @ID INT -- Holds min pk
DECLARE @petName VARCHAR(50) -- name of pet matching pk
DECLARE @PetType VARCHAR(50)
DECLARE @Country VARCHAR(50)
DECLARE @Temper VARCHAR(50)
DECLARE @DOB DATE
DECLARE @Gender VARCHAR(20)

DECLARE @PT_ID INT -- variables to hold output
DECLARE @C_ID INT
DECLARE @T_ID INT
DECLARE @GenderID INT

DECLARE @Run INT = (
    SELECT COUNT(*) FROM WorkingTable
)

WHILE @Run > 0
BEGIN
    SET @ID = (SELECT MIN(PetID) FROM WorkingTable)
    SET @petName = (
        SELECT PetName FROM WorkingTable 
        WHERE PetID = @ID
    )
    SET @PetType = (
        SELECT PetType FROM WorkingTable 
        WHERE PetID = @ID
    )
    SET @Country = (
        SELECT Country FROM WorkingTable 
        WHERE PetID = @ID
    )
    SET @Temper = (
        SELECT Temperment FROM WorkingTable 
        WHERE PetID = @ID
    )
    SET @DOB = (
        SELECT DateOfBirth FROM WorkingTable 
        WHERE PetID = @ID
    )
    SET @Gender = (
        SELECT Gender FROM WorkingTable 
        WHERE PetID = @ID
    )

    IF @PetName IS NULL
    BEGIN
        PRINT "Cannot process pet with no name"
        RAISERROR('No petname, no processing',11,1)
    END


    EXEC uspGetPetTypeID
    @PetTypeName = @PetType
    @PetTypeID = @PT_ID OUTPUT

    IF @PT_ID IS NULL
    BEGIN
        PRINT 'message'
        RAISERROR('code suxs',11,1)
        RETURN
    END

    BEGIN TRAN T1
        INSERT INTO tblPet (PetName, PetTypeID, DateOfBirth, TemperamentID, Country, GenderID)
        VALUES (@pet, @PT_ID, @DOB, @T_ID, @C_ID, @GenderID)

        IF @@ERROR <> 0
            ROLLBACK TRAN T1
        ELSE
            COMMIT TRAN T1

    DELETE FROM WorkingTable WHERE PetID = @ID
    SET @Run = @Run - 1

END