CREATE TABLE geoNameSpatial (
  `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
  `coordinates` POINT NOT NULL COMMENT "Latitude-Longitude coordinates of record"
) ROW_FORMAT=COMPRESSED;

INSERT INTO geoNameSpatial (geoNameId, coordinates)
    SELECT geoName.geoNameId, ST_GeomFromText(CONCAT('POINT (', geoName.latitude, ' ', geoName.longitude, ')'), 4326)
    FROM geoName
      LEFT JOIN geoNameSpatial
        ON geoName.geoNameId=geoNameSpatial.geoNameId
    WHERE geoNameSpatial.geoNameId is NULL;

CREATE SPATIAL INDEX sx_geonames_coords ON geoNameSpatial(coordinates);

CREATE TABLE `shapesSpatial` (
  `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
  `geom` GEOMETRY NOT NULL
) ROW_FORMAT=COMPRESSED;

INSERT INTO shapesSpatial (geoNameId, geom)
    SELECT geoName.geoNameId, ST_GeomFromGeoJSON(geoJson, 1)
    FROM shapes
      LEFT JOIN shapesSpatial
        ON shapes.geoNameId=shapesSpatial.geoNameId
    WHERE shapesSpatial.geoNameId is NULL;

CREATE SPATIAL INDEX sx_shapes_geom ON shapesSpatial(geom);
