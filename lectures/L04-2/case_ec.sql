/* Spencer Pease
 * CASE Practice
*/

SELECT (CASE

    WHEN State IN ("California", "Oregon", "Idaho")
    THEN "Friendly"
    WHEN State IN ("Michigan", "OHIO", "Indiana")
    THEN "Big Ten"
    WHEN State IN ("Texas", "Oklahoma")
    THEN "Big 12"
    ELSE "Unknown"
    END
) 
AS "StateType", COUNT(*) AS "NumberOfStudentsVisited"

FROM Student stu
    JOIN STUDENT_STATE st on stu.StudentID = st.StudentID
    JOIN STATE sta on sta.StateID = st.StateID

GROUP BY (CASE

    WHEN State IN ("California", "Oregon", "Idaho")
    THEN "Friendly"
    WHEN State IN ("Michigan", "OHIO", "Indiana")
    THEN "Big Ten"
    WHEN State IN ("Texas", "Oklahoma")
    THEN "Big 12"
    ELSE "Unknown"
    END
)
ORDER BY "NumberOfStudentsVisited"
