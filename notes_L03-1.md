# INFO 445 Lecture 3-1
## 2018-01-16
======================

- Two Schools of error handling
    - old school (RAISERROR)
        - does not terminate session
        - must also include `RETURN` after `RAISERROR` to terminate
        - can write to disk
    - new school (THROW)
        - automatically terminates session
        - ex: `THROW @ProdID cannot be NULL;`
            - must end with `;`
        - quick, easy, decentralized, fast, easy to use anywhere
        - cannot write to disk
            - must use other system functions to get info and write
- error handling
    - anticipate mistakes
    - must understand what will cause a transaction to fail
    - look to make sure those conditions do not exist
    - used for communication
    - fail early to avoid extra work
        - avoid affecting other transactions
            - cascading rollbacks

- Implementing a cart (processing an order)
    - challenges
        - keep OrderID the same across many rows in tblORDER_PRODUCT
        - Customer can add and drop item many times
    - Create tblCART with many to many relationship with tblCUSTOMER and tblPRODUCT
        - also include Quantity
    - When placing an order, move cart to tmp tbl and summarize by item to get total quantity for line item
    - don't want 3 lines with same product

- computed column always takes PK as parameter

- High availability vs scalability
    - high availability
        - ability to process a transaction
        - continuous use of mission-critical data
        - measurements
            - looks alive
                - connect to server
            - is alive
                - push through a synthetic transaction
                - called tracer
                - done every few minutes (or seconds)
        - uptime / downtime vs data loss
            - uptime measured in % (hrs downtime/year)
            - downtime (not able to process)
            - data loss (don't know about orders)
            - high availability does not rule out data loss

    - scalability
        - able to process certain number of transactions 
        - scale up
            - add hardware to node 
        - scale out
            - add more nodes
            - spread data and workload among them
        - measured in throughput 
            - ability to add more users / work on application
            - transactions per second or concurrent users

    - - synchronous vs asynchronous
            - sync
                - communications are serial
                    - transactions wait for commit confirmation
                - better for data integrity
            - async
                - communications are parallel
                    - transactions don't wait for commit confirmation
                - much faster
