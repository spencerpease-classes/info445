# INFO 445 Lecture 7-2
## 2018-02-15
======================

- NoSQL motivations
    - Cost
        - open source
        - commodity hardware
    - flexibility
        - no rigid structure, so you can add more data easier
        - take anything
    - scalability
        - hundreds of nodes you can write to
        - easy to add nodes
    - availability
        - by design, multiple nodes
        - distributed database
        - can lose some and sill be available

- NoSQL BASE
    - Basically avilable
        - distributed nodes means you always have a means to access database
    - soft state
        - data always in flux
    - eventually consistent
        - data takes time to propagate across all nodes
        - may read different values from different nodes

- Business contexts for NoSQL
    - want to prioritize speed over accuracy
    - ex: game show text to vote system

- 4 types of NoSQL systems
    - have structural differences
    - column oriented
        - group of values come in at same time
            - ex: fname, lname, dob, adress
    - key-value
        - take values and assign keys
    - document oriented
        - each entity has a "blank document" to write to
        - not all documents have same information
    - graph
        - analyze relationship
        - label relationship between opjects
        - contextual relationships
        - ex: facebook or linkedin friend network

- Data warehousing 
    - Star schema
        - non normalized
        - good for
            - speed of queries
                - data is redundant
                - don't have to calculate values
    - Snowflake schema
        - dimensions are normalized
        - good for
            - cheaper
                - data not available, too expensive to get it
                - ex: want data at city level, only have state
            - limited storage space

    - dimensions
        - who, what, when, where
            - not limited to 4 (no more than 8)
        - assign new primary keys
            - don't want to confuse with transactional key, which also might be in the table
            - "dim_pk..."
        - changing dimensions
            - only changes when how we define object changes
                - ex: changing definitions of store types
            - options
                - overwrite old values
                    - lose history
                    - 18%
                - add new row with new type
                    - 80%
                    - takes up a lot of space
                - add new column to all existing rows with new store type
                    - 2%
                    - invasive and difficult
    - fact table
        - ex: scan of an item at Starbucks
            - measures
                - how long waiting in line
        - pk is composite of all fks
        - other columns are numerical values
            - ex: num of steps to get coffee
            - ex: cost and price (cost to make and price sold for)
            - ex: tax
            - ex: weight
            - ex: items year to date



