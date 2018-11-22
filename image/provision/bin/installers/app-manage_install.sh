#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

copyFiles() {
  _log "Copying the files for app-manage"
  cp ${PROVISION_DIR}/bin/app-manage /usr/local/bin/app-manage \
    && chmod +x /usr/local/bin/app-manage
}

main() {
  copyFiles
}
main
