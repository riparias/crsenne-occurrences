/*
Created by Peter Desmet (INBO)
*/

SELECT
-- RECORD LEVEL
  'Event'                               AS type,
  REPLACE(REPLACE(updated_at," UTC", "Z"), " ", "T") AS modified,
--  NULL                                  AS license,
--  NULL                                  AS rightsHolder,
--  NULL                                  AS datasetID,
--  NULL                                  AS institutionCode,
--  NULL                                  AS collectionCode,
--  NULL                                  AS datasetName,
  'HumanObservation'                    AS basisOfRecord,
-- EVENT
  fulcrum_id                            AS eventID,
  NULL                                  AS parentEventID,
  date                                  AS eventDate,
  NULL                                  AS eventRemarks,
-- LOCATION
  cours_d_eau                           AS waterBody,
  commune                               AS municipality,
  latitude                              AS decimalLatitude,
  longitude                             AS decimalLongitude,
  'WGS84'                               AS geodeticDatum
FROM
  data AS d
