# INFO 445 Lecture 6-1
## 2018-02-06
======================

**Midterm Review**

- Error handling types
    - check for null
    - check for error in transaction (@@ERROR <> 0)
    - Check business rule

**4 questions in 35 minutes**

1) Explain the concept of error-handling (try and be complete: briefly explain what is it, when it happens, why it happens and how it happens). Touch on the benefits of error-handling as well.

    - anticipating errors
    - want to anticipate most common errors
    - prevents going into transaction or operation with malformed data that is guaranteed to fail
    - want to fail early, so as to minimize wasted time
    - RAISEERROR vs THROW
        - depends if you want to stop processing or not
    - benefits
        - avoid cascading rollbacks
        - increase scalability because less resources needed to manage errors


2) Normalization seeks to eliminate several different types of data anomalies; please identify what these data anomalies are and how normalization can eliminate them.

    - INSERT
        - in a poorly normalized designed, cannot change desired data without changing non relevant fields
            - ex: building relies on people, so can't have empty building
    - DELETE
        - can't remove data without losing other data
    - UPDATE
        - ex: birth date exists in 7 locations
        - updating all of them locks the database for much longer


3) Describe the differences between Online Transaction Processing (OLTP) databases and those that are supporting Data Warehousing or Online Analytical Processing (OLAP).

    **accept bullet point differences**

    - OLTP
        - write
        - short shelf life (weeks)
        - volatile
        - normalized
        - many users
        - used for operations

        - best way to collect data
        - reactionary
        - without, go out of business in weeks

    - OLAP
        - read
        - long shelf life (decades)
        - non-volatile (dead)
        - non-normalized
        - few users
        - used for decision making

        - best way to analyze data
        - predictive
        - without, unable to be competitive in future

4) Explain the difference between synchronous and asynchronous data transfer; when are each preferred?

    - synchronous
        - what: 
            - controlled
            - two way confirmation
        - preferred:
            - high availability solutions
        - two-phase commit
            1) data comes in from web
            2) send data to second server
            3) second server confirms data received
            4) both commit
        - 1000 times slower
            - use if data is more expensive than time it takes to commit
        - high availability
            - able to implement automatic fail over

    - asynchronous
        - what:
            - write as fast as possible
            - fire hose
        - preferred
            - speed more important than accuracy
            - non mission critical data

5) Describe 5 different SQL commands that are considered ‘control of flow’ language.

    - types
        - IF ELSE
        - WHILE
        - BREAK CONTINUE
        - TRY CATCH
        - BEGIN END
        - CASE
        - WAIT FOR DELAY / TIME

    - programmatically predict or control how system is going to react when conditions are uncertain

6) Compare database mirroring, log shipping and replication; when is each the preferred tool of use?

    - database mirroring
        - diagram
            - servers A and B
            - witness pays attention to data transfers
                - is authority on which server is in charge
    - log shipping
        - data sent to other servers
        - no filtering of data
        - done for internal reporting
    - replication
        - share data on need to know basis within org or with partners
        - filter what data exists on each server
            - horizontal
                - only select rows
                - ex: geographic
                    - different locations see same schema, but different rows
            - vertical
                - only select columns
        - only relevant data based on function or geographic location

7) Describe the use and benefits of an output parameter; how do these allow for more efficient processing?

    - modularity
        - able to update code, since everything is referenced from one location
            - increased efficiency
    - stored procedure
        - compiled
        - better tested
        - nested stored procedures run in parallel

8) Explain the purpose and structure of a synthetic transaction; when are they used?

    - used to test stored procedures and database schema at volume for efficiency before going into production
    - testing at  6-10 times predicted volume gives confidence that db can handle production
    - test for errors in code
    - done by calling production stored procedure with realistic-ish data, wrapped in a while loop
    - done before db goes into production
        - once in production, synthetic transaction run every 1-2 minutes to make sure process works

9) Explain the difference between the concepts of ‘high-availability’ and ‘scalability’ in regards to relational database systems: What are the terms and tools are used? How do we measure their effectiveness?

    - High availability
        - measured in uptime
            - percent available

    - High scalability
        - measured in throughput
            - simultaneous connections
            - transactions per second

10) Explain how a CASE statement improves flexibility in reporting.

    - Able to read data, set condition, and group data into conditions
    - quickly analyze data

