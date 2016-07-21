#!/bin/bash

# parses out $REDSHIFT_URL into its parts and calls the AWS analyze util script

# See http://stackoverflow.com/a/34447808
FIELDS=($(echo $REDSHIFT_URL | awk '{split($0, arr, /[\/\@:]*/); for (x in arr) { print arr[x] }}'))

user=${FIELDS[1]}
pass=${FIELDS[2]}
host=${FIELDS[3]}
db=${FIELDS[5]} # port is FIELDS[4]

python src/AnalyzeVacuumUtility/analyze-vacuum-schema.py \
  --db $db \
  --db-user $user \
  --db-pwd $pass \
  --db-host $host \
  --output-file /usr/src/app/log/analyze.log
