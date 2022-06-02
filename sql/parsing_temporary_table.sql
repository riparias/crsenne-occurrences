/*Parsing names recorded in a single entry */
/*Raw records still include many species within sigle fields. These names need to be sorted.*/
CREATE TABLE  parsing_table as
  SELECT
    orig        as orig,
    orig        as name
  from raw_names;
/*NEXT PARSING_RECORDS.sql*/
