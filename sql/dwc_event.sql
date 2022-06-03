/*
Created by Peter Desmet (INBO)
*/
CREATE TABLE dwc_Events AS
SELECT

-- RECORD LEVEL
  'Event'                                                                       AS type,
  SUBSTR(updated_at,0,11)                                                       AS modified, -- only keeping the day ATM. Source data mix CET and CEST : ASK Dido
  'https://creativecommons.org/licenses/by-nc/4.0/'                             AS license,
  'Contrat de Rivière Senne'                                                    AS rightsHolder,
  NULL                                                                          AS datasetID,--TBU
  'CR SENNE'                                                                    AS institutionCode,
  'Contrat de Rivière Senne- RIPARIAS: detection and management of aquatic invasive alien species'   AS datasetName,

-- EVENT
  fulcrum_id                                                                    AS eventID,
  I.eventdate                                                                   AS eventDate,
  substr(I.eventdate,1,4)                                                       AS year,
  substr(I.eventdate,6,2)                                                       AS month,
  substr(I.eventdate, 9,2)                                                      AS Day,
  CASE
      WHEN nbr_pieges IS NOT NULL
       AND modules_riparias='Etang ecrevisses'
      THEN ' crayfish traps'
      ELSE  'complete propspection of the site by the officers'
      END
                                                                                AS samplingProtocol,
  CASE
      WHEN     nbr_pieges IS NOT NULL
        AND    modules_riparias='Etang ecrevisses'
      THEN nbr_pieges||' crayfish traps'
      ELSE 'exhaustive site prospection'
      END                                                                       AS samplingEffort,
-- LOCATION
'BE'                                                                            AS CountryCode,
I.commune                                                                       AS municipality,
I.cours_d_eau                                                                   AS waterBody,
I.gps_altitude                                                                  AS verbatimElevation,
round(I.latitude,6)                                                             AS decimalLatitude,
round(I.longitude,6)                                                            AS decimalLongitude,
I.latitude                                                                      AS verbatimLatitude,
I.longitude                                                                     AS verbatimLongitude,
'WGS84'                                                                         AS geodeticDatum,
I.geometry                                                                      AS footPrintWKT,
'EPSG:4326'                                                                     AS footPrintSRS

FROM inventaire I;
