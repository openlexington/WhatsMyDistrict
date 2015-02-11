#
# Cookbook Name:: whatsmydistrict
# Recipe:: local_database
#

node.set['postgresql']['password']['postgres'] = 'password'

include_recipe 'postgresql::server'
include_recipe 'database::postgresql'
package 'postgresql-9.3-postgis-2.1'

default_connection = {username: 'postgres', host: 'localhost'}

postgresql_database_user 'whatsmydistrict' do
  password 'whatsmydistrict'
  connection default_connection
  action :create
end

postgresql_database 'whatsmydistrict' do
  owner 'whatsmydistrict'
  connection default_connection
  action :create
end

postgresql_database_user 'whatsmydistrict' do
  database_name 'whatsmydistrict'
  privileges [:all]
  connection default_connection
  action :grant
end

execute 'enable postgis in template1' do
  user 'postgres'
  command 'echo "CREATE EXTENSION IF NOT EXISTS postgis;" | psql -d template1'
end

execute 'enable postgis on whatsmydistrict' do
  user 'postgres'
  command 'echo "CREATE EXTENSION IF NOT EXISTS postgis;" ' +
          '| psql -d whatsmydistrict'
end

