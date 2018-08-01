# Install required Vagrant plugins
missing_plugins_installed = false
required_plugins = %w(vagrant-cachier vagrant-hostsupdater vagrant-scp)

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
  
  config.vm.define :chef_server do |chef_server|
      chef_server.vm.box = "ubuntu/xenial64"
      chef_server.vm.hostname = "chef-server"
      chef_server.vm.network :private_network, ip: "10.0.15.10"
      chef_server.vm.network "forwarded_port", guest: 443, host: 8443
      chef_server.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
      end
      chef_server.vm.provision "file", source: "packages/chef-server-core_12.17.33-1_amd64.deb", destination: "/tmp/chef-server-core_12.17.33-1_amd64.deb"
      chef_server.vm.provision :shell, path: "provision/chef-server.sh"
  end

  config.vm.define "web1" do |node|
    node.vm.box = "bento/centos-7.5"
    node.vm.hostname = "web1"
    node.vm.network :private_network, ip: "10.0.15.21"
    node.vm.network "forwarded_port", guest: 80, host: "8081"
    node.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    node.vm.provision "file", source: "packages/chef-14.3.37-1.el7.x86_64.rpm", destination: "/tmp/chef-14.3.37-1.el7.x86_64.rpm"
    node.vm.provision :shell, path: "provision/nodes.sh"
  end

  config.vm.define "web2" do |node|
    node.vm.box = "bento/ubuntu-18.04"
    node.vm.hostname = "web2"
    node.vm.network :private_network, ip: "10.0.15.22"
    node.vm.network "forwarded_port", guest: 80, host: "8082"
    node.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    node.vm.provision "file", source: "packages/chef_14.3.37-1_amd64.deb", destination: "/tmp/chef_14.3.37-1_amd64.deb"
    node.vm.provision :shell, path: "provision/nodes.sh"
  end

end
