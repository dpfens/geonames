ALTER TABLE geoName
ADD COLUMN coordinates POINT;

UPDATE geoName
  SET coordinates = ST_GeomFromText(CONCAT('POINT (', latitude, ' ', longitude, ')'), 4326)
WHERE 1=1;

CREATE SPATIAL INDEX sx_geonames_coords ON geoName(coordinates);
