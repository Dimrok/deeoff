#!/bin/bash

set -e

DOCKER_EE_URL="https://storebits.docker.com/ee/ubuntu/${DOCKER_SUBSCRIPTION}"
DOCKER_EE_VERSION=${DOCKER_VERSION}

function download-dependencies() {
    apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --no-pre-depends $1 | grep "^\w" | sort -u)
}

function download-package-and-dependencies() {
    download-dependencies $1
    apt-get download $1
}

# Add docker-ee.
apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | apt-key add - && \
    apt-key fingerprint 6D085F96 && add-apt-repository "deb [arch=amd64] $DOCKER_EE_URL/ubuntu $(lsb_release -cs) stable-${DOCKER_EE_VERSION}" \
    && apt-get update

# Download packages and dependencies.
cd /packages
download-dependencies             docker-ee
download-package-and-dependencies apt-transport-https
download-package-and-dependencies ca-certificates
download-package-and-dependencies curl
download-package-and-dependencies software-properties-common

# Create Packages.gz.
apt-get install -y dpkg-dev
dpkg-scanpackages . | gzip -9c > Packages.gz
