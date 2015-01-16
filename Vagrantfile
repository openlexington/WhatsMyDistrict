# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.define 'district' do |app|
    app.vm.box = 'ubuntu/trusty64'

    app.vm.provider 'virtualbox' do |v|
      v.memory = 1024
      v.name = 'district'
    end

    app.ssh.forward_agent = true
    app.vm.network :forwarded_port, guest: 4567, host: 4567

    app.vm.synced_folder './', '/home/vagrant/WhatsMyDistrict'

    app.berkshelf.enabled = true

    app.vm.provision :chef_solo do |chef|
      chef.log_level = :debug
      chef.custom_config_path = 'chef_solo.config'
      chef.run_list = ['whatsmydistrict::default']
    end
  end
end
