#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

cp_ver=""
cp_pkg=""
cp_sha1=""
cp_url=""

# Set containerpilot vars
setCpVar() {
  cp_ver=${CP_VER:-3.8.1}
  cp_pkg=containerpilot-${cp_ver}.tar.gz
  cp_sha1=$(curl -L https://github.com/Smithx10/containerpilot/releases/download/${cp_ver}/containerpilot-${cp_ver}.sha1.txt | awk '{print $1}')
  cp_url=https://github.com/Smithx10/containerpilot/releases/download/${cp_ver}/${cp_pkg}
}

# Install containerpilot
installCp() {
    _log "Installing cp with the following env vars:"
    _log "cp_ver: ${cp_ver}"
    _log "cp_pkg: ${cp_pkg}"
    _log "cpsha1: ${cp_sha1}"
    _log "cp_url: ${cp_url}"
    curl -Ls --fail -o /tmp/${cp_pkg} ${cp_url} \
        && echo "${cp_sha1} /tmp/${cp_pkg}" | sha1sum -c \
        && tar zxf /tmp/${cp_pkg} -C /usr/local/bin \
        && rm /tmp/${cp_pkg} \
        && mkdir -p /var/containerpilot
}

# Setup containerpilot service if its a vm
setupCpSystemD() {
    _log "Checking if we are in docker or vm..."
    if ! grep docker /proc/1/cgroup -qa; then
        _log "In the VM copying containerpilot.service"
        cp ${PROVISION_DIR}/etc/containerpilot.service /etc/systemd/system/containerpilot.service
        enableCpSystemD
    else
        _log "Not in a VM we don't need to copy containerpilot.service"
    fi
}

# Enable containerpilot at startup
enableCpSystemD(){
    _log "Enabling containerpilot.service"
    systemctl enable containerpilot
}

copyFiles() {
  cp ${PROVISION_DIR}/etc/containerpilot.json5 /etc
}

main() {
  setHttpProxy
  setCpVar
  installCp
  copyFiles
  setupCpSystemD
}
main
