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
