# INFO 445 Lecture 7-1
## 2018-02-13
======================

- NoSQL
    - "Not only SQL"
    - Doesn't follow acid principles
    - organizes data based on different organizational models
        - ex: relational, dimensional, hierarchical (old)
    - vs relational
        - relational focuses on always being consistent
        - if transaction completes, db guaranteed to be in consistent state
        - guaranteed accuracy
        - much slower (check fks, business rules, look at data types)
            - cannot meet same volume
    - now we have applications on a global scale where speed is priority
        - ex: voting on favorite dancer
            - single vote is immaterial, so trade speed for accurate count

- NoSQL motivations
    - **scalability**
        - able to process 100's of mills of read/write events
        - meet demands of varied workloads
            - immediate and dynamic resource management
                - add more nodes quickly
        - inherently scale out
            - can be a software solution
                - add virtual servers that can scale quickly
            - dynamically add and drop servers via software
            - systems adjust with minimal intervention
    - **cost**
        - hardware
            - cheap, commodity based hardware
                - it is interchangeable
                - specific hardware isn't required to use software
        - software
            - licenses are cheaper (not per user)
            - many solutions open source
    - **flexibility**
        - data coming into system may not be uniform
        - don't enforce a rigid structure
        - structure can change quickly and often
            - different across industry or application
            - fixed tables are not required
    - **availability**
        - distributed setup, can lose many nodes and still be able to process
        - designed to take advantage of multiple servers
        - run servers on low cost, commodity hardware
            - easy to add more

- Relational principles
    - ACID
        - accuracy more important than speed

- Non relational principles
    - BASE
        - distributed management of data
        - loose consistency
        - speed/throughput more important than accuracy
        - LOL each of these is basically the same
    - **BA: basically available**
        - structure involves multiple node
            - can lose nodes and stay operational
    - **S: Soft state**
        - able to read values that might not have been committed
        - data may or may not be accurate (to second)
    - **E: Eventually consistent**
        - abstraction layer will eventually reconcile data
        - must know sequential order of data flow
            - ex: can't do an equation out of order
    - How BASE works
        - 

- When is NoSQL preferred over regular SQL
    - cases
        - show voting
        - blog system

- what affect throughput
    - theres a delay in how data propagates through a system
        - speed of network
        - number / distance of replicas
    - number of transactions (eventually)
    - size of "transaction"

- Quorum
    - how db decides which values to return on query
    - what value is most popular across servers
    - which data is most recent
    - types
        - casual
            - database operations guaranteed in sequential order
        - read-your-writes
            - all updates we make are guaranteed in future reads of same record
            - not subject to threshold quorum
        - session
            - guarantees read-your-writes for length of session
        - monotonic read
            - query results will be consistent across multiple reads
            - results will not vary if executed several times
                - will miss charges that happen outside of session
        - monotonic write
            - most important
            - if multiple write operations are issued, they will be executed in sequential order

- Relational isolation levels
    - read-uncommitted
        - lowest level (most unstable)
        - show whatever is on disk
        - release locks
        - if you act on data that is not committed, might have to roll back later
    - read-committed
        - default
        - show only what has been committed to db
    - repeatable
    - snapshot
    - Serializability
        - highest level
        - single user only

    - trade-off of accuracy vs how many concurrent users

- NoSQL structural design
    - key-value
        - performance: high
        - scalability: high
        - Flexibility: high
        - complexity: none
        - functionality: variable (none)

    - column oriented
        - performance: high
        - scalability: high
        - Flexibility: moderate
        - complexity: low
        - functionality: minimal

        - have tables (like relational)

    - document oriented
        - performance: high
        - scalability: (variable) high
        - Flexibility: high
        - complexity: low
        - functionality: variable (low)

        - write whatever you want

    - graph
        - performance: variable
        - scalability: variable
        - Flexibility: high
        - complexity: high
        - functionality: graph theory

        - label relationships
