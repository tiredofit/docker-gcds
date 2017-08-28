FROM tiredofit/ubuntu:16.04
MAINTAINER Dave Conroy <dave at tiredofit dot ca>

### Set Environment Variables
  ENV TZ=America/Vancouver

### GCDS Dependencies
  ADD install/usr/src /usr/src/

### Dependencies Package Install
  RUN apt-get -y update && \
       LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
          ca-certificates \
          expect \
          heirloom-mailx \
          ldap-utils \
          libxml2-utils \
          && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/* && \

### Fix Timezone   
  rm -rf /etc/localtime && \
  ln -fs /usr/share/zoneinfo/US/Pacific-New /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata && \


### Install GCDS via Script
  curl https://dl.google.com/dirsync/dirsync-linux64.sh >/usr/src/gcds.sh && \
  /usr/src/install.sh && \
  rm -rf /usr/src/*


### Files Addition
  ADD install /


### Endpoint Configuration
  WORKDIR /usr/local/GoogleCloudDirSync
  ENTRYPOINT ["/init"]

