# INFO 445 Lecture 9-2
## 2018-03-01
======================

- Presentations
    - draft and final ERD
        - why were changes made
    - show some data objects
        - stored procedures
        - views
    - maybe enter data

- Monitoring
    - done always
        - how you know you have a problem
        - want to know what normal is
    - allows you to see trends

- RAID
    - Redundant Array of Independent Disk
    - db adversely affected by bad hardware
    - allow for redundancy in data
    - separate disks for activities
    - types
        - RAID 0
            - striping
            - parallel reads and writes
            - speed
            - no fault tolerance
        - RAID 1
            - mirroring
            - parallel reads
            - data written to two groups in serial
        - RAID 5
            - striping plus parity
            - not used anymore
                - disks used to be expensive
            - has additional parity write
                - slower
        - RAID 0+1
            - mirrored striping
            - downside is price
                - must buy twice desired storage

- Indexes
    - clustered
        - ideal in write-centric environment
        - pair clustered index w/ primary key 
    - non clustered
        - operates as balanced tree
            - root, branch (intermediate), node (leaf)
            - tree doesn't get deeper, just wider
        - leaf node is pointer into clustered index

- Troubleshooting
    - skills
        - patience
        - confidence
            - tell people what you know
        - ability to deduce and infer
        - think under pressure
        - ability to listen
        - ability to communicate effectively
        - ability to delegate and trust
    - rules
        - be prepared
            - know environment
            - able to leverage multiple tools
            - aware of co-worker skills
        - ask questions
            - take notes
            - ask for help when appropriate
            - no cowboys in production
    - know db environment
    - steps
        1) communicate
            - notify chain of possible performance issues
            - be factual but relatively cryptic/vague
            - give eta for next update
                - 10 minutes for first update
                - every 30 minutes after until resolved
        2) validate issue
            - until validated issue is only a rumor
            - validate health of a database
                - blocked spids -> activity monitor
                - physical resources (CPU, memory, i/o) -> task manager
                - check SQL error logs and server system logs
            - execute scripts to verify user experience
                - should already be written
            - delegate tasks to others to assist
        3) communicate again
            - what you know
            - explain what you're doing
            - ask others to verify
        4) define scope of issue
            - what applications are not performing well
            - what are exact symptoms
            - when did this begin
            - what tables are impacted by database
            - which objects touch these tables
            - what jobs/queries are currently running
            - any open transactions -> `DBCC opentran`
        5) define recent changes to environment
            - what maintenance tasks in previous 24 hours
            - any schema changes or deployments
                - dropped indexes, file groups or partitions
            - any deletes or significant data archiving
            - any import of large amount of data
                run update statistics against affected tables
        6) compare to historical baselines
            - where is the system behaving poorly
                - if not obvious, look at middle-tier or app layer
                - all web-boxes performing well
            - send through synthetic transactions
            - want to have baseline (why monitoring is done)
        - be prepared
            - know environment
            - have baselines available
            - know symptoms of each resource bottleneck
            - know various tools for measuring performance
            - know where to get help
        - learn
            - document issue
                - what were the symptoms
                - what resolution tactics were tried
                - what resolutions were successful
            - able to recognize patterns
            - practice
            - read industry notes/blogs
    - Creating a baseline
        - defines what normal is
        - perfmon
            - creates a log of captured measurements 2-3 times a minute
        - standard counters
            - become familiar with ones important to environment
        - identify trends
        - makes technicians pay attention


