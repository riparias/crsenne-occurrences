Delete
  FROM parsed_names
    WHERE  name=''
        OR name =' '
        OR name IS NULL
    ;

UPDATE parsed_names
  SET name=
    replace(name,' sp.','')
    ;


UPDATE parsed_names
  SET name=
    replace(name,' sp','')
    ;

Alter table parsed_names
  ADD COLUMN
    champ text default null
    ;

UPDATE parsed_names
  SET champ=
    (SELECT champ from raw_names R WHERE R.orig=parsed_names.orig)
    ;

UPDATE parsed_names
  SET name =
    SUBSTR(name, 0,instr(name, '('))
  WHERE name LIKE'%(%)%'
    ;

UPDATE parsed_names
  SET name =
    SUBSTR(name, 0,instr(name, '《'))
  WHERE name LIKE'%《%'
  ;

UPDATE parsed_names
  SET name =
    trim(name)
  ;


UPDATE Names_mapping_RVBCRS
  SET orig=
    trim(orig)
  ;

UPDATE inventaire
  SET eventDate =
    SUBSTR(updated_at,0,11)
  WHERE
      eventDate is null;
