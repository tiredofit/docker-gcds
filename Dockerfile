FROM docker.io/tiredofit/debian:bullseye
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV IMAGE_NAME="tiredofit/gcds" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-gcds/"

RUN set -x && \
  ### Dependencies Package Install
    apt-get update && \
    apt-get upgrade -y && \
    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
                  ca-certificates \
                  expect \
                  libxml2-utils \
                  ldap-utils \
                  python3 \
                  python3-ldap \
                  s-nail \
                  && \
     \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/* && \
    \
  ### Install GCDS via Script
    echo "sys.programGroup.linkDir=/usr/bin\nsys.languageId=en\nsys.installationDir=/gcds\n\nsys.programGroup.enabled$Boolean=true\nsys.programGroup.allUsers$Boolean=true\nsys.programGroup.name='Google Cloud Directory Sync'\n" > /usr/src/gcds.varfile && \
    curl -ssL -o /usr/src/install.sh https://dl.google.com/dirsync/dirsync-linux64.sh && \
    chmod +x /usr/src/install.sh && \
    /usr/src/install.sh -q -varfile /usr/src/gcds.varfile && \
    rm -rf /usr/src/* && \
    \
  ### File Persistence Modifications
    mkdir -p /assets && \
    cp -R /root/.java /assets/ && \
    rm -rf /root/.java && \
    rm -rf /root/SyncState && \
    rm -rf /var/log/*

### Endpoint Configuration
WORKDIR /gcds

### Files Addition
ADD install /
