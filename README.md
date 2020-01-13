# hub.docker.com/r/tiredofit/gcds

[![Build Status](https://img.shields.io/docker/build/tiredofit/gcds.svg)](https://hub.docker.com/r/tiredofit/gcds)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/gcds.svg)](https://hub.docker.com/r/tiredofit/gcds)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/gcds.svg)](https://hub.docker.com/r/tiredofit/gcds)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/gcds.svg)](https://microbadger.com/images/tiredofit/gcds)

# Introduction

This will build a container for Google Cloud Directory Sync (old name GADS)

*    Downloads Latest Release from Google

This image needs manual configuration to get configuration running, it is not dynamic! It also needs work for automated execution, so be careful and setup monitoring should it fail. You will need to manually create the configuration file via the GCDS Desktop tools and place it inside the container via mapping to `/assets/config`. 

This Container uses tiredofit/debian:buster as a base.

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

Automated builds of the image are available on [Registry](https://hub.docker.com/r/tiredofit/gcds) and is the recommended method of installation.


```bash
docker pull tiredofit/gcds
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Configure your GCDS using a workstation and save the XML file. 
* Set environment variables and make sure you set your LDAP password so that it can be reencrypted.

You must start the container, and then manually verify the OAUTH information via a browser in order for synchronziation to start.


# Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
|-----------|-------------|
| `/assets/config` | Map this directory and place your GCDS .xml file here.
| `/var/log/gcds` | GCDS Log Output Directory |


### Environment Variables


Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/debian), below is the complete list of available options that can be used to customize your installation.


| Parameter | Description |
|-----------|-------------|
| `CONFIG_FILE | The name of your GCDS configuration file (e.g. `gcds-conf.xml`)
| `DOMAIN` | The Domain in question that is being synced |
| `DRY_RUN` | Execute a Dry Run Test (e.g. `TRUE` / `FALSE` Default: `TRUE`) |
| `ENABLE_EMAIL_NOTIFICATIONS` | Enable Email Notifications when Container errors occur `TRUE`/`FALSE` Default: `TRUE`
| `ENABLE_WEBHOOK_NOTIFICATIONS` | Enable Webhook Notifications when Container errors occur `TRUE`/`FALSE` Default: `TRUE`
| `FLUSH` | Enable Flushing of Data after Sync `TRUE`/`FALSE` Default: `FALSE` 
| `FORCE_AUTH` | Force reauthentication again (e.g. `TRUE` / `FALSE` Default: `FALSE` ) |
| `LDAP_PASS` | Password of your LDAP Account for reencryption |
| `LOG_LEVEL` | GCDS Error Logging level (e.g. `ERROR`) |
| `LOG_FILE` | Name of Logfile to output (Default `sync.log`) |
| `MAIL_FROM` | What email address to send mail from for errors |
| `MAIL_TO` | What email address to send mail to for errors |
| `SMTP_HOST` | What SMTP server to use for sending mail |
| `SMTP_PORT` | What SMTP port to use for sending mail - Default `25` |
| `WEBHOOK_URL` | Full URL to send webhook notifications to |
| `WEBHOOK_CHANNEL` | Channel or User to send Webhook notifications to |
| `WEBHOOK_CHANNEL_ESCALATED` | Channel or User to send Webhook after repeat errors |


# Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. gcds) bash
```

# References

* https://support.google.com/a/answer/106368?hl=en&ref_topic=4497998

