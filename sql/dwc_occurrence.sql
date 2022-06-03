
CREATE TABLE dwc_occurrences as
SELECT
/*1. IMPORTING PRESENCE / ABSENCES FOR SPECIES TARGETTED BY SPECIFIC SURVEYS*/
--OCCURRENCE
  I.fulcrum_id                                                  AS eventID,
  'HumanObservation'                                            AS basisOfRecord,
  I.observateurs                                                AS recordedBy,
  I.fulcrum_id||'-'||M.scientificName                           AS occurrenceID, -- using names harmonized by GBIF, should remain stable if the raw input names change in the future... I.fulcrum_id||'-'||substr(sha1(M.scientificName),1,5) failed to load sha1 with dbi...

  CASE
	   WHEN M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_aqua)
        THEN 'present'
	   WHEN M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_cep)
        THEN 'present'
	   WHEN M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.sp_ecrevisse)
        THEN 'present'
	   ELSE    'absent'
     END
     	                                                          AS occurrenceStatus,

  CASE
      WHEN M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND (P.orig=I.espece_aqua OR  P.orig=I.espece_cep OR  P.orig=I.sp_ecrevisse))
          THEN 'risk of dispersal : '||I.risque_dispersion_eee
      ELSE      NULL
      END
                                                                AS occurrenceRemarks, -- only field ok to capture, only concerns present target species

  CASE
      WHEN I.nombre_de_pieds IS NOT NULL AND I.nombre_de_pieds!='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_aqua)
          THEN I.nombre_de_pieds
      WHEN I.nombre_de_pieds_aqua IS NOT NULL AND I.nombre_de_pieds_aqua!='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_cep)
          THEN I.nombre_de_pieds_aqua
      ELSE     NULL
      END
                                                                AS individualCount,
  CASE
      WHEN I.surface_d_occupation IS NOT NULL AND I.surface_d_occupation!='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_cep)
          THEN I.surface_d_occupation
      WHEN I.surface_d_occupation_aqua IS NOT NULL AND I.surface_d_occupation_aqua!=''AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_aqua)
          THEN I.surface_d_occupation_aqua
      ELSE     NULL
      END
                                                                AS organismQuantity, -- No real count available for crayfishes

  CASE
    WHEN I.surface_d_occupation IS NOT NULL AND I.surface_d_occupation!='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_cep)
          THEN 'square meters'
    WHEN I.surface_d_occupation_aqua IS NOT NULL AND I.surface_d_occupation_aqua!=''AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_aqua)
          THEN 'square meters'
    ELSE       NULL
    END
                                                                AS organismQuantitytype,
  CASE
      WHEN I.photos_sp_alerte_aqua_url IS NOT NULL AND I.photos_sp_alerte_aqua_url !='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_aqua)
          THEN I.photos_sp_alerte_aqua_url
      WHEN I.photos_sp_alerte_cep_url IS NOT NULL AND I.photos_sp_alerte_cep_url !='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_cep)
          THEN I.photos_sp_alerte_cep_url -- no pictures for crayfIShes
      ELSE     NULL
      END
                                                                AS  ASsociatedMedia, --Issues with pictures: no real way to link them to a single occurrence  need to connect to fulcrum....

  'introduced'                                                  AS  establishmentMeans,


-- IDENTIFICATION
  observateurs                                                  AS identifiedBy,

-- TAXON
  CASE
      WHEN I.espece_aqua IS NOT NULL AND I.espece_aqua !='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_aqua)
          THEN I.espece_aqua
      WHEN I.espece_cep IS NOT NULL AND I.espece_cep !='' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_cep)
          THEN I.espece_cep
      WHEN I.sp_ecrevisse IS NOT NULL AND I.sp_ecrevisse !='Etang ecrevisses' AND M.scientificName IN (SELECT scientificName FROM parsed_names P WHERE P.module=M.module AND P.orig=I.espece_aqua)
          THEN I.sp_ecrevisse
      ELSE     NULL
      END
                                                                AS verbatimscientificName,
  M.scientificName                                              AS scientificName,
  M.kingdom                                                     AS kingdom,
  M.phylum                                                      AS phylum,
  M.family                                                      AS family,
  M.genus                                                       AS genus,
  lower(M.trank)                                                AS taxonRank


FROM inventaire I
LEFT JOIN Modules_species M ON M.module=I.modules_ripariAS
UNION

/*2. IMPORTING PRESENCE-ONLY FOR SPECIES NOT TARGETTED BY SURVEYS */


SELECT
--OCCURRENCE
  I.fulcrum_id                                                   AS eventID,
  'HumanObservation'                                             AS bAsisOfRecord,
  I.observateurs                                                 AS recordedBy,
  I.fulcrum_id||'-'||scientificName                              AS occurrenceID,      --  I.fulcrum_id||'-'||substr(sha1(M.scientificName),1,5) failed to load sha1 with dbi on Rstudio...
  'present'	                                                     AS occurrenceStatus,
  NULL                                                           AS occurrenceRemarks, -- Multiple fields were only related to survey targetted species, info missing for other observations.
  NULL                                                           AS individualCount,
  NULL                                                           AS organismQuantity,
  NULL                                                           AS organismQuantitytype,
  NULL                                                           AS ASsociatedMedia,

  CASE
      WHEN M.orig=I.espece_aqua_other OR  M.orig=I.espece_cep_other        OR  M.orig=I.sp_ecrevisse_other
          THEN    'introduced'
      WHEN M.orig=I.sp_aqua_indigenes OR  M.orig=I.sp_aqua_indigenes_other OR  M.orig=I.sp_protegees
          THEN    NULL
      ELSE         NULL
      END
                                                                 AS establishmentMeans,

-- IDENTIFICATION
  I.observateurs                                                 AS identifiedBy,

-- TAXON
  M.orig                                                         AS verbatimscientificName,
  M.scientificName                                               AS scientificName,
  (SELECT kingdom FROM Names_mapping_RVBCRS T WHERE t.orig=M.name)       AS kingdom,
  (SELECT phylum FROM Names_mapping_RVBCRS T WHERE t.orig=M.name)        AS phylum,
  (SELECT family FROM Names_mapping_RVBCRS T WHERE t.orig=M.name)        AS family,
  (SELECT genus FROM Names_mapping_RVBCRS T WHERE t.orig=M.name)         AS genus,
  (SELECT lower(trank)FROM Names_mapping_RVBCRS T WHERE t.orig=M.name)   AS taxonRank

                FROM inventaire I
                    INNER JOIN parsed_names M
                          ON  M.orig=I.sp_aqua_indigenes
                          OR  M.orig =I.sp_aqua_indigenes_other
                          OR  M.orig=I.sp_protegees
                          OR  M.orig=I.espece_aqua_other
                          OR  M.orig=I.espece_cep_other
                          OR  M.orig=I.sp_ecrevisse_other
                    WHERE M.scientificName IS NOT NULL
                    ;
