FROM centos:7

RUN mkdir -p /tmp/provision

COPY ./provision /tmp/provision

RUN \
  chmod +x /tmp/provision/bin/installers/* \
    && /tmp/provision/bin/installers/yum_package_installs.sh \
    && for i in /tmp/provision/bin/installers/*_install.sh; do echo \"Running $i\"; $i; done \
    && rm -rf /tmp/provision

