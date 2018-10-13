# INFO 445 Lecture 2-2
## 2018-01-11
======================

- ACID principles
    - protect data from other data
    - Atomicity
    - Consistency
    - Isolation
        - only one person changing db at a time
    - Durability
        - write ahead logging ???

- Control of flow
    - write code that can interact with data/db and maintain control
    - write code to evaluate current state and make decisions
    - makes code more robust
    - prevent actions from happening that reduce profitability

    - `if else`, `begin end`, `while`, `break | continue`, `waitfor`, `try`, `catch`
    - while loops
        - typically used during maintenance and analysis

- Error handling
    - goal is to anticipate failures
    - "fail early"
    - able to create log messages
    - SQL Server messages
        - message number
            - 
        - severity level
        - state
        - procedure
            - Object name where error occured
        - line
            - where is error in code
        - message 

- Nested transactions
    - second transaction starts before first completes
    - nothing actually commited until all record success
