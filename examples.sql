-- Find locations nearest a given latitude / longitude
SELECT
    name,
    ST_Distance_Sphere(ST_GeomFromText('POINT(37.413752 -76.525506)', 4326), coordinates) AS distance_meters
FROM geoName
ORDER BY distance ASC
