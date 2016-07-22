#!/bin/bash

# parses out $REDSHIFT_URL into its parts and calls the AWS encode util script

# See http://stackoverflow.com/a/34447808
FIELDS=($(echo $REDSHIFT_URL | awk '{split($0, arr, /[\/\@:]*/); for (x in arr) { print arr[x] }}'))

user=${FIELDS[1]}
pass=${FIELDS[2]}
host=${FIELDS[3]}
port=${FIELDS[4]}
db=${FIELDS[5]}

python src/ColumnEncodingUtility/analyze-schema-compression.py \
  --db $db \
  --db-user $user \
  --db-host $host \
  --db-port $port \
  --analyze-schema public \
  --comprows 100000 \
  --slot-count 5 \
  --do-execute true \
  --drop-old-data true \
  --output-file /usr/src/app/log/encode.log

PGPASSWORD=$pass psql -h $host -U $user -p $port -d $db -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO looker;"
