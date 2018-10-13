# INFO 445 Lecture 4-2
## 2018-01-25
======================


- Disaster Preparation **MT: WHAT CAUSES DISASTER, HOW TO ADRESS, WHAT TYPES**
    - types of disaster
        - natural disaster (5%)
        - outage (5%)
        - corruption and outage due to people (80%)
        - hardware failure (< 5%)
        - hack (2%)
    - must be proactive
        - maintenance
        - documentation
    - after failure, reactive
    - Service level agreement (SLA) **MT: WHAT IS SLA**
        - contract outlines payment and guarantees
        - defined maintenance and uptime
    - Backups
        - Full
            - schema
            - data
            - functions
            - logins
            - stored procedures
        - differential
            - change in data since last full backup
            - only need one diff and full to restore

- Lab Review
    - create db
    - create tbls
    - import excel
        - non normalized
    - write stored procedures
        - getIDs
    - script to "rip" through new table
        - while loops
        - counters
        -variables
