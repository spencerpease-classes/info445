USE CUSTOMER_BUILD

/*
Generations:
- Silent gen:   Jan1 1920-35
- Greatest gen: Jan1 1935-45
- Baby Boomer:  Jan1 1945-63
- Gen X:        Jan1 1964-83
*/

SELECT (CASE

    WHEN DateOfBirth BETWEEN '1/1/1915' AND '12/31/1934'
    THEN 'Silent Generation'
    WHEN DateOFBirth BETWEEN '1/1/1935' AND '12/31/1944' 
    THEN 'Greatest Gen'
    WHEN DateOfBirth BETWEEN '1/1/1945' AND '12/31/1963'
    THEN 'Baby Boomer'
    WHEN DateOfBirth BETWEEN '1/1/1964' AND '12/31/1983'
    THEN 'Gen X'
    ELSE 'Generation unknown'
    END
) 
AS 'GenerationName', COUNT(*) AS NumberOfPeeps
FROM tblCUSTOMER
GROUP BY (CASE

    WHEN DateOfBirth BETWEEN '1/1/1915' AND '12/31/1934'
    THEN 'Silent Generation'
    WHEN DateOFBirth BETWEEN '1/1/1935' AND '12/31/1944' 
    THEN 'Greatest Gen'
    WHEN DateOfBirth BETWEEN '1/1/1945' AND '12/31/1963'
    THEN 'Baby Boomer'
    WHEN DateOfBirth BETWEEN '1/1/1964' AND '12/31/1983'
    THEN 'Gen X'
    ELSE 'Generation unknown'
    END
)
ORDER BY GenerationName