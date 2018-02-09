#!/usr/bin/env bash

# debug
# set -x

vagrant() {
  vagrant destroy -f
}

main() {
  vagrant
}

main "${@}"
