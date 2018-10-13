# INFO 445 Lecture 4-1
## 2018-01-23
======================

- Disaster Recovery
    - Disasters
        - unable to do mission critical business
        - can be from design flaw or server failure, power outage
    - Develop 'Service-Level Agreement'
        - contract with customers
        - defines acceptable downtime or data loss
        - specifics of system availability and support
    - Recovery
        - address disaster before, during, or after
        - be prepared
            - must understand what is critical to mission of organization
                - production environment (not dev)
                    - go slow, take time
                    - must be able to recover to point-in-time
                        - full recovery model
                        - transaction backup logs required
                    - candidate for _High availability_ solution
            - non mission critical data
                - typically dev or test environment
                - point in time not required
                - simple recovery model

- Database backup
    - Full
        - complete data, schema
    - differential (delta)
        - changes since last full backup (only ever need one differential)
        - useless if lose full backup
    - log
        - delta since last backup of any time
- Why backup
    - disaster recovery
    - use in test and dev
