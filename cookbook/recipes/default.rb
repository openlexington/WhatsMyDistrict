#
# Cookbook Name:: whatsmydistrict
# Recipe:: default
#

package 'software-properties-common'
execute 'add-apt-repository --yes ppa:brightbox/ruby-ng'

node.set['build-essential']['compile_time'] = true

include_recipe 'apt'
include_recipe 'annoyances'
include_recipe 'build-essential'
include_recipe 'postgresql::ruby'
include_recipe 'postgresql::client'
include_recipe 'git'

package 'libxml2-dev' do
  action :install
end

package 'libxslt1-dev' do
  action :install
end

package 'nodejs'
package 'npm'

link '/usr/bin/node' do
  to '/usr/bin/nodejs'
end

node.set['authorization']['sudo']['groups'] = ['sudo', 'admin', 'sysadmin']
node.set['authorization']['sudo']['passwordless'] = true
node.set['authorization']['sudo']['include_sudoers_d'] = true
node.set['authorization']['sudo']['sudoers_defaults'] = [
  'env_reset',
  'mail_badpass',
  'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
]

sudo 'vagrant' do
  user 'vagrant'
  runas 'ALL:ALL'
  nopasswd true
end

include_recipe 'sudo'

package 'ruby2.1'
package 'ruby2.1-dev'
package 'libruby2.1'

gem_package 'bundler' do
  version '1.6.3'
end

package 'libcurl4-openssl-dev' do
  action :install
end


# database
########################################

include_recipe 'database::postgresql'
package 'postgresql-9.3-postgis-2.1'

execute 'enable postgis in template1' do
  user 'postgres'
  command 'echo "CREATE EXTENSION IF NOT EXISTS postgis;" | psql -d template1'
end

execute "enable postgis on whatsmydistrict" do
  user 'postgres'
  command 'echo "CREATE EXTENSION IF NOT EXISTS postgis;" ' +
          "| psql -d whatsmydistrict"
end

# application
########################################

execute 'copy dotenv.sample to .env' do
  cwd '/home/vagrant/WhatsMyDistrict'
  user 'vagrant'
  environment 'HOME' => '/home/vagrant'
  command 'cp dotenv.sample .env'
  not_if { ::File.exists?('/home/vagrant/WhatsMyDistrict/.env') }
end

execute 'bundle install' do
  command <<-EOL
    bundle install
  EOL
  cwd '/home/vagrant/WhatsMyDistrict'
  user 'vagrant'
  environment 'HOME' => '/home/vagrant'
end
