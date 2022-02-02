USE `geonames`;

LOAD DATA LOCAL INFILE 'tmp/cities500.txt'
    INTO TABLE `geoName`
    (`geonameid`, `name`, `asciiname`, `alternatenames`, `latitude`, `longitude`,
     `fclass`, `fcode`, `country`, `cc2`, `admin1`, `admin2`, `admin3`, `admin4`,
     `population`, `elevation`, `dem`, `timezone`, `moddate`);

LOAD DATA LOCAL INFILE 'tmp/alternateNamesV2.txt'
    INTO TABLE `alternateNames`
    (`alternatenameid`, `geonameid`, `isoLanguage`, `alternateName`,
     `isPreferredName`, `isShortName`, `isColloquial`, `isHistoric`);

LOAD DATA LOCAL INFILE 'tmp/admin1CodesASCII.txt'
    INTO TABLE `admin1Codes`
    (`code`, `name`, `nameAscii`, `geonameid`);

LOAD DATA LOCAL INFILE 'tmp/admin2Codes.txt'
    INTO TABLE `admin2Codes`
    (`code`, `name`, `nameAscii`, `geonameid`);

LOAD DATA LOCAL INFILE 'tmp/adminCode5.txt'
    INTO TABLE `admin5Codes`
    (`code`, `geonameid`);

LOAD DATA LOCAL INFILE 'tmp/allCountries.txt'
    INTO TABLE `geoName`
    (`geonameid`, `name`, `asciiname`, `alternatenames`, `latitude`, `longitude`, `fclass`, `fcode`, `country`, `cc2`, `admin1`, `admin2`, `admin3`, `admin4`, `population`, `elevation`, `dem`, `timezone`, `moddate`);

LOAD DATA LOCAL INFILE 'continentCodes.txt'
    INTO TABLE `continentCodes`
    (`code`, `name`, `geonameid`);

LOAD DATA LOCAL INFILE 'tmp/countryInfo-n.txt'
    INTO TABLE `countryInfo`
    (`iso_alpha2`, `iso_alpha3`, `iso_numeric`, `fips_code`,
     `name`, `capital`, `areaInSqKm`, `population`, `continent`,
     `tld`, `currency`, `currencyName`, `phone`, `postalCodeFormat`,
     `postalCodeRegEx`, `languages`, `geonameId`, `neighbours`, `equivalentFipsCode`);


LOAD DATA LOCAL INFILE 'tmp/featureCodes_en.txt'
    INTO TABLE `featureCodes`
    (`code`,	`name`, `description`);


LOAD DATA LOCAL INFILE 'tmp/hierarchy.txt'
    INTO TABLE `hierarchy`
    (`parentId`, `childId`, `type`);


LOAD DATA LOCAL INFILE 'tmp/iso-languagecodes.txt'
    INTO TABLE `isoLanguages`
    (`iso639_3`, `iso639_2`, `iso639_1`, `languageName`);

LOAD DATA LOCAL INFILE 'tmp/no-country.txt'
    INTO TABLE `noCountry`
    (`geonameid`, `name`, `asciiname`, `alternatenames`, `latitude`, `longitude`,
     `fclass`, `fcode`, `country`, `cc2`, `admin1`, `admin2`, `admin3`, `admin4`,
     `population`, `elevation`, `gtopo30`, `timezone`, `moddate`);

LOAD DATA LOCAL INFILE 'tmp/shapes_all_low.txt'
    INTO TABLE `shapes`
    (`geonameid`, `geoJson`);

LOAD DATA LOCAL INFILE 'tmp/timeZones.txt'
    INTO TABLE `timeZones` IGNORE 1 LINES
    (`timeZoneId`, `GMT_offset`, `DST_offset`, `raw_offset`);

LOAD DATA LOCAL INFILE 'tmp/userTags.txt'
    INTO TABLE `userTags`
    (`geonameid`, `tag`);
