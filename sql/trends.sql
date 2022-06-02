CREATE TABLE observed_introduced_species AS
  SELECT scientificName, module
    FROM parsed_names
      where scientificname in (SELECT ScientificName FROM Modules_species)
    group by scientificname;

CREATE TABLE missing_introduced_species AS
  SELECT scientificName, module
    FROM Modules_species
    EXCEPT
  SELECT scientificName, module
    FROM parsed_names;

CREATE TABLE other_observed_species AS
  SELECT scientificName,
         module
    FROM parsed_names
  EXCEPT
  SELECT scientificName, module
    FROM Modules_species;


CREATE TABLE status_trends AS
  SELECT ScientificName,
        occurrenceStatus,
        COUNT(*)  N_data
      FROM dwc_occurrences
        GROUP BY ScientificName,
                 occurrenceStatus
        ORDER BY ScientificName
    ;

CREATE TABLE metadata_trends AS
  SELECT
      (SELECT max(decimalLongitude) FROM dwc_Events)   AS MaxLong,
      (SELECT min(decimalLongitude) FROM dwc_Events)   AS MinLong,
      (SELECT max(decimalLatitude) FROM dwc_Events)    AS MaxLat,
      (SELECT min(decimalLatitude) FROM dwc_Events)    AS MinLat,
      (SELECT max(eventDate) FROM dwc_Events)          AS MaxeventDate,
    	(SELECT min(eventDate) FROM dwc_Events)          AS MineventDate,
      (SELECT COUNT(eventid) FROM dwc_Events)            AS N_events,
      COUNT(*)                 AS N_data,
      COUNT(distinct scientificName)                                     AS N_taxa,
      (SELECT COUNT(occurrenceID)FROM dwc_occurrences where occurrenceStatus='present')               AS N_presences,
      (SELECT COUNT(occurrenceID)FROM dwc_occurrences where occurrenceStatus='absent')                AS N_absences

    FROM dwc_occurrences;
