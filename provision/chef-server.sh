#!/usr/bin/env bash

#apt-get update -y -qq > /dev/null
#apt-get upgrade -y -qq > /dev/null

dpkg -i /tmp/chef-server-core_12.17.15-1_amd64.deb

mkdir -p /home/vagrant/chef/.chef/syntax_check_cache

chown -R vagrant:vagrant /home/vagrant

cat <<EOM >/home/vagrant/chef/.chef/knife.rb
current_dir =            File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "cheflab"
client_key               "#{current_dir}/cheflab_user.pem"
chef_server_url          'https://chef-server/organizations/cheflaborg'
cookbook_path            "#{current_dir}/../cookbooks"
syntax_check_cache_path  "#{current_dir}/syntax_check_cache"
knife[:editor] =         'nvim'
EOM

chef-server-ctl reconfigure

chef-server-ctl user-create cheflab Chef Lab cheflab@cheflab.com setup23 --filename /home/vagrant/chef/.chef/cheflab_user.pem

chef-server-ctl org-create cheflaborg "Chef Lab AG" --association_user cheflab --filename /home/vagrant/chef/.chef/cheflab_org.pem

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.10  chef-server
10.0.15.15  lb
10.0.15.22  web1
10.0.15.23  web2
EOL

printf "\\033c"
echo "Chef is ready: https://chef-server/"
