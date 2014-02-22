# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_plugin 'vagrant-berkshelf'
Vagrant.require_plugin 'vagrant-omnibus'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  config.vm.define 'district' do |district|
    district.vm.box = 'precise64virtualbox'
    district.vm.box_url = 'http://files.vagrantup.com/precise64.box'

    district.ssh.forward_agent = true
    district.vm.network :forwarded_port, guest: 4567, host: 4567

    district.vm.synced_folder '../WhatsMyDistrict', '/home/vagrant/WhatsMyDistrict'

    district.berkshelf.enabled = true
    district.berkshelf.berksfile_path = File.expand_path(File.join('..','Berksfile'), __FILE__)

    district.omnibus.chef_version = :latest
    district.vm.provision :chef_solo do |chef|
      chef.add_recipe 'annoyances'
      chef.add_recipe 'build-essential'
      chef.add_recipe 'vim'
      chef.add_recipe 'git'
      chef.add_recipe 'tmux'
      chef.add_recipe 'imagemagick'
      chef.add_recipe 'postgresql'
      chef.add_recipe 'postgis::default'
      chef.add_recipe 'rvm::system'
      chef.json = {
                    postgresql: {version: '9.1',
                                 password: {postgres: 'sorandomwow'},
                                 pg_hba: [{type: 'host', db: 'all',
                                   user: 'postgres', addr: '127.0.0.1/32',
                                   method: 'trust'},
                                   {type: 'local', db: 'all',
                                   user: 'postgres', addr: nil,
                                   method: 'trust'}]
                                },
                    postgis: {template_name: 'blake'},
                    rvm: {rubies: ['1.9.3'], default_ruby: 'ruby-1.9.3-p484',
                          code: 'rvm use 1.9.3',
                          global_gems: [{name: 'rake'}, {name: 'bundler'}]}
                  }
    end
  end
end
