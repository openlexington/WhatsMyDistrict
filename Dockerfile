FROM stackbrew/ubuntu:trusty

MAINTAINER OpenLexington <ops@openlexington.org>

RUN apt-get update

# install pg dependencies
# install pg
# install postgis
# create DB
# add DB user
# add all sql files to postgres

# install ruby dependencies
RUN apt-get install -y --force-yes build-essential wget git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
# add brightbox ppa for ruby 2.2
RUN apt-get install -y --force-yes software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
# install ruby 2.2
RUN apt-get install -y --force-yes ruby2.2
RUN apt-get clean

RUN gem update --system
RUN gem install bundler

RUN git clone https://github.com/openlexington/WhatsMyDistrict.git /var/www/WhatsMyDistrict
RUN cd /var/www/WhatsMyDistrict; bundle install

# i'd prefer to use shotgun+thin or puma, but nginx+unicorn is so often used
# install nginx
# configure nginx
# install init script for running unicorn
# or maybe default command to start unicorn

EXPOSE 80
