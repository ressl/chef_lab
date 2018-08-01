#!/usr/bin/env bash

# debug
# set -x
declare -r LABHOME=$(pwd)

chef_download() {
  # download packages
  wget -c -P ${LABHOME}/packages 'https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/16.04/chef-server-core_12.17.33-1_amd64.deb'
  wget -c -P ${LABHOME}/packages 'https://packages.chef.io/files/stable/chef/14.3.37/ubuntu/18.04/chef_14.3.37-1_amd64.deb'
  wget -c -P ${LABHOME}/packages 'https://packages.chef.io/files/stable/chef/14.3.37/el/7/chef-14.3.37-1.el7.x86_64.rpm'
}

chef_vagrant() {
  # bring vms up
  vagrant up
  
  # copy chef environment to home
  vagrant scp chef_server:/home/vagrant/chef "${LABHOME}"/
  
  # fetch ssl cert
  cd "${LABHOME}"/chef || return
  knife ssl fetch
  
  # show status of vms
  cd "${LABHOME}" || return
  vagrant status
}

main() {
  chef_download
  chef_vagrant
}

main "${@}"
