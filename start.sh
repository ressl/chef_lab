#!/usr/bin/env bash

declare -r LABHOME
LABHOME=$(pwd)

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
