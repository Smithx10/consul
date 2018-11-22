#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

goss_ver=""
goss_url=""

# set goss vars
setGossVar() {
  goss_ver=${GOSS_VER:-0.3.6}
  goss_url=https://github.com/aelsabbahy/goss/releases/download/v${goss_ver}/goss-linux-amd64
}

# install goss
installGoss() {
  _log "Installing goss with the following env vars:"
  _log "goss_ver=${goss_ver}"
  _log "goss_url=${goss_url}"
  curl -Ls --fail -o /usr/local/bin/goss ${goss_url} \
      && chmod +x /usr/local/bin/goss
}

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

main() {
  setHttpProxy
  setGossVar
  installGoss
  installGossConfiguration
}
main
