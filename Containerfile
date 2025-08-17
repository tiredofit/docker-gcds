ARG BASE_IMAGE
ARG DISTRO
ARG DISTRO_VARIANT

FROM ${BASE_IMAGE}:${DISTRO}_${DISTRO_VARIANT}

LABEL \
        org.opencontainers.image.title="GCDS" \
        org.opencontainers.image.description="Google Cloud Directory Sync" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/gcds" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-gcds/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-gcds.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG     \
        GCDS_VERSION

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    GCDS_VERSION=${GCDS_VERSION:-"5.0.31"} \
    APP_USER=gcds \
    IMAGE_NAME="nfrastack/gcds" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-gcds/"

RUN echo "" && \
    GCDS_RUN_DEPS_DEBIAN=" \
                              ldap-utils \
                              python3 \
                              python3-ldap \
                              s-nail \
                        " \
                    && \
    \
    source /container/base/functions/container/build && \
    container_build_log && \
    create_user ${APP_USER} 4237 ${APP_USER} 4237 /${APP_USER} && \
    package update && \
    package upgrade && \
    package install \
                        GCDS_RUN_DEPS \
                        && \
    \
    echo -e "sys.programGroup.linkDir=/usr/bin\nsys.languageId=en\nsys.installationDir=/gcds\n\nsys.programGroup.enabled$Boolean=true\nsys.programGroup.allUsers$Boolean=true\nsys.programGroup.name='Google Cloud Directory Sync'\n" > /usr/src/gcds.varfile && \
    curl -ssL -o /usr/src/install.sh https://dl.google.com/dirsync/Google/GoogleCloudDirSync_linux_64bit_${GCDS_VERSION//./_}.sh && \
    chmod +x /usr/src/install.sh && \
    mkdir -p /gcds && \
    chown -R ${APP_USER}:${APP_USER} /gcds && \
    sudo -u ${APP_USER} /usr/src/install.sh -q -varfile /usr/src/gcds.varfile && \
    \
    mkdir -p /container/data/gcds/ && \
    cp -R /gcds/.java /container/data/gcds/ && \
    rm -rf /gcds/.java \
           "/gcds/Configuration Manager.desktop" \
           /gcds/uninstall \
           /gcds/SyncState \
           && \
    package cleanup

WORKDIR /gcds

COPY rootfs /
