USE geonames;

CREATE INDEX idx_geoname_id
  ON alternateNames(geonameid, isPreferredName);

CREATE INDEX idx_isolanguage
  ON alternateNames(isoLanguage);

CREATE INDEX idx_code
  ON admin1Codes(code);

CREATE UNIQUE INDEX ux_geoname_id
  ON admin1Codes(geonameid);

CREATE INDEX idx_code
  ON admin2Codes(code);

CREATE UNIQUE INDEX ux_geoname_id
  ON admin2Codes(geonameid);

CREATE UNIQUE INDEX ux_admin5_code
  ON admin5Codes(geonameid, code);

CREATE UNIQUE INDEX ux_code
  ON featureCodes(code);

CREATE UNIQUE INDEX ux_code
  ON continentCodes(code);

CREATE INDEX idx_iso_alpha2
  ON countryInfo(iso_alpha2);

CREATE INDEX idx_iso_alpha3
  ON countryInfo(iso_alpha3);

CREATE INDEX idx_iso_numeric
  ON countryInfo(iso_numeric);

CREATE INDEX idx_continent
  ON countryInfo(continent);

CREATE INDEX idx_geoname_id
  ON countryInfo(geonameId);

CREATE UNIQUE INDEX ux_geoname_id
  ON geoName(geonameid);

CREATE INDEX idx_country
  ON geoName(country);

CREATE INDEX idx_timezone
  ON geoName(timezone);

CREATE INDEX idx_fclass
  ON geoName(fclass);

CREATE INDEX idx_admin1
  ON geoName(admin1);

CREATE INDEX idx_admin2
  ON geoName(admin2);

CREATE INDEX idx_latitude_longitude
  ON geoName(latitude, longitude);

CREATE UNIQUE INDEX ux_hierarchy
  ON hierarchy(type, childId, parentId);

CREATE INDEX idx_iso639_2
  ON isoLanguages(iso639_2);

CREATE INDEX idx_latitude_longitude
  ON noCountry(latitude, longitude);

CREATE UNIQUE INDEX ux_geoname_id
  ON noCountry(geonameId);

CREATE INDEX idx_timezone
  ON noCountry(timezone);

CREATE UNIQUE INDEX ux_geonameid
  ON shapes(geonameid);

CREATE INDEX ux_timezone_id
  ON timeZones(timeZoneId);

CREATE INDEX idx_geoname_id
  ON userTags(geonameid);
