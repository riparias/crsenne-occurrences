
/* Raw names are spred over multiple columns. Multiple canonical names (sep ',') can be present in a single entry */
/*1 Gathering raw species raw records from the different columns */
CREATE TABLE RAW_NAMES AS
SELECT
  distinct sp_aqua_indigenes        AS orig,
  'sp_aqua_indigenes'               AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct sp_aqua_indigenes_other  AS orig,
  'sp_aqua_indigenes_other'         AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct espece_aqua              AS orig,
  'espece_aqua'                     AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct  sp_ecrevisse            AS orig,
  'sp_ecrevisse'                    AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct sp_ecrevisse_other       AS orig,
  'sp_ecrevisse_other'              AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct sp_protegees             AS orig,
  'sp_protegees'                    AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct espece_cep               AS orig,
  'espece_cep'                      AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct espece_cep_other         AS orig,
  'espece_cep_other'                AS champ
    FROM inventaire
      UNION ALL
SELECT
  distinct espece_aqua_other        AS orig,
  'espece_aqua_other'               AS champ
    FROM inventaire
    ;
