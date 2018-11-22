#!/bin/bash

set -euo pipefail

####################
#    VARIABLES     #
####################

# directory where provision materials are located
PROVISION_DIR="/tmp/provision"

####################
#    FUNCTIONS     #
####################

# install goss configuration
installGossConfiguration() {
  if [[ -f ${PROVISION_DIR}/etc/goss.yml ]]; then
    _log "Installing main goss configuration file"
    cp ${PROVISION_DIR}/etc/goss.yml /etc
  fi

  _log "Installing additional goss configuration files"
  mkdir -p /etc/goss.d
  cp ${PROVISION_DIR}/etc/*-goss-*.yml /etc/goss.d

  if [[ -f ${PROVISION_DIR}/etc/goss-vars.json ]]; then
    _log "Installing goss variable file"
    cp ${PROVISION_DIR}/etc/goss-vars.json /etc
  fi
}

# log
_log() {
  echo "    $(date -u '+%Y-%m-%d %H:%M:%S') goss_install: $@"
}

####################
#       MAIN       #
####################

main() {
  installGossConfiguration
}
main
