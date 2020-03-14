#!bin/bash

if [ $# -ne 2 ]; then
    echo "$0: usage: $0 <username> <password>"
    exit 1
fi

username="$1"
password="$2"

DATA_DIRECTORY='tmp'

mkdir -p "$DATA_DIRECTORY"

wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/allCountries.zip
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/alternateNamesV2.zip
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/adminCode5.zip
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/cities500.zip
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/hierarchy.zip
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/userTags.zip
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/admin1CodesASCII.txt
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/admin2Codes.txt
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/iso-languagecodes.txt
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/featureCodes_en.txt
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/timeZones.txt
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/countryInfo.txt
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/no-country.zip
wget --directory-prefix="$DATA_DIRECTORY" http://download.geonames.org/export/dump/shapes_all_low.zip


unzip "$DATA_DIRECTORY/allCountries.zip" -d "$DATA_DIRECTORY"
unzip "$DATA_DIRECTORY/alternateNamesV2.zip" -d "$DATA_DIRECTORY"
unzip "$DATA_DIRECTORY/adminCode5.zip" -d "$DATA_DIRECTORY"
unzip "$DATA_DIRECTORY/cities500.zip" -d "$DATA_DIRECTORY"
unzip "$DATA_DIRECTORY/hierarchy.zip" -d "$DATA_DIRECTORY"
unzip "$DATA_DIRECTORY/userTags.zip" -d "$DATA_DIRECTORY"
unzip "$DATA_DIRECTORY/no-country.zip" -d "$DATA_DIRECTORY"
unzip "$DATA_DIRECTORY/shapes_all_low.zip" -d "$DATA_DIRECTORY"

cat "$DATA_DIRECTORY/countryInfo.txt" | grep -v "^#" > "$DATA_DIRECTORY/countryInfo-n.txt"


echo "Uploading data to geonames database"
mysql -u "$username" -p"$password" geonames < import.sql

echo "Applying indices"
mysql -u "$username" -p"$password" geonames < index.sql

echo "Applying foreign keys"
mysql -u "$username" -p"$password" geonames < foreign.sql

rm -r "$DATA_DIRECTORY"
