#!/bin/bash

set -e

####################
#    VARIABLES     #
####################

PROVISION_DIR="/tmp/provision"

####################
#       MAIN       #
####################

cp ${PROVISION_DIR}/etc/containerpilot.json5 /etc
