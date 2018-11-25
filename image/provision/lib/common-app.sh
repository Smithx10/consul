#!/bin/bash

set -euo pipefail

# Assert a variable
assertVariable() {
  local variable=${1}

  if [[ -n ${!variable} ]];then
    _log "The variable ${variable} is set: ${!variable}"
    return 0
  else
    _log "The variable ${variable} is not set"
    return 1
  fi
}

# Assert if we are on AWS
assertAWS() {
  if [[ ! -z $(curl -s -m 1 http://169.254.169.254/1.0/) ]]; then
    _log "We are in AWS"
    return 0
  else
    _log "We are not in AWS"
    return 1
  fi
}

assertTriton() {
  if which mdata-get > /dev/null; then
    _log "We are in Triton"
    return 0
  else
    _log "We are not in Triton"
    return 1
  fi
}

# Assert if we are in docker
assertDocker() {
  if grep docker /proc/1/cgroup -qa; then
    _log "We are in docker"
    return 0
  else
    _log "We are not in docker"
    return 1
  fi
}

# Assert if we are in vsphere
assertVsphere() {
  if which vmtoolsd > /dev/null; then
    _log "We are in vsphere"
    return 0
  else
    _log "We are not in vsphere"
    return 1
  fi
}

# Return IP for a certain interface
ipDetect() {
  local interface=$1

  if assertVariable interface > /dev/null; then
    echo $(ip addr show ${interface}| grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
    return 0
  else
    _log "No Interface Provided"
    return 1
  fi
}

# Set HTTP_PROXY
setHttpProxy() {
  _log "Attempting to Set http_proxy and https_proxy..."
  #assertVariable ONPREMISE_HTTP_PROXY

  #if [[ ! -z $(curl -s -m 1 http://169.254.169.254/1.0/) ]]; then
    #echo "Provisioning on AWS... Not Setting Proxy"
  #else
    #echo "Provisioning On-Premise... Setting Proxy to ${ONPREMISE_HTTP_PROXY}"
    #export http_proxy=${ONPREMISE_HTTP_PROXY}
    #export https_proxy=${ONPREMISE_HTTP_PROXY}
  #fi
}

# Check if time is correctly synchronised
#ntpdCheck() {
  #while ! ntpstat | grep "synchronised to NTP server"; do
    #_log "ntp is unsyncronised, restarting ntpd"
    #systemctl restart ntpd
    #sleep 9
  #done
    #_log "ntp is already synced, taking no action. Please stay synced for the love of my sanity!"
#}

# Standard Bash Logging
_log() {
  #${FUNCNAME[@]:1:${#FUNCNAME[@]}-2}
  local application=${FUNCNAME[@]:1:${#FUNCNAME[@]}-2}
    echo "    $(date -u '+%Y-%m-%d %H:%M:%S') ${application}: $@"
}
