#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

awscli_name=""
awscli_pkg=""
awscli_sha256=""
awscli_url=""

# Set Environment Variables
setAwsVar() {
  awscli_name=awscli-bundle
  awscli_pkg=${awscli_name}.zip
  awscli_sha256=e6fbb99b4d5e3b3e9b190f30b1f65b9b87b8eeef0d46c6814e8ee06ab7c6c88c
  awscli_url=https://s3.amazonaws.com/aws-cli/${awscli_pkg}
}

# Install Cli
installAwsCli() {
    _log "Installing awscli with the following env vars:"
    _log "awscli_pkg: ${awscli_pkg}"
    _log "awsclisha256: ${awscli_sha256}"
    _log "awscli_url: ${awscli_url}"
    curl -Ls --fail -o /tmp/${awscli_pkg} ${awscli_url} \
      && unzip /tmp/${awscli_pkg} -d /tmp \
      && /tmp/${awscli_name}/install -i /usr/local/aws -b /usr/local/bin/aws \
      && rm -rf /tmp/${awscli_pkg} \
      && rm -rf /tmp/${awscli_name}
}

main () {
  setHttpProxy
  setAwsVar
  installAwsCli
}
main
