#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

ct_ver=""
ct_pkg=""
ct_url=""
ct_sha256=""

# Set ct env vars
setConsulTemplateVar() {
  ct_ver=${CT_VER:-0.19.5}
  ct_pkg=consul-template_${ct_ver}_linux_amd64.zip
  ct_url=https://releases.hashicorp.com/consul-template/${ct_ver}/${ct_pkg}
  ct_sha256=$(curl -Ls --fail https://releases.hashicorp.com/consul-template/${ct_ver}/consul-template_${ct_ver}_SHA256SUMS | grep ${ct_pkg} | awk '{print $1}')
}

# Install ct
installConsulTemplate() {
  _log "Attemping to install ConsulTemplate ..."
  _log "ct_ver=${ct_ver}"
  _log "ct_pkg=${ct_pkg}"
  _log "ct_url=${ct_url}"
  _log "ct_sha256=${ct_sha256}"
  curl -ls --fail -o /tmp/${ct_pkg} ${ct_url} \
      && echo "${ct_sha256} /tmp/${ct_pkg}" | sha256sum -c \
      && unzip /tmp/${ct_pkg} -d /usr/local/bin \
      && rm /tmp/${ct_pkg}
}

main() {
  setHttpProxy
  setConsulTemplateVar
  installConsulTemplate
}
main
