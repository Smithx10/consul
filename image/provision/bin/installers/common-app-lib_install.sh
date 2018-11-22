#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

copyFiles() {
  _log "Copying the lib directory"
  mkdir -p /usr/local/lib \
    && cp ${PROVISION_DIR}/lib/* /usr/local/lib
}

main() {
  copyFiles
}
main
