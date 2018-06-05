#!/bin/bash

set -e

DOCKER_EE_URL="https://storebits.docker.com/ee/centos/${DOCKER_SUBSCRIPTION}"
DOCKER_EE_VERSION=${DOCKER_VERSION}

sed -i.bak 's/keepcache\=0/keepcache\=1/' /etc/yum.conf

function download() {
    yum install -y --downloadonly --downloaddir=/packages/x86_64 $@
}

function download-dependencies() {
    download $(yum deplist $1 | grep provider | cut -d: -f2 | cut -d. -f1 | sed "s/ //g" | grep "^\w" | sort -u)
}

function download-package-and-dependencies() {
    download-dependencies $1
    download $1
}

# Add docker-ee.
echo "$DOCKER_EE_URL/centos" > /etc/yum/vars/dockerurl
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo "$DOCKER_EE_URL/centos/docker-ee.repo"

# Download packages and dependencies.
download-dependencies             docker-ee
download-package-and-dependencies yum-utils
download-package-and-dependencies device-mapper-persistent-data
download-package-and-dependencies lvm2

# Create repo,
yum install -y createrepo
createrepo /packages/x86_64/
