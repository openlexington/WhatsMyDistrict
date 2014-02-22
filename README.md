# What's My District?

See an example at [whatsmydistrict.org](http://whatsmydistrict.org/).

## Requirements

- Ruby 1.9.3
- postgresql -- `brew install postgres`
- postgis -- `brew install postgis`

## To get started:

Clone this repository. The rest of the commands should happen in the directory
containing this project.

### Vagrant

1. [Download](https://www.virtualbox.org/wiki/Downloads) & Install Virtualbox
2. [Download](http://www.vagrantup.com/) & Install Vagrant
3. `vagrant plugin install vagrant-berkshelf`
4. `vagrant plugin install vagrant-omnibus`
5. `vagrant up`
6. `vagrant ssh`
7. `cd WhatsMyDistrict`
8. `sudo bundle install`
9. `psql -U postgres`
10. `create database districts;`
11. `\q`
12. `psql -U postgres -d districts < sql/wmd.sql`
13. `foreman start`
14. Open browser to [http://localhost:4567](http://localhost:4567)
15. Hack

### MacOS X

1. `bundle`
2. `puma` to start the server at [localhost:9292](http://localhost:9292/).
3. For a new postgresql install in OS X:

        mkdir -p ~/Library/LaunchAgents
        cp /usr/local/Cellar/postgresql/9.2.1/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
        initdb /usr/local/var/postgres -E utf8
        pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

    See also [Postgres.app](http://postgresapp.com/).
4. Create the database: `createdb -p 5432 -h localhost districts`
5. Add necessary postgis functions to the database: `psql -p 5432 -h localhost -d districts -f /usr/local/share/postgis/postgis.sql` and `psql -p 5432 -h localhost -d districts -f /usr/local/share/postgis/spatial_ref_sys.sql` -- thanks to [PostGres - PostGIS on OS X Lion](http://lukeberndt.com/2011/postgres-postgis-on-osx-lion/).

### Linux (Ubuntu-based, no vagrant)

- `sudo apt-get install postgresql-9.1 postgresql-9.1-postgis postgis libpq`
- `bundle install`
- Create the database:
```
$ sudo -u postgres psql
# \password
  sorandomwow
  sorandomwow
# create database districts;
# \q
```
- Add PostGIS extensions:
```
postgres psql -U postgres -d districts -f `pg_config --sharedir`/contrib/postgis-*/postgis.sql`
postgres psql -U postgres -d districts -f `pg_config --sharedir`/contrib/postgis-*/spatial_ref_sys.sql
```
- `psql -U postgres -d districts < sql/wmd.sql`
- `cp dotenv.sample .env`
- `foreman start`
- Open browser to [http://localhost:4567](http://localhost:4567).
- Hack.

## To update the database:

1. Download the new shape file from [data.lexingtonky.gov](http://data.lexingtonky.gov) -- for example, under Community, [Board of Elections - Voting Precincts](https://opendatalex.s3.amazonaws.com/2013-03-21T200744/VotingPrecinct.zip).
2. Run `shp2pgsql -c -D -s 4269 -I shapefile.shp tablename > filename.sql`. For example:

        $ shp2pgsql -c -D -s 4269 -I VotingPrecinct.shp voting > VotingPrecinct.sql
        Shapefile type: Polygon
        Postgis type: MULTIPOLYGON[2]

Another example:

        ~/Downloads/PostOffice
        % shp2pgsql -c -D -s 4269 -I PostOffice.shp post_office > PostOffice.sql
        Shapefile type: Point
        Postgis type: POINT[2]

3. In psql, drop the table you will be updating.
4. Run `psql -d database -f file.sql`, for example `psql -p 5432 -h localhost -d districts -f VotingPrecinct.sql`.
