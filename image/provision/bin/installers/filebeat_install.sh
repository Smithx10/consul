#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

fb_ver=""
fb_name=""
fb_pkg=""
fb_url=""
fb_sha512=""
fb_home=""

# Set Filebeat Env Vars
setFilebeatVar() {
  fb_ver=${FB_VER:-6.3.0}
  fb_name=filebeat-${fb_ver}-linux-x86_64
  fb_pkg=${fb_name}.tar.gz
  fb_url=https://artifacts.elastic.co/downloads/beats/filebeat/${fb_pkg}
  fb_sha512=$(curl -sfL https://artifacts.elastic.co/downloads/beats/filebeat/${fb_pkg}.sha512 | cut -d" " -f1)
  fb_home=/usr/share/filebeat
}

# Install Filebeat
installFilebeat() {
  curl -ls --fail -o /tmp/${fb_pkg} ${fb_url} \
      && echo "${fb_sha512} /tmp/${fb_pkg}" | sha512sum -c \
      && tar zxvf /tmp/${fb_pkg} -C /tmp \
      && mkdir -p ${fb_home} \
      && mkdir -p ${fb_home}/prospectors \
      && mv /tmp/${fb_name}/* ${fb_home} \
      && rm -rf /tmp/${fb_pkg}
}

# Copy configuration files to the system
copyFiles() {
  cp ${PROVISION_DIR}/etc/filebeat.yml.ctmpl ${fb_home}/filebeat.yml.ctmpl
}

main() {
  setHttpProxy
  setFilebeatVar
  installFilebeat
  copyFiles
}
main
