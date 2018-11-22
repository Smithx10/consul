#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

jq_ver=""
jq_sha256=""
jq_url=""

# set jq vars
setJqVar() {
  jq_ver=${JQ_VER:-1.5}
  jq_sha256=c6b3a7d7d3e7b70c6f51b706a3b90bd01833846c54d32ca32f0027f00226ff6d
  jq_url=https://github.com/stedolan/jq/releases/download/jq-${jq_ver}/jq-linux64
}

# install jq
installJq() {
    _log "Installing jq with the following env vars:"
    _log "jq_ver: ${jq_ver}"
    _log "jq_sha256: ${jq_sha256}"
    _log "jq_url: ${jq_url}"
    curl -Ls --fail -o /usr/local/bin/jq ${jq_url} \
        && echo "${jq_sha256} /usr/local/bin/jq" | sha256sum -c \
        && chmod +x /usr/local/bin/jq
}

main() {
  setHttpProxy
  setJqVar
  installJq
}
main


