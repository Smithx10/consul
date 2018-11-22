#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

node_exporter_ver=""
node_exporter_name=""
node_exporter_pkg=""
node_exporter_url=""
node_exporter_sha256=""

# set node_exporter vars
setNodeExporterVar() {
  node_exporter_ver=${NODE_EXPORTER_VER:-0.16.0}
  node_exporter_name=node_exporter-${node_exporter_ver}.linux-amd64
  node_exporter_pkg=${node_exporter_name}.tar.gz
  node_exporter_url=https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_ver}/${node_exporter_pkg}
  node_exporter_sha256=$(curl -L https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_ver}/sha256sums.txt | grep ${node_exporter_pkg} | awk '{print $1}')
}

# install node_exporter
installNodeExporter() {
    _log "Installing node_exporter with the following env vars:"
    _log "node_exporter_ver: ${node_exporter_ver}"
    _log "node_exporter_name: ${node_exporter_name}"
    _log "node_exporter_pkg: ${node_exporter_pkg}"
    _log "node_exporter_url: ${node_exporter_url}"
    _log "node_exporter_sha256: ${node_exporter_sha256}"
    curl -Ls --fail -o /tmp/${node_exporter_pkg} ${node_exporter_url} \
        && echo "${node_exporter_sha256} /tmp/${node_exporter_pkg}" | sha256sum -c \
        && tar zxf /tmp/${node_exporter_pkg} -C /tmp \
        && mv /tmp/${node_exporter_name}/node_exporter /usr/local/bin \
        && chmod +x /usr/local/bin/node_exporter \
        && rm /tmp/${node_exporter_pkg} \
        && rm -rf /tmp/${node_exporter_name}
}


main () {
  setHttpProxy
  setNodeExporterVar
  installNodeExporter
}

main
