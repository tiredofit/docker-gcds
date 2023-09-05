ARG DISTRO=debian
ARG DISTRO_VARIANT=bullseye

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV GCDS_VERSION=5.0.28 \
    APP_USER=gcds \
    IMAGE_NAME="tiredofit/gcds" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-gcds/"

RUN source /assets/functions/00-container && \
    set -x && \
    addgroup --gid 4237 gcds && \
    adduser --uid 4237 \
            --gid 4237 \
            --gecos "GCDS User" \
            --home /gcds \
            --shell /sbin/nologin \
            --disabled-login \
            --disabled-password \
            gcds && \
    package update && \
    package upgrade -y && \
    package install  \
                  ldap-utils \
                  python3 \
                  python3-ldap \
                  s-nail \
                  && \
    \
    echo -e "sys.programGroup.linkDir=/usr/bin\nsys.languageId=en\nsys.installationDir=/gcds\n\nsys.programGroup.enabled$Boolean=true\nsys.programGroup.allUsers$Boolean=true\nsys.programGroup.name='Google Cloud Directory Sync'\n" > /usr/src/gcds.varfile && \
    curl -ssL -o /usr/src/install.sh https://dl.google.com/dirsync/Google/GoogleCloudDirSync_linux_64bit_${GCDS_VERSION//./_}.sh && \
    chmod +x /usr/src/install.sh && \
    mkdir -p /gcds && \
    chown -R gcds:gcds /gcds && \
    sudo -u gcds /usr/src/install.sh -q -varfile /usr/src/gcds.varfile && \
    \
    mkdir -p /assets/gcds/ && \
    cp -R /gcds/.java /assets/gcds/ && \
    package cleanup && \
    rm -rf /gcds/.java \
           "/gcds/Configuration Manager.desktop" \
           /gcds/uninstall \
           /gcds/SyncState \
           /usr/src/* \
           /var/log/*

### Endpoint Configuration
WORKDIR /gcds

### Files Addition
COPY install /
