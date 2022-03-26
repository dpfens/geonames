# Geonames
A set of bash scripts to create/populate a `geonames` MySQL database.  Based heavily upon the [Geonames Forum thread](http://forum.geonames.org/gforum/posts/list/732.page).

## Usage

### Create database
Create the `geonames` MySQL database:
```bash
bash create.sh <root> <password>
```

### Import data
Fetch data from the Geonames [file dump](http://download.geonames.org/export/dump/) and import it into the `geonames` MySQL database:
```bash
bash import.sh <root> <password>
```

### Daily Modifications
Schedule the `daily_update.sh` script to run every day to process the `modifications-YYYY-MM-DD.txt` file of updates to the `geoNames` table;

## Understanding the data
The primary table is the `GeoNames` table.  The main way I filter that list is using the [Feature Codes](http://www.geonames.org/export/codes.html) in the `fclass` and `fcode` columns.

For example, rows where `fclass='P'` are places (cities, villages, etc.), and rows where `fclass='A'` are administrative/legal places (countries, states, etc.)

## Querying

### Hierarchical Queries
To fetch the full hierarchy of geonames, use a `WITH RECURSIVE` MySQL statement, also called [Hierarchical Table Traversal](https://dev.mysql.com/doc/refman/8.0/en/with.html#common-table-expressions-recursive-hierarchy-traversal).


To fetch all of the geonames a place is within, use the following, where the `placeID` is the `geoNameId` of the place you want the hierarchy for:
```sql
WITH RECURSIVE location (id, name, type, fclass, level) AS
(
  SELECT geoNameId, name, 'None', geoName.fclass, 1
    FROM geoName
    WHERE geoNameId=placeID
  UNION ALL
  SELECT geoNameId, geoName.name, hierarchy.type, geoName.fclass, level+1
    FROM geoName
    INNER JOIN hierarchy
    	ON hierarchy.parentId=geoName.geonameid
    INNER JOIN location
    	ON location.id=hierarchy.childId
    WHERE hierarchy.type='ADM'
)
SELECT * FROM location ORDER by level
```


To query all geonames that are within a given geoname, use the following, where placeID could be something like `6254928` (Virginia, USA) and will fetch all counties in Virginia
```sql
WITH RECURSIVE location (id, name, type, fclass, level) AS
(
  SELECT geoNameId, name, 'None', geoName.fclass, 1
    FROM geoName
    WHERE geoNameId=placeID
  UNION ALL
  SELECT geoNameId, geoName.name, hierarchy.type, geoName.fclass, level+1
    FROM geoName
    INNER JOIN hierarchy
    	ON hierarchy.childId=geoName.geonameid
    INNER JOIN location
    	ON location.id=hierarchy.parentId
    WHERE hierarchy.type='ADM'
)
SELECT * FROM location ORDER by level
```

### Country containing a point
To find out what country a given latitude/longitude is within, use the following query:

```sql
SELECT name FROM geoName
  INNER JOIN shapesSpatial
    ON shapesSpatial.geoNameId=geoName.geoNameId
  WHERE ST_Within(ST_GeomFromText('POINT(37.532054 -77.427336)', 4326), geom)
```

Spatial indexes are only applied to `ST_within` and `ST_contains` functions, which makes them critical for optimizing queries involving spatial data.


### Nearest Neighbors to a point
To find the geoname location based on a given latitude/longitude, use the following query, which fetches the nearest 10 administrative places:
```sql
SELECT geoName.* FROM geoName
  INNER JOIN geoNameSpatial
    ON geoName.geoNameId=geoNameSpatial.geoNameId
  WHERE geoName.fclass='A'
  ORDER BY ST_Distance_Sphere(coordinates, ST_SRID(POINT(-97.745363, 30.324014), 4326))
LIMIT 10
```

However, the above query takes a long time to complete, because `ST_Distance_Sphere` doesn't use an index.  To speed up the query, we need to find a way to filter our query using `ST_Within` or `ST_Contains` so that a spatial index will be used.

We can create a bounding box around our given coordinates, so the query will only include that are near to our coordinates `ST_Contains(<bounding box>, geoNameSpatial.coordinates)`.

```sql
SELECT geoName.* FROM geoName
  INNER JOIN geoNameSpatial
	 ON geoNameSpatial.geonameid=geoName.geonameid
WHERE geoName.fclass='A'
  AND ST_CONTAINS(
    ST_SRID(st_makeEnvelope ( POINT(-97.562130172913, 30.20954084441), POINT(-97.928595827087, 30.53848715559)), 4326),
    geoNameSpatial.coordinates
  )
  ORDER BY ST_Distance_Sphere(
      geoNameSpatial.coordinates,
      ST_SRID(POINT(-97.745363, 30.324014), 4326),
      4326
  )
LIMIT 10
```

This reduces our query time from ~13 seconds to 0.0058 seconds (approximately 2200x speed up).

But, we still have to calculate our bounding box ourselves.  To make things easier, I included a MySQL `boundingBox` function in `functions/boundingBox.sql` so you won't need to re-implement bounding box calculations in your application.

to use `boundingBox`, you will need to provide the `coordinates (POINT)` you want at the center of your bounding box, `distance (DOUBLE)` from the `coordinates` you want the bounding box to extend, and the `sphereRadius (DOUBLE)` of the planet your coordinates were measured on. `distance` and `sphereRadius` can be in any unit, but both must use the same units.  When using `geoNames` data, `sphereRadius` will be the radius of Earth,  3978.8 miles, or 6371 kilometers.

Here is an example of how to use this query, where the `distance` iextends 10 miles from the given coordinates:

```sql
SELECT geoName.* FROM geoName
  INNER JOIN geoNameSpatial
	 ON geoNameSpatial.geonameid=geoName.geonameid
WHERE geoName.fclass='A'
  AND ST_CONTAINS(
    ST_SRID(boundingBox(ST_SRID(POINT(-97.745363, 30.324014), 4326), 10, 3958.8), 4326),
    geoNameSpatial.coordinates
  )
  ORDER BY ST_Distance_Sphere(
      geoNameSpatial.coordinates,
      ST_SRID(POINT(-97.745363, 30.324014), 4326),
      4326
  )
LIMIT 10;
```

The results of the above query should be identical to those of the previous query.

**NOTE**: These functions are not loaded into your database automatically, and depends directly on the other functions in the `functions` folder.
