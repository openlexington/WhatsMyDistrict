#
# Cookbook Name:: whatsmydistrict
# Recipe:: development
#

include_recipe 'whatsmydistrict::default'
include_recipe 'whatsmydistrict::local_database'

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
