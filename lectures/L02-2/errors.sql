SELECT * 
FROM sys.messages

-- add error message
EXEC sp_addmessage 442200, 11, 'That number is 2 high 4 me'

RAISERROR(
    442200, -- message id
    11, -- severity
    1 -- state
)

RAISERROR('It is raining', 11, 1) -- can raise errors on the fly