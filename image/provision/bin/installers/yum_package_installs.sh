#!/bin/bash

set -euo pipefail

PROVISION_DIR="/tmp/provision"
source ${PROVISION_DIR}/lib/common-app.sh

# Install additionals packages
installPackages() {
    yum install -y \
        unzip \
        yum-utils \
        bind-utils \
        net-tools \
        iproute \
        which
}


main() {
  setHttpProxy
  installPackages
}
main
