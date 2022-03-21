#!/bin/bash

if [ $# -ne 2 ]; then
    echo "$0: usage: $0 <username> <password>"
    exit 1
fi

username="$1"
password="$2"

DATA_DIRECTORY='tmp'

mkdir -p "$DATA_DIRECTORY"

YESTERDAY=$(date -d "yesterday" '+%Y-%m-%d')
MODIFICATION_FILE="http://download.geonames.org/export/dump/modifications-${YESTERDAY}.txt"

wget --directory-prefix="$DATA_DIRECTORY" "$MODIFICATION_FILE"
MYSQLVERSION=$(mysql --version|awk '{ print $3 }'|awk -F\, '{ print $1 }')
if [[ "$MYSQLVERSION" = 8* ]]
then
  SPATIAL_MIGRATION_QUERY="ST_GeomFromText(CONCAT('POINT (', temporary_geoName.latitude, ' ', temporary_geoName.longitude, ')'), 4326)"
else
  SPATIAL_MIGRATION_QUERY="ST_GeomFromText(CONCAT('POINT (', temporary_geoName.longitude, ' ', temporary_geoName.latitude, ')'), 4326)"
fi

echo $SPATIAL_MIGRATION_QUERY
mysql -u "$username" -p"$password" geonames --local-infile=1 << EOF

CREATE TEMPORARY TABLE temporary_geoName LIKE geoName;

SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE 'tmp/modifications-${YESTERDAY}.txt'
INTO TABLE temporary_geoName;

SHOW COLUMNS FROM geoName;
INSERT INTO geoName
SELECT * FROM temporary_geoName
ON DUPLICATE KEY UPDATE
  geonameid = VALUES(geonameid),
  name=VALUES(name),
  asciiname=VALUES(asciiname),
  alternatenames=VALUES(alternatenames),
  latitude=VALUES(latitude),
  longitude=VALUES(longitude),
  fclass=VALUES(fclass),
  fcode=VALUES(fcode),
  country=VALUES(country),
  cc2=VALUES(cc2),
  admin1=VALUES(admin1),
  admin2=VALUES(admin2),
  admin3=VALUES(admin3),
  admin4=VALUES(admin4),
  population=VALUES(population),
  elevation=VALUES(elevation),
  dem=VALUES(dem),
  timezone=VALUES(timezone),
  moddate=VALUES(moddate);

INSERT INTO geoNameSpatial (geoNameId, coordinates)
      SELECT temporary_geoName.geoNameId, ${SPATIAL_MIGRATION_QUERY}
      FROM temporary_geoName
      ON DUPLICATE KEY UPDATE
        geonameid = VALUES(geonameid),
        coordinates=VALUES(coordinates);

DROP TEMPORARY TABLE temporary_geoName;

COMMIT;
EOF

rm -r "$DATA_DIRECTORY"
