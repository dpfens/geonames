-- A function for calculating the Bounding Box of a given latitude, longitude pairing
-- coordinates is the point at the center of the bounding box
-- miles is the distance of the edge of the bounding box from the coordinates point
-- sphereRadiusMiles is the radius of the sphere on which the coordinates are mapped
-- FExample:
--
--  boundingBox(ST_SRID(POINT(-97.745363, 30.324014), 4326), 10, 3958.8)
--
--  Creates a bounding box 10 miles wide around the given coordinates on Earth
--  (3958.8 is the radius of Earth)
DELIMITER $$

CREATE FUNCTION boundingBox (coordinates POINT, distance DOUBLE, sphereRadius DOUBLE)
RETURNS POLYGON
DETERMINISTIC

BEGIN
  DECLARE latitude DOUBLE;
  DECLARE longitude DOUBLE;

  DECLARE radianLatitude DOUBLE;
  DECLARE radianLongitude DOUBLE;

  DECLARE minLatitudeLimit DOUBLE;
  DECLARE maxLatitudeLimit DOUBLE;
  DECLARE minLongitudeLimit DOUBLE;
  DECLARE maxLongitudeLimit DOUBLE;

  DECLARE angular DOUBLE;

  DECLARE minLatitude DOUBLE;
  DECLARE maxLatitude DOUBLE;
  DECLARE minLongitude DOUBLE;
  DECLARE maxLongitude DOUBLE;

  DECLARE deltaLongitude DOUBLE;

  DECLARE finalLatitude DOUBLE;
  DECLARE finalLongitude DOUBLE;

  DECLARE P1 POINT;
  DECLARE P2 POINT;

  SET latitude = ST_LATITUDE(coordinates);
  SET longitude = ST_LONGITUDE(coordinates);

  SET radianLatitude = degreesToRadians(latitude);
  SET radianLongitude = degreesToRadians(longitude);

  SET minLatitudeLimit = degreesToRadians(-90);
  SET maxLatitudeLimit = degreesToRadians(90);

  SET minLongitudeLimit = degreesToRadians(-180);
  SET maxLongitudeLimit = degreesToRadians(180);

  IF radianLatitude < minLatitudeLimit OR radianLatitude > maxLatitudeLimit
      OR radianLatitude < minLongitudeLimit OR radianLongitude > maxLongitudeLimit THEN
      return NULL;
  END IF;

  SET angular = distance / sphereRadius;

  SET minLatitude = radianLatitude - angular;
  SET maxLatitude = radianLatitude + angular;

  IF minLatitude > minLatitudeLimit AND maxLatitude < maxLatitudeLimit THEN
      -- No poles are contained within the bounding Box
      SET deltaLongitude = ASIN(SIN(angular) / COS(radianLatitude));
      SET minLongitude = radianLongitude - deltaLongitude;

      IF minLongitude < minLongitudeLimit THEN
        SET minLongitude = minLongitude + (2.0 * PI());
      END IF;

      SET maxLongitude = radianLongitude + deltaLongitude;
      IF maxLongitude > maxLongitudeLimit THEN
        SET maxLongitude = maxLongitude - (2.0 * PI());
      END IF;
  ELSE
      -- A pole is contained within the distance.
      SET minLatitude = GREATEST(minLatitude, minLatitudeLimit);
      SET maxLatitude = LEAST(maxLatitude, maxLatitudeLimit);

      SET minLongitude = minLongitudeLimit;
      SET maxLongitude = maxLongitudeLimit;
  END IF;

  SET P1 = POINT(radiansToDegrees(minLongitude), radiansToDegrees(minLatitude));
  SET P2 = POINT(radiansToDegrees(maxLongitude), radiansToDegrees(maxLatitude));

  RETURN ST_MAKEENVELOPE(P1, P2);
END; $$

DELIMITER ;
