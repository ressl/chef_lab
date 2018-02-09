#!/usr/bin/env bash

# debug
# set -x
declare -r LABHOME
LABHOME=$(pwd)

chef_download() {
  # download packages
  wget -c -P ${LABHOME}/packages 'https://packages.chef.io/repos/apt/stable/ubuntu/16.04/chef-server-core_12.17.15-1_amd64.deb'
  wget -c -P ${LABHOME}/packages 'https://packages.chef.io/repos/apt/stable/ubuntu/16.04/chef_13.7.16-1_amd64.deb'
  wget -c -P ${LABHOME}/packages 'https://packages.chef.io/repos/yum/stable/el/7/x86_64/chef-13.7.16-1.el7.x86_64.rpm'
}

vagrant() {
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
  vagrant
}

main "${@}"
