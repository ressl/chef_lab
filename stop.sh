#!/usr/bin/env bash

# debug
# set -x

chef_vagrant() {
  vagrant destroy -f
}

main() {
  chef_vagrant
}

main "${@}"
