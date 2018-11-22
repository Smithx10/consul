#!/bin/bash
set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

copyFiles() {
  if assertTriton; then
    _log "Copying the files for ntpd"
    cp ${PROVISION_DIR}/etc/ntp-onprem.conf /etc/ntp.conf
  fi
}

main() {
  copyFiles
}
main
