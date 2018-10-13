# INFO 445 Lecture 10-1
## 2018-03-06
=======================

- what
- how
- why
- when
- impact

1) Describe the differences between full, differential and transaction log back-ups and provide an example of a disaster recovery strategy that uses all three types of backups.

    - command to create record of db
    - move data around
    - Give example (maybe)
    - strategy
        - must understand environment
        - look at dispersion of 
        - for typical e-commerce
            - full every week
                - not constant because takes up space
            - diff every  day
            - log 1 every 15 min
                - space and speed considerations
    - why want to take a backup
    - types
        - full is everything
        - differential is delta since full backup
        - transaction log is delta since last backup
            - can be differential or other log

    - what: quickly explain what a backup is/how they are different
        - login, security measurements
    - how: show code perhaps
    - impact: show purpose of best practice, or what happens in absence of backups
        - go out of business if lose data
        - what is ability to absorb data loss
    - when: show difference between volume of transactions and frequency of backups
    - why: impact of absence

2) Describe the steps presented in lecture in performing proper database troubleshooting.

    - what
        - when things are broken / not running well, what do we do?
        - SLA
        - Protocols, procedures, policies agreed upon w/ customer
    - how
        - communication -> no rumors, be factual
        - validate -> false alarm
        - communicate -> yes/no for being real
        - define scope -> delegate responsibilities
        - define recent changes to env -> maintenance performed, schema changed, large imports or deletes
        - communicate -> what have we learned
        - compare to historical baselines
        - Always writing notes -> fix problem in the future -> knowledge base
    - why
        - get better over time
        - optimize env
        - reduce errors/risk/data loss
    - when
        - maintenance is ongoing always
        - fix things at any time -> goal is to get better over time
    - impact
        - data loss / crappy service for customers
        - jeopardize company

3) Describe the differences between Online Transaction Processing (OLTP) databases and those that are supporting Data Warehousing or Online Analytical Processing (OLAP).

    - what
        - OLTP
            - rigid, write centric, reactive, interrogative, volatile, normalized, many small bits (transactions), many users (1 mil consumers), short shelf life (hours to weeks)
        - OLAP
            - read centric, dead, denormalized, few very large updates (loading of DW), few users (100's of strategic planners/analysts, internal), long shelf life (decades)
    - how
    - why
    - when
        - OLTP
            - when have strict requirements
            - reactionary, immediate operations
            - all companies need paper trail
        - OLAP
            - proactive, strategic marketing
            - used by mature companies -> better understanding of market / business space
    - impact
        - goal is to determine if people know difference between these structures

4) Describe the aspects of a database environment that are considered critical for a database administrator to have deep knowledge on.

    - what
        - know transactions, objects, data flow, customers (internal / external), hardware / platform, skills of others (and motivations)
    - how
    - why
        - customers decide how successful we are, decide priorities, understand tangible effects
        - transactions tell when busy and when to do maintenance
        - data flow shows points of potential optimization
        - hardware affects performance, old hardware is a risk
        - objects 
        - skills allow us to match people to right task, work together effectively
    - when
    - impact
        - if compete with teammates, look for opportunities to lie

5) Describe the preparations a database administrator must take to reduce the risk of data loss.

    - what
        - develop patterns for ongoing maintenance using current methods
        - what is meant by data loss and risk 
        - must know env
        - coordinate with other teams
    - how
    - why
    - when
    - impact

6) **NOT ON EXAM** Name four (**three**) Dynamic Management Views (DMVs) presented in lecture and describe their use.

    - what
        - list object, say what it does
    - how
    - why
    - when
    - impact

7) **NOT ON EXAM** Explain what is meant by 'Fault-Tolerance' and identify three system component examples.

    - what
        - cite history
            - just learning how to build hardware in 50's to 90's
            - high failure
            - result -> fault tolerance everywhere
        - CPU -> multi channel (SMP)
        - RAM -> multi channel (DIMMS vs SIMMS)
        - RAID -> redundancy at hard drive level
        - Power supply -> dual power
        - battery backup -> on everything with cache
        - db mirroring
    - how
    - why
        - systems will fail
    - when
    - impact

8) Describe the differences between the various types of indexes presented during lecture and identify why each is preferred in certain read or write scenarios.

    - what
        - clustered
        - non-clustered
    - how
        - write out balanced Tree diagram
        - circle difference
        - hops (root, branch, leaf)
    - why
         - Clustered: write sequential
         - non-clustered: anything on where clause
    - when
        - read 
        - write (clustered, on pk or time stamp)
    - impact
        - ability to get start and end, just pull everything in between
            - range search
        - hurt write performance (non-clustered has greater impact)


9) Describe 5 different SQL commands that are considered ‘control of flow’ language.

    - what
        - IF ELSE, BEGIN END, CASE, WHILE, WAITFOR DELAY | TIME
    - how
        - give example
            - wrappers
    - why
        - code logically downstream when conditions change
        - code pro-actively, respond programmatically
        - less troubleshooting
    - when
        - don't know conditions of data
        - need to control flow
    - impact

10) Compare database mirroring, log shipping and replication; when is each the preferred tool of use?

    - what
        - mirroring
            - high availability
            - sync
        - replication
            - scalability
            - more to do with
            - async
            - filtered
            - external
        log shipping
            - scalability
            - read only
            - async
            - work on own copy of data
            - internal
    - how
        - high availability
        - high scalability
    - why
    - when
        - replication
            - wide business range
            - external
            - send data to users
    - impact

11) (**maybe not, depending on lecture**) Describe the memory caching algorithm implemented by databases to improve performance.

    - what
        - LRU: least recently used
            - throws out data that was last used longest ago
        - MRU: most recently used
    - how
    - why
    - when
    - impact

12) Explain the key characteristics of a database maintenance plan as presented in lecture.

    - what
        - result of knowing env
            - hardware, customers, objects, data flow, skills
        - geared towards reducing risk to data
        - documented
        - practiced
        - measured for effectiveness
    - how
    - why
        - documented -> easier to on board new people, easier to introduce to new env
        - practice -> only way to get good is to do tasks frequently
        - measure -> why do anything that doesn't improve operations
    - when
    - impact

13) Define the different data warehouse design structures:  star schema, snowflake schema,'star flake' schema, fact table, dimension table in addition to a ‘measure’. 

    - what
        - what does a dimensional model look like
        - dimension
            - who, what, where, when
        - fact
            - most granular event including dimensions
            - includes measurements
                - always numeric columns
        - types
            - snowflake: is normalized
            - starflake: part normalized, part normalized
    - how
        - diagram
        - what a denormalized schema looks like
    - why
    - when
    - impact

14) (**NOT ON EXAM**) Explain what an execution plan is and what an administrator learns from one to improve performance.

    - what
    - how
    - why
    - when
    - impact

15) (**NOT ON EXAM**) Explain the differences between an index seek and index scan and address when each is preferred.

    - what
        - seek
            - engaging the index
            - 10,000+ rows in table guaranteed preferred
            - go address we are aware of
        - scan
            - don't wan to force seek if small number of rows ( less than 50)
    - how
    - why
    - when
    - impact

16) Compare the differences between RAID 0, RAID 1, RAID 5 and RAID 0 + 1 or RAID 'Ten'

    - what
        - RAID 0
            - striping
            - parallel reads and writes
            - bad fault tolerance
        - RAID 1
            - mirroring
            - fault tolerance
        - RAID 5
            - parity with striping
            - preferred when disks are expensive
            - no longer used
                - twice as many writes
        - RAID 0+1
            - full striping and mirroring
            - first stripe, then mirror
            - RAID 1+0 is different, much rarer
    - how
        - diagram
    - why
    - when
    - impact

17) Explain the differences between a Data Warehouse and a Data Mart.

    - what
        - warehouse -> enterprise wide
        - mart -> departmental level
    - how
        - top-down -> look at whole business (warehouse)
            - ask what questions want answered, get data
        - bottom-up -> start with department needs (mart)
            - look at data, ask questions
    - why
        - mart -> less risk, easier to build, cheaper, faster
            - not as wide in scope, not able to answer enterprise level Q's
        - warehouse -> larger
    - when
    - impact

18) Compare asynchronous communications versus synchronous; which is preferred to reduce risk of data loss? 

    - what
        - async -> fire and forget
    - how
    - why
    - when
        - accuracy vs speed
        - sync for minimizing data loss
    - impact

19) Name four monitoring tools presented in lecture and identify the best-use of each. 

    - what
        - SQL Server profiler
        - activity monitor
        - system monitor (perfmon)
        - Dynamic management views (DMVs)
        - SQL (scripts)
        - task manager
    - how
    - why
        - monitor constantly to know baseline
    - when
        - profiler -> low level, intended to find details in db (who connected, num queries)
        - activity monitor -> high level, quickly observe anything obvious
        - system monitor -> low level, tool of operating system and hardware activity
        - Dynamic management views (DMVs) -> low or high level, current state, depending on queries
        - SQL (scripts) -> low or high level
        - task manager -> high level for hardware resources / services
    - impact

20) Explain the differences between a page fault, page split, fill factor and checkpoint.

    - what
        - page
            - smallest unit of storage of a database
        - extent
            - smallest unit of storage operated on by an OS
            - 8 contiguous pages
        - page fault
            - when page is searched for in memory but not found
                - soft: still in memory, just wrong location
                - hard: not in memory, must go to disk
        - page split
            - When a page is full, move half of data to new page
        - fill factor
            - how data is established on pages when first created
        - checkpoint
            - writing data from memory to disk
    - how
        - fill factor
            - OLTP, 70% full
            - OLAP, 100%, know there are no page splits
            - small enough to add additional data, large enough to minimize pages
        - checkpoint
            - done when idle, (approx 1-2 minute)
    - why
    - when
    - impact
        - if have significant number page faults, want to allocate more memory
            - slows down processing
        - page split
            - needed to keep processing data
