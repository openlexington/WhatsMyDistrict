# What's My District?

See an example at [whatsmydistrict.org](http://whatsmydistrict.org/).

## Requirements

- Ruby 1.9.3
- postgresql -- `brew install postgres`
- postgis -- `brew install postgis`

## To get started:

1. `bundle`
2. `puma` to start the server at [localhost:9292](http://localhost:9292/).
3. For a new postgresql install in OS X:

        mkdir -p ~/Library/LaunchAgents
        cp /usr/local/Cellar/postgresql/9.2.1/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
        initdb /usr/local/var/postgres -E utf8
        pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

    See also [Postgres.app](http://postgresapp.com/).
4. Create the database: `createdb -p 5432 -h localhost blake`

## To update the database:

1. Download the new shape file from [data.lexingtonky.gov](http://data.lexingtonky.gov) -- for example, under Community, [Board of Elections - Voting Precincts](https://opendatalex.s3.amazonaws.com/2013-03-21T200744/VotingPrecinct.zip).
2. Run `shp2pgsql -c -D -s 4269 -I shapefile.shp tablename > filename.sql`. For example:

        $ shp2pgsql -c -D -s 4269 -I VotingPrecinct.shp voting > VotingPrecinct.sql
        Shapefile type: Polygon
        Postgis type: MULTIPOLYGON[2]

3. In psql, drop the table you will be updating.
4. Run `psql -d database -f file.sql`, for example `psql -p 5432 -h localhost -d blake -f VotingPrecinct.sql`.
