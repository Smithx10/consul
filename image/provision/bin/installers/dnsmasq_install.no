#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

# Install dnsmasq package
installDnsmasq() {
  _log  "Installing dnsmasq package"
  yum install -y dnsmasq
}

copyFiles() {
  _log "Copying  files for DNSMASQ"
  mkdir -p /etc/dnsmasq.d \
   && cp ${PROVISION_DIR}/etc/10-consul.ctmpl /etc/dnsmasq.d
}

# Enable the dnsmasq service
enableDnsmasq() {
  _log "Enabling dnsmasq with 'systemctl enable dnsmasq'"
  systemctl enable dnsmasq
}

main() {
  setHttpProxy
  installDnsmasq
  copyFiles
  enableDnsmasq
}
main
