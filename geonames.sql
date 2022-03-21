CREATE DATABASE IF NOT EXISTS `geonames`
    CHARACTER SET UTF8MB4
    COLLATE  utf8mb4_general_ci;

USE geonames;

DROP TABLE IF EXISTS  `admin1Codes`;
CREATE TABLE `admin1Codes` (
    `code` CHAR(6)           COMMENT "Administrative division code",
    `name` TEXT		           COMMENT "Name",
    `nameAscii` TEXT         COMMENT "Name in ASCII",
    `geonameid` INT UNSIGNED COMMENT "GeoName ID"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS  `admin2Codes`;
CREATE TABLE `admin2Codes` (
    `code` CHAR(16)          COMMENT "Administrative subdivision cod",
    `name` TEXT              COMMENT "Name",
    `nameAscii` TEXT         COMMENT "Name in ASCII",
    `geonameid` INT UNSIGNED COMMENT "GeoName ID"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS  `admin5Codes`;
CREATE TABLE `admin5Codes` (
    `code` CHAR(10)          COMMENT "new adm5 column",
    `geonameid` INT UNSIGNED COMMENT "GeoName ID"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS `alternateNames`;
CREATE TABLE `alternateNames` (
    `alternatenameid` INT  PRIMARY KEY COMMENT "ID alternate name",
    `geonameid` INT UNSIGNED           COMMENT "GeoName ID",
    `isoLanguage` VARCHAR(7)           COMMENT "ISO639 2-3 char, 'post'=Postal Code, 'iata','icao' & faac=Airport Code, 'fr_1793',  'abbr'=abbreviation, 'link'=URL, 'wkdt'=wikidata",
    `alternateName` VARCHAR(400)       COMMENT "Alt name or variant",
    `isPreferredName` BOOLEAN          COMMENT "Alternate name is an official/preferred name",
    `isShortName` BOOLEAN              COMMENT "Short name like 'California' for 'State of California",
    `isColloquial` BOOLEAN             COMMENT "Colloquial or slang term. Example: 'Big Apple' for 'New York'",
    `isHistoric` BOOLEAN               COMMENT "Historic and was used in the past. Example 'Bombay' for 'Mumbai'"
) CHARACTER SET utf8mb4
ROW_FORMAT=COMPRESSED;


DROP TABLE IF EXISTS  `continentCodes`;
CREATE TABLE IF NOT EXISTS `continentCodes` (
    `code` CHAR(2)                     COMMENT "Continent Code",
    `name` VARCHAR(20)                 COMMENT "Name",
    `geonameid` INT UNSIGNED           COMMENT "GeoName ID"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS  `countryInfo`;
CREATE TABLE `countryInfo` (
    `iso_alpha2` CHAR(2) PRIMARY KEY   COMMENT "ISO2 Alpha country code",
    `iso_alpha3` CHAR(3)               COMMENT "ISO3 Alpha country code",
    `iso_numeric` INTEGER              COMMENT "ISO Numeric country code",
    `fips_code` VARCHAR(3)             COMMENT "fips",
    `name` VARCHAR(200)                COMMENT "Country Name",
    `capital` VARCHAR(200)             COMMENT "Capital Name",
    `areainsqkm` DOUBLE PRECISION      COMMENT "Area (sq km)",
    `population` INT                   COMMENT "Population",
    `continent` CHAR(2)                COMMENT "Continent",
    `tld` CHAR(3)                      COMMENT "Top Level Domain",
    `currency` CHAR(3)                 COMMENT "Currency Code",
    `currencyName` CHAR(20)            COMMENT "Currency Name",
    `phone` CHAR(10)                   COMMENT "International Phone Prefix",
    `postalCodeFormat` CHAR(20)        COMMENT "Postal Code Format",
    `postalCodeRegex` CHAR(20)         COMMENT "Postal Code Regex",
    `geonameId` INT UNSIGNED           COMMENT "GeoName ID",
    `languages` VARCHAR(200)           COMMENT "Languages spoken in a country ordered by the number of speakers.",
    `neighbours` CHAR(20)              COMMENT "ISO2 list of comma separated neighbors",
    `equivalentFipsCode` CHAR(10)      COMMENT "Equivalent fips code"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS  `featureCodes`;
CREATE TABLE `featureCodes` (
    `code` CHAR(7)                     COMMENT "Feature Codes - 1st Character is type",
    `name` VARCHAR(200)                COMMENT "Name of the Feature",
    `description` TEXT                 COMMENT "Description"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS `geoName`;
CREATE TABLE `geoName` (
    `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
    `name` VARCHAR(200)                COMMENT "Name of geographical point ",
    `asciiname` VARCHAR(200)           COMMENT "Name of geographical point  in plain ascii characters",
    `alternatenames` VARCHAR(10000)    COMMENT "Comma separated, ascii names automatically transliterated, convenience attribute from alternatename table",
    `latitude` DECIMAL(10,7)           COMMENT "Latitude in decimal degrees (wgs84)",
    `longitude` DECIMAL(10,7)          COMMENT "Longitude in decimal degrees (wgs84)",
    `fclass` CHAR(1)                   COMMENT "http://www.geonames.org/export/codes.html (featureCodes.txt)",
    `fcode` VARCHAR(10)                COMMENT "http://www.geonames.org/export/codes.html (featureCodes.txt)",
    `country` VARCHAR(2)               COMMENT "ISO-3166 2-letter country code",
    `cc2` VARCHAR(200)                 COMMENT "Alternate country codes, comma separated, ISO-3166 2-letter country code",
    `admin1` VARCHAR(20)               COMMENT "1st Level Admin Division - FIPS for US (admin1Codes.txt)",
    `admin2` VARCHAR(80)               COMMENT "2nd Level Admin Division - County in US (admin2Codes.txt",
    `admin3` VARCHAR(20)               COMMENT "3rd Level Admin Division",
    `admin4` VARCHAR(20)               COMMENT "4th Level Admin Division",
    `population` BIGINT                COMMENT "Population (8 Byte INT )	",
    `elevation` INT                    COMMENT "Digital elevation model (srtm3)",
    `dem` VARCHAR(30)                  COMMENT "Digital elevation model (gtopo30)",
    `timezone` VARCHAR(40)             COMMENT "IANA timezone id (timeZone.txt)",
    `moddate` DATE                     COMMENT "Date of last modification in yyyy-MM-dd format"
) CHARACTER SET utf8mb4
ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS  `hierarchy`;
CREATE TABLE `hierarchy`(
    `parentId` INT UNSIGNED                    COMMENT "Parent ID",
    `childId` INT UNSIGNED                     COMMENT "Child ID",
    `type` CHAR(4)                     COMMENT "The type 'ADM' stands for the admin hierarchy modeled by the admin1-4 codes. The other entries are entered with the user interface."
) CHARACTER SET utf8mb4
ROW_FORMAT=COMPRESSED;


DROP TABLE IF EXISTS  `isoCurrencys`;
CREATE TABLE `isoCurrencys` (
    `isocode` CHAR(3)                  COMMENT "Currency Code - http://forum.geonames.org/gforum/posts/list/437.page",
    `symbol` VARCHAR(7)                COMMENT "Currency Symbol ",
    `name` VARCHAR(120)                COMMENT "Name",
    `fractional` VARCHAR(20)           COMMENT "Fractional Unit - http://forum.geonames.org/gforum/posts/list/1961.page"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS  `isoLanguages`;
CREATE TABLE `isoLanguages`(
    `iso639_3` CHAR(4)                 COMMENT "ISO639-3 character code",
    `iso639_2` VARCHAR(50)             COMMENT "ISO639-2 character code",
    `iso639_1` VARCHAR(50)             COMMENT "ISO639-1 character code",
    `languageName` VARCHAR(200)        COMMENT "Language Name"
) CHARACTER SET utf8mb4;

DROP TABLE IF EXISTS  `noCountry`;
CREATE TABLE `noCountry` (
    `geonameid` INT UNSIGNED PRIMARY KEY COMMENT "Integer id of record in geonames database",
    `name` VARCHAR(200)                COMMENT "Name of geographical point ",
    `asciiname` VARCHAR(200)           COMMENT "Name of geographical point  in plain ascii characters",
    `alternatenames` VARCHAR(10000)    COMMENT "Comma separated, ascii names automatically transliterated, convenience attribute from alternatename table",
    `latitude` DECIMAL(10,7)           COMMENT "Latitude in decimal degrees (wgs84)",
    `longitude` DECIMAL(10,7)          COMMENT "Longitude in decimal degrees (wgs84)",
    `fclass` CHAR(1)                   COMMENT "http://www.geonames.org/export/codes.html (featureCodes.txt)",
    `fcode` VARCHAR(10)                COMMENT "http://www.geonames.org/export/codes.html (featureCodes.txt)",
    `country` VARCHAR(2)               COMMENT "ISO-3166 2-letter country code",
    `cc2` VARCHAR(200)                 COMMENT "Alternate country codes, comma separated, ISO-3166 2-letter country code",
    `admin1` VARCHAR(20)               COMMENT "1st Level Admin Division - FIPS for US (admin1Codes.txt)",
    `admin2` VARCHAR(80)               COMMENT "2nd Level Admin Division - County in US (admin2Codes.txt",
    `admin3` VARCHAR(20)               COMMENT "3rd Level Admin Division",
    `admin4` VARCHAR(20)               COMMENT "4th Level Admin Division",
    `population` BIGINT                COMMENT "Population (8 Byte INT )	",
    `elevation` INT                    COMMENT "Digital elevation model (srtm3)",
    `gtopo30` INT                      COMMENT "Digital elevation model (gtopo30)",
    `timezone` VARCHAR(40)             COMMENT "IANA timezone id (timeZone.txt)",
    `moddate` DATE                     COMMENT "Date of last modification in yyyy-MM-dd format"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS `shapes`;
CREATE TABLE  `shapes` (
    `geonameid` INT UNSIGNED PRIMARY KEY       COMMENT "Integer id of record in geonames database",
    `geoJson` LONGTEXT                 COMMENT "GeoJSON for the feature"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS  `timeZones`;
CREATE TABLE  `timeZones` (
    `timeZoneId` VARCHAR(200)          COMMENT "Timezone ID - Area/Locale",
    `GMT_offset` DECIMAL(3,1)          COMMENT "Greenwich Mean Time offset",
    `DST_offset` DECIMAL(3,1)          COMMENT "Daylight Savings Time offset",
`raw_offset` DECIMAL(3,1)              COMMENT "Raw Offset (independent of DST)"
) CHARACTER SET utf8mb4;


DROP TABLE IF EXISTS  `userTags`;
CREATE TABLE  `userTags` (
    `geonameid` INT UNSIGNED           COMMENT "Integer id of record in geonames database",
    `tag` VARCHAR(20)                  COMMENT "User Tag"
) CHARACTER SET utf8mb4;
