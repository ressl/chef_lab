#!/usr/bin/env bash
localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
if [[ -f /etc/debian_version ]]; then
  dpkg -i /tmp/chef_13.7.16-1_amd64.deb
else
  rpm -Uvh  /tmp/chef-13.7.16-1.el7.x86_64.rpm
fi

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.10  chef-server
10.0.15.21  web1
10.0.15.22  web2
EOL
