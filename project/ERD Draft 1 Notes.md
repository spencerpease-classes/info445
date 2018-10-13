ERD Draft 1 Notes
=================

- Implement a cart
- Remove inventory
    - It should be tracked via views and queries
- Order shouldn't be connected to store
    - creates a referential loop
    - information can be found by going through employee
    - Greg mentioned that we could leave it for now if we wanted to see the performance impact
- add location for employee
