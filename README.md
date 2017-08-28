# hub.docker.com/tiredofit/gcds

# Introduction

This will build a container for Google Cloud Directory Sync (old name GADS)

*    Downloads Latest Release from Google

This image needs manual configuration to get configuration running, it is not dynamic! It also needs work for automated execution, so be careful and setup monitoring should it fail. You will need to manually create the configuration file via the GCDS Desktop tools and place it inside the container via mapping to `/assets/config`. 

This Container uses tiredofit/ubuntu:16.04 as a base w/S6 Init System and Zabbix Monitoring.

[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
    - [Networking](#networking)
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

None


# Installation

Automated builds of the image are available on [Registry](https://hub.docker.com/tiredofit/gcds) and is the recommended method of installation.


```bash
docker pull hub.docker.com/tiredofit/gcds
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

You must start the container, and then manually verify the OAUTH information via a browser in order for synchronziation to start.



# Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
|-----------|-------------|
| `/var/log/gcds` | GCDS Log Output Directory |
| `/assets/config` | Map this directory and place your GCDS .xml file here.

### Environment Variables


Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/ubuntu), below is the complete list of available options that can be used to customize your installation.


| Parameter | Description |
|-----------|-------------|
| `CONFIG_FILE | The name of your GCDS configuration file (e.g. `gcds-conf.xml`)
| `DRY_RUN` | Execute a Dry Run Test (e.g. `TRUE` / `FALSE` Default: TRUE) |
| `LOG_LEVEL` | GCDS Error Logging level (e.g. `ERROR`) |
| `LOG_FILE` | Name of Logfile to output (Default `sync.log`) |
| `FLUSH` | Enable Flushing of Data afte rSync |


# Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. gcds) bash
```

# References

* https://support.google.com/a/answer/106368?hl=en&ref_topic=4497998

