USE geonames;

CREATE TABLE geoNameSpatial (
  `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
  `coordinates` POINT NOT NULL SRID 4326 COMMENT "Latitude-Longitude coordinates of record"
) ROW_FORMAT=COMPRESSED;

CREATE SPATIAL INDEX sx_geonames_coords ON geoNameSpatial(coordinates);

CREATE TABLE `shapesSpatial` (
  `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
  `geom` GEOMETRY NOT NULL SRID 4326
) ROW_FORMAT=COMPRESSED;

CREATE SPATIAL INDEX sx_shapes_geom ON shapesSpatial(geom);
