#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

suexec_pkg=""
suexec_sha256=""
suexec_url=""

# Set Environment Variables
setSuVar() {
  suexec_pkg=su-exec
  suexec_sha256=f04b87ea287f6beb9a9c026870922395671faed0d1f5f579bda9fe47e54696d6
  suexec_url=https://s3-eu-west-1.amazonaws.com/iac-bins/su-exec
}

# Install Su-Exec
installSuExec() {
    _log "Installing suexec with the following env vars:"
    _log "suexec_pkg: ${suexec_pkg}"
    _log "suexecsha256: ${suexec_sha256}"
    _log "suexec_url: ${suexec_url}"
    curl -Ls --fail -o /usr/local/bin/${suexec_pkg} ${suexec_url} \
        && echo "${suexec_sha256} /usr/local/bin/${suexec_pkg}" | sha256sum -c \
        && chmod +x /usr/local/bin/${suexec_pkg}
}

main() {
  setHttpProxy
  setSuVar
  installSuExec
}
main
