FROM stackbrew/ubuntu:trusty

MAINTAINER OpenLexington <ops@openlexington.org>

RUN apt-get update

# create /var/www
# add district app files to /var/www/WhatsMyDistrict

# install pg dependencies
# install pg
# install postgis
# create DB
# add DB user

# add sql files to postgres: `psql -p 5432 -h 127.0.0.1 -d districts -f VotingPrecinct.sql`

# add brightbox ppa for ruby 2.2
# install ruby dependencies
# install ruby 2.2
# bundle gems

# install nginx
# configure nginx

# install runit/monit/init script for running unicorn


EXPOSE 80
