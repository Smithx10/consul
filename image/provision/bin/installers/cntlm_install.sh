#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

# Install cntlm package
installCntlm() {
  _log  "Installing cntlm package"
  yum install -y cntlm
}

# Copy cntlm configuration template
copyCntlmConfig() {
  _log  "Copying cntlm config file"
  cp ${PROVISION_DIR}/etc/cntlm.conf.ctmpl /etc/cntlm.conf.ctmpl
}

main() {
  setHttpProxy
  if assertAWS; then
    _log "Skipping install of CNTLM"
  fi
  if assertTriton; then
    _log "Skipping install of CNTLM"
  fi
  if assertVsphere; then
    installCntlm
    copyCntlmConfig
  fi
}
main
