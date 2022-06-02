/*Disaggregate raw observation inputs into single-species occurrences*/
CREATE TABLE parsed_names AS
SELECT *
FROM (
WITH RECURSIVE split(orig, name, str) AS (
    SELECT orig, '', name||',' FROM parsing_table
    UNION ALL SELECT
    orig,
    substr(str, 0, instr(str, ',')),
    substr(str, instr(str, ',')+1)
    FROM split WHERE str!='')
SELECT orig, name
FROM split
WHERE name!='' ORDER BY orig);
/*NEXT:cleaning_parsed_names.sql*/
