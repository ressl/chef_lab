# Install required Vagrant plugins
missing_plugins_installed = false
required_plugins = %w(vagrant-cachier vagrant-hostsupdater)

required_plugins.each do |plugin|
  if !Vagrant.has_plugin? plugin
    system "vagrant plugin install #{plugin}"
    missing_plugins_installed = true
  end
end

# If any plugins were missing and have been installed, re-run vagrant
if missing_plugins_installed
  exec "vagrant #{ARGV.join(" ")}"
end

Vagrant.configure(2) do |config|
  
  config.vm.define :mgmt do |chef_server_config|
      chef_server_config.vm.box = "ubuntu/trusty64"
      chef_server_config.vm.hostname = "chef-server"
      chef_server_config.vm.network :private_network, ip: "10.0.15.10"
      chef_server_config.vm.network "forwarded_port", guest: 80, host: 8070
      chef_server_config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"
      end
      chef_server_config.vm.provision :shell, path: "provision/bootstrap.sh"
  end

  config.vm.define :chef_dev do |chef_dev|
      chef_dev.vm.box = "ubuntu/trusty64"
      chef_dev.vm.hostname = "chef-dev"
      chef_dev.vm.network :private_network, ip: "10.0.15.11"
      chef_dev.vm.network "forwarded_port", guest: 80, host: 8081
      chef_dev.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
  end

  (2..3).each do |i|
    config.vm.define "web#{i}" do |node|
        node.vm.box = "ubuntu/trusty64"
        node.vm.hostname = "web#{i}"
        node.vm.network :private_network, ip: "10.0.15.2#{i}"
        node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "256"
        end
    end
  end

end
