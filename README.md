# Amazon Redshift Utilities

This repo contains a Docker container plus the [Amazon Redshift Utilities](https://github.com/influitive/amazon-redshift-utils) written in python
that will let us run period and one-off optimizations for our Redshift database.

The two optimizations mostly run are the:
1. Analyze & Vacuum Utility
2. Column Encoding Utility

See [here](https://blogs.aws.amazon.com/bigdata/post/Tx31034QG0G3ED1/Top-10-Performance-Tuning-Techniques-for-Amazon-Redshift) for more details on optimizing redshift.


## Analyze & Vacuum

This is a nightly job that is run across all tables by analyzing how much skew the
db has occurred through ETL tasks. It will VACUUM and ANALYZE appropriately only
on tables that need it.

**Requirements**

1. Needs a $REDSHIFT_URL env var to exist pointing to the redshift db

**Usage**

docker run amazon-redshift-utils ./redshift-analyze.sh

## Column Encoding Utility

This job can be run ad-hoc to determine what columns should be encoded for better
column compression. Note that AWS itself doesn't recommend running this on production
(I'm not sure why) but it *will* do an in place replacement of your
table with proper column encodings set. It seems like this would be fine to run
IMO, but we'll have to experiment.

**Requirements**

1. Needs a $REDSHIFT_URL env var to exist pointing to the redshift db
2. This script can't be automated, it requires some user interaction, and rightfully so

**Usage**

docker run amazon-redshift-utils ./redshift-encode.sh

**WARNING!!!**

Running the column encoding utility will change permissions on tables. This
shell script will do a GRANT for the looker role, since that's all we need,
but if other permissions are needed you'll have to add that in yourself.
