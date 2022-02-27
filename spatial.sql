USE geonames;

CREATE TABLE geoNameSpatial (
  `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
  `coordinates` POINT NOT NULL COMMENT "Latitude-Longitude coordinates of record"
) ROW_FORMAT=COMPRESSED;

CREATE SPATIAL INDEX sx_geonames_coords ON geoNameSpatial(coordinates);

INSERT INTO geoNameSpatial (geoNameId, coordinates)
    SELECT geoName.geoNameId, ST_GeomFromText(CONCAT('POINT (', geoName.latitude, ' ', geoName.longitude, ')'), 4326)
    FROM geoName;

CREATE TABLE `shapesSpatial` (
  `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
  `geom` GEOMETRY NOT NULL
) ROW_FORMAT=COMPRESSED;

CREATE SPATIAL INDEX sx_shapes_geom ON shapesSpatial(geom);

INSERT INTO shapesSpatial (geoNameId, geom)
    SELECT shapes.geoNameId, ST_GeomFromGeoJSON(geoJson, 1)
    FROM shapes;
