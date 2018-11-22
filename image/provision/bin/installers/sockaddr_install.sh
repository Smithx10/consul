#!/bin/bash
set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

sockaddr_pkg=""
sockaddr_sha256=""
sockaddr_url=""

# Set Environment Variables
setSuVar() {
  sockaddr_pkg=sockaddr
  sockaddr_sha256=2d2787de9ba8099a444a5e6db516d192e9e2a972d21ee6ad633dbddf80a4c844
  sockaddr_url=https://s3-eu-west-1.amazonaws.com/iac-bins/sockaddr
}

# Install SockAddr
installSockAddr() {
    _log "Installing sockaddr with the following env vars:"
    _log "sockaddr_pkg: ${sockaddr_pkg}"
    _log "sockaddrsha256: ${sockaddr_sha256}"
    _log "sockaddr_url: ${sockaddr_url}"
    curl -Ls --fail -o /usr/local/bin/${sockaddr_pkg} ${sockaddr_url} \
        && echo "${sockaddr_sha256} /usr/local/bin/${sockaddr_pkg}" | sha256sum -c \
        && chmod +x /usr/local/bin/${sockaddr_pkg}
}

main() {
  setHttpProxy
  setSuVar
  installSockAddr
}
main
