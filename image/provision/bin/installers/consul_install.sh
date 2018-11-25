#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

consul_ver=""
consul_pkg=""
consul_url=""
consul_sha256=""

# Set variables for consul installation
setConsulVar() {
  _log "Set consul variables"
  consul_ver=${CONSUL_VER:-1.3.0}
  consul_pkg=consul_${consul_ver}_linux_amd64.zip
  consul_url=https://releases.hashicorp.com/consul/${consul_ver}/${consul_pkg}
  consul_sha256=$(curl https://releases.hashicorp.com/consul/${consul_ver}/consul_${consul_ver}_SHA256SUMS | grep linux_amd64 | awk '{print $1}')
}

# Install consul
installConsul() {
  _log "Installing Consul with the following env vars:"
  _log "consul_ver=${consul_ver}"
  _log "consul_pkg=${consul_pkg}"
  _log "consul_url=${consul_url}"
  _log "consul_sha256=${consul_sha256}"
  curl -Ls --fail -o /tmp/${consul_pkg} ${consul_url} \
      && echo "${consul_sha256} /tmp/${consul_pkg}" | sha256sum -c \
      && unzip /tmp/${consul_pkg} -d /usr/local/bin \
      && rm /tmp/${consul_pkg}

  if ! [[ -d /etc/consul ]]; then
      mkdir /etc/consul
  fi

  if ! [[ -d /var/lib/consul ]]; then
      mkdir /var/lib/consul
  fi

  if ! [[ -d /data ]]; then
      mkdir /data
  fi
}

# Copy configuration files to the system
copyFiles() {
  cp ${PROVISION_DIR}/etc/consul.json /etc/consul/consul.json
  cp ${PROVISION_DIR}/bin/consul-manage /usr/local/bin/consul-manage
}

main() {
  setHttpProxy
  setConsulVar
  installConsul
  copyFiles
}
main

