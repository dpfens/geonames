#!bin/bash

if [ $# -ne 2 ]; then
    echo "$0: usage: $0 <username> <password>"
    exit 1
fi

username="$1"
password="$2"

mysql -u "$username" -p"$password" < geonames.sql
