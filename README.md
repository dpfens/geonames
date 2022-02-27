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


### Nearest location
To find the geoname location based on a given latitude/longitude, use the following query, which fetches the nearest 10 administrative places:
```sql
SELECT name FROM geoName
  INNER JOIN geoNameSpatial
    ON geoName.geoNameId=geoNameSpatial.geoNameId
  WHERE geoName.fclass='A'
  ORDER BY ST_Distance_Sphere(coordinates, ST_GeomFromText('POINT(37.532054 -77.427336)', 4326))
LIMIT 10
```

As spatial indexes are only applied to `ST_within` and `ST_contains` functions, the above query probably took a while.  To find out what country a given latitude/longitude is within, use the following query:

```sql
SELECT name FROM geoName
  INNER JOIN shapesSpatial
    ON shapesSpatial.geoNameId=geoName.geoNameId
  WHERE ST_Within(ST_GeomFromText('POINT(37.532054 -77.427336)', 4326), geom)
```
