# hub.docker.com/r/tiredofit/gcds

[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/gcds.svg)](https://hub.docker.com/r/tiredofit/gcds)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/gcds.svg)](https://hub.docker.com/r/tiredofit/gcds)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/gcds.svg)](https://microbadger.com/images/tiredofit/gcds)

## Introduction

This will build a container for Google Cloud Directory Sync (old name GADS)

*    Downloads Latest Release from Google

This image needs manual configuration to get configuration running, it is not dynamic! It also needs work for automated execution, so be careful and setup monitoring should it fail. You will need to manually create the configuration file via the GCDS Desktop tools and place it inside the container via mapping to `/assets/config`.

This Container uses tiredofit/debian:buster as a base.

[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data-Volumes](#data-volumes)
  - [Environment Variables](#environment-variables)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites

None


## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/gcds) and is the recommended method of installation.


```bash
docker pull tiredofit/gcds
```

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Configure your GCDS using a workstation and save the XML file.
* Set environment variables and make sure you set your LDAP password so that it can be reencrypted.

You must start the container, and then manually verify the OAUTH information via a browser in order for synchronziation to start.


## Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory        | Description                                            |
| ---------------- | ------------------------------------------------------ |
| `/assets/config` | Map this directory and place your GCDS .xml file here. |
| `/logs/`         | GCDS Log Output Directory                              |


### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/debian), below is the complete list of available options that can be used to customize your installation.


| Parameter                      | Description                                                                                                                                    | Default    |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `CONFIG_FILE`                  | The name of your GCDS configuration file (e.g. `gcds-conf.xml`)                                                                                |            |
| `DOMAIN`                       | The Domain in question that is being synced                                                                                                    |            |
| `DRY_RUN`                      | Execute a Dry Run Test `TRUE` / `FALSE`                                                                                                        | `TRUE`     |
| `ENABLE_EMAIL_NOTIFICATIONS`   | Enable Email Notifications when Container errors occur `TRUE`/`FALSE`                                                                          | `TRUE`     |
| `ENABLE_WEBHOOK_NOTIFICATIONS` | Enable Webhook Notifications when Container errors occur `TRUE`/`FALSE`                                                                        | `TRUE`     |
| `FLUSH`                        | Enable Flushing of Data after Sync `TRUE`/`FALSE`                                                                                              | `FALSE`    |
| `FORCE_AUTH`                   | Force reauthentication again `TRUE` / `FALSE`                                                                                                  | `FALSE`    |
| `LDAP_PASS`                    | Password of your LDAP Account for reencryption                                                                                                 |            |
| `LOG_LEVEL`                    | GCDS Error Logging level (e.g. `ERROR`)                                                                                                        | `INFO`     |
| `LOG_PATH`                     | Path where logs are kept                                                                                                                       | `/logs/`   |
| `LOG_FILE`                     | Name of Logfile to output                                                                                                                      | `sync.log` |
| `MAIL_FROM`                    | What email address to send mail from for errors                                                                                                |            |
| `MAIL_TO`                      | What email address to send mail to for errors                                                                                                  |            |
| `SMTP_HOST`                    | What SMTP server to use for sending mail                                                                                                       |            |
| `SMTP_PORT`                    | What SMTP port to use for sending mail                                                                                                         | `25`       |
| `SYNC_BEGIN`                   | What time to do the first sync. Defaults to immediate. Must be in one of two formats                                                           | `+0`       |
|                                | Absolute HHMM, e.g. `2330` or `0415`                                                                                                           |
|                                | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half |
| `SYNC_INTERVAL`                | How often to sync, in minutes.                                                                                                                 | `60`       |
| `WEBHOOK_URL`                  | Full URL to send webhook notifications to                                                                                                      |            |
| `WEBHOOK_CHANNEL`              | Channel or User to send Webhook notifications to                                                                                               |            |
| `WEBHOOK_CHANNEL_ESCALATED`    | Channel or User to send Webhook after repeat errors                                                                                            |            |


## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. gcds) bash
```

To start a sync immediately inside the container - type `sync-now`

## References

* https://support.google.com/a/answer/106368?hl=en&ref_topic=4497998

