#!/bin/bash

set -e

####################
#    VARIABLES     #
####################

PROVISION_DIR="/tmp/provision"

####################
#       MAIN       #
####################

cp ${PROVISION_DIR}/etc/consul.json /config/consul.json
cp ${PROVISION_DIR}/bin/consul-manage /usr/local/bin/consul-manage
