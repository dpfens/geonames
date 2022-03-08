USE geonames;

INSERT INTO geoNameSpatial (geoNameId, coordinates)
    SELECT geoName.geoNameId, ST_GeomFromText(CONCAT('POINT (', geoName.latitude, ' ', geoName.longitude, ')'), 4326)
    FROM geoName;

INSERT INTO shapesSpatial (geoNameId, geom)
    SELECT shapes.geoNameId, ST_GeomFromGeoJSON(geoJson, 1)
    FROM shapes;
