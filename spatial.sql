ALTER TABLE geoName
ADD COLUMN coordinates POINT;

UPDATE geoName
  SET coordinates = ST_GeomFromText(CONCAT('POINT (', latitude, ' ', longitude, ')'), 4326)
WHERE 1=1;

CREATE SPATIAL INDEX sx_geonames_coords ON geoName(coordinates);

ALTER TABLE `shapes`
ADD `geom` GEOMETRY;

UPDATE `shapes`
  SET geom=ST_GeomFromGeoJSON(geoJson, 1)
WHERE 1=1;

CREATE SPATIAL INDEX sx_shapes_geom ON shapes(geom);
