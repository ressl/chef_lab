#!/usr/bin/env bash
localedef -v -c -i en_US -f UTF-8 en_US.UTF-8

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.10  chef-server
10.0.15.15  lb
10.0.15.22  web1
10.0.15.23  web2
EOL
