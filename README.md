# What's My District?

See an example at [whatsmydistrict.org](http://whatsmydistrict.org/).

## Requirements

- Ruby 1.9.3
- postgresql -- `brew install postgres`
- postgis -- `brew install postgis`

## To update the database:
1. Download the new shape file from [data.lexingtonky.gov](http://data.lexingtonky.gov) -- for example, under Community, [Board of Elections - Voting Precincts](https://opendatalex.s3.amazonaws.com/2013-03-21T200744/VotingPrecinct.zip).
2. Run `shp2pgsql -c -D -s 4269 -I shapefile.shp tablename > filename.sql`
3. In psql, drop the table you will be updating.
4. Run `psql -d database -f file.sql`
