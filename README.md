# What's My District?

## Requirements

- ruby 1.9.3
- postgresql
- postgis


## To update the database:
1. Download the new shape file from [data.lexingtonky.gov](http://data.lexingtonky.gov)
2. Run `shp2pgsql -c -D -s 4269 -I shapefile.shp tablename > filename.sql`
3. In psql drop the table you will be updating
4. Run `psql -d database -f file.sql`
