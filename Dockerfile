FROM tiredofit/ubuntu:16.04
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Default Environment Variables
  ENV SMTP_FROM=noreply@example.com \
      SMTP_HOST=postfix-relay \
      SMTP_PORT=25 \
      SMTP_RCPT=sysadmin@example.com

### GCDS Dependencies
  ADD install/usr/src /usr/src/

### Add User
  RUN addgroup --gid 389 asterisk && \
      adduser --uid 389 --gid 389 --gecos "Google Cloud Directory Sync" --disabled-password gcds && \

### Dependencies Package Install
      apt-get -y update && \
       LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
          ca-certificates \
          expect \
          heirloom-mailx \
          ldap-utils \
          libxml2-utils \
          && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/* && \

### Install GCDS via Script
  curl https://dl.google.com/dirsync/dirsync-linux64.sh >/usr/src/gcds.sh && \
  /usr/src/install.sh && \
  rm -rf /usr/src/*


### Files Addition
  ADD install /

### Endpoint Configuration
  WORKDIR /usr/local/GoogleCloudDirSync
  ENTRYPOINT ["/init"]

