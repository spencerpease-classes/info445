# INFO 445 Lecture 2-1
## 2018-01-09
======================

- Stored Procedure
    - function
    - saves time (used 1000000x times)
    - increases reliability (error checking)
    - ease of use (others can call it)
    - stored in memory (precompiled, address space, execution plan) (fast)
    - has parameters (changing details, comes from outside sp)
    - variable (internal, store looked up information)
    - used for INSERT, UPDATE, DELETE (can be simple as SELECT statement)

### Server info:
    IS-HAY03.ischool.uw.edu (not working)
    IS-HAY04.ischool.uw.edu
    IS-HAY05.ischool.uw.edu

    Login: INFO445
    PW: GoHuskies!

_Look at lecture code_

- Notes
    - don't do lookups in a transaction because locks table for everyone else
    - nested stored procedures allow parallelization
