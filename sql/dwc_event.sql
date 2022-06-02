/*
Created by Peter Desmet (INBO)
*/
CREATE TABLE dwc_Events AS
SELECT

-- RECORD LEVEL
  'Event'                                                                       AS type,
   updated_at                                                                   AS modified,
  'https://creativecommons.org/licenses/by-nc/4.0/'                             AS license,
  'Contrat de Rivière Senne'                                                    AS rightsHolder,
  NULL                                                                          AS datasetID,--TBU
  'CR SENNE'                                                                    AS institutionCode,
  'Contrat de Rivière Senne- RIPARIAS: detection and management of aquatic invasive alien species'   AS datasetName,
  'HumanObservation'                                                            AS basisOfRecord,

-- EVENT
  fulcrum_id                                                                    AS eventID,
  I.eventdate                                                                   AS eventDate,
  substr(I.eventdate,1,4)                                                       AS year,
  substr(I.eventdate,6,2)                                                       AS month,
  substr(I.eventdate, 9,2)                                                      AS Day,
  CASE
      WHEN modules_riparias='Etang ecrevisses'
          THEN ' crayfish traps'
      ELSE     'complete propspection of the site by the officers'
      END
                                                                                AS samplingProtocol,
  CASE
      WHEN nbr_pieges IS NOT NULL AND modules_riparias='Etang ecrevisses'
          THEN nbr_pieges||' crayfish traps'
          ELSE 'exhaustive site prospection'
          END                                                                   AS samplingEffort,
-- LOCATION
'BE'                                                                            AS CountryCode,
I.commune                                                                       AS municipality,
I.cours_d_eau                                                                   AS waterBody,
round(I.gps_altitude,1)                                                         AS elevation,
round(I.latitude,6)                                                             AS decimalLatitude,
round(I.longitude,6)                                                            AS decimalLongitude,
I.latitude                                                                      AS verbatimLatitude,
I.longitude                                                                     AS veratimLongitude,
'WGS84'                                                                         AS geodeticDatum,
I.geometry                                                                      AS footPrintWKT,
'EPSG:4326'                                                                     AS footPrintSRS

FROM inventaire I;
