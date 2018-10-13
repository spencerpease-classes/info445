# INFO 445 Lecture 5-2
## 2018-01-25
======================

 - Data Warehousing / Marts
    - types
        - bottom up
            - look at resources available, ask question
            - (casual) building data mart into warehouse
        - top down
            - focus on questions, get data to fill in gaps
            - (casual) building marts from warehouse
    - Warehouse
        - enterprise wide
    - Mart
        - division or department level
        - easier
            - cheaper
            - shorter time period (quicker ROI)
            - less complex
            - fewer stakeholders (less political)
        - Most prevalent
    - Dimensional schema
        - includes fact table (fks, measures) and dimensions (who, what, when)
        - dimensions use "dimPk_foo" notation for pks, to distinguish from source keys 
            - might want to reference source key in dimension
        - fact table has composite pk of all dimension fks
        - measures may come from an additional db, or other table in db
        - querying db
            - SELECT aggregate function of measure (max, min, sum)
        - need to change name in dimension (ex: store type has changed)
            - overwrite existing name
                - con: lose history
            - create a new row
                - now have `store_typeOld` and `store_typeNew`
                - most popular
            - create new column


