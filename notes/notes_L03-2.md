# INFO 445 Lecture 3-1
## 2018-01-18
======================

- High availability
    - automatic fail over
    - trade speed for data integrity
    - synchronous transactions
        - process
            - A writes tran
            - A transfers write to B
            - B sends confirmation to A
            - Both are committed
        - If no confirmation, tran fails
    - vs asynchronous
        - process
            - A writes tran
            - A commits tran
            - A sends B tran to write
    - used for mission critical data
    - used for customer facing data
    - forms
        - mirroring
            - servers A and B
            - Also have a "witness" on network that monitors "heartbeat" of servers
            - if witness dectects A failure, makes B authority
            - db can fail independently
                - 1 second fail over
            - ~2005 tech
        - clustering
            - ~1970s tech
            - Servers A and B would write to same set of disks
            - One is active, one is passive
            - servers must be in same room
            - expensive (one server $80,000 and you need two)
            - takes about 10 min to fail over
                - whole server must fail

- High scalability
    - scale up
        - make node more powerful
    - scale out
        - add more nodes
    - often asynchronous
    - one centralized set of data
    - data replication allows specialized data to exist at a location
        - via filtering by columns or rows
        - ex boeing
    - tools
        - Replication
            - allows for filtering
                - geographic and function 
            - for scaling out
        - Read-Points
            - conflict between read and write activity (locking)
            - create read-only copy of server for queries (reporting server) 
            - focus main server on writing only
            - implementation
                - delta: change in data (new or deletes)
                    - found in transaction log
                - log shipping
                    - take backup of transaction log and copy to reporting server
                        - asynchronous (multiple reporting servers)
                    - every to 10 minutes or so
                    - not considered fault tolerent today


- Write-ahead-logging
    - record of all transactions
    - use to check if discrepancy between transactions and actual commits
        - if there is, revert db to last checkpoint
    - part of durability in ACID principles

