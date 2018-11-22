#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

copyFiles() {
  _log "Copying the files for ip-detect"
  cp ${PROVISION_DIR}/bin/ip-detect /usr/local/bin/ip-detect \
    && chmod +x /usr/local/bin/ip-detect
}

main () {
  copyFiles
}
main
