#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

installCommonAppInit() {
  _log "Installing & configuring common-app-init script ..."
  cp ${PROVISION_DIR}/bin/common-app-init /usr/local/bin/common-app-init \
    && chmod +x /usr/local/bin/common-app-init
  cp ${PROVISION_DIR}/etc/common-app-init.service /etc/systemd/system/common-app-init.service
}

enableCommonAppInit() {
  _log "Enabling common-app-init with 'systemctl enable common-app-init'"
  systemctl enable common-app-init
}

main () {
  if ! assertDocker; then
    installCommonAppInit
    enableCommonAppInit
  fi
}
main
