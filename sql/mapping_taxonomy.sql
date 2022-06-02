
ALTER TABLE parsed_names
  ADD COLUMN
    ScientificName TEXT DEFAULT NULL
    ;

UPDATE parsed_names
  SET scientificName =
    (SELECT scientificName FROM Names_mapping_RVBCRS B WHERE trim(B.orig)=(parsed_names.name) and B.Relecture_CRS='ok' and name!='')
    ;


UPDATE parsed_names
  SET scientificName =
    (SELECT Relecture_CRS FROM Names_mapping_RVBCRS B WHERE trim(B.orig)=(parsed_names.name) and  Relecture_CRS!='ok' and name !='')
  WHERE
    scientificName IS NULL
    ;



ALTER TABLE parsed_names
  ADD COLUMN
  module TEXT DEFAULT NULL
  ;

UPDATE parsed_names
  SET module =
    (SELECT module FROM  Modules_species m WHERE m.scientificName=parsed_names.scientificName)
     ;
