# github.com/tiredofit/docker-gcds

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-gcds?style=flat-square)](https://github.com/tiredofit/docker-gcds/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-gcds/build?style=flat-square)](https://github.com/tiredofit/docker-gcds/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/gcds.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/gcds/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/gcds.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/gcds/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a container for Google Cloud Directory Sync (old name GADS)

*    Downloads Latest Release from Google

This image needs manual configuration to get configuration running, it is not dynamic! It also needs work for automated execution, so be careful and setup monitoring should it fail. You will need to manually create the configuration file via the GCDS Desktop tools and place it inside the container via mapping to `/assets/config`.

## Maintainer

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

## Prerequisites and Assumptions
None


## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/gcds) and is the recommended method of installation.

```bash
docker pull tiredofit/gcds:(latest)
```

## Configuration
### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Configure your GCDS using a workstation and save the XML file.
* Set environment variables and make sure you set your LDAP password so that it can be reencrypted.
* You must start the container, and then manually verify the OAUTH information via a browser in order for synchronziation to start.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory        | Description                                            |
| ---------------- | ------------------------------------------------------ |
| `/assets/config` | Map this directory and place your GCDS .xml file here. |
| `/logs/`         | GCDS Log Output Directory                              |


### Environment Variables

#### Base Images used

This image relies on a [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-debian/) | Customized Image based on debian Linux |


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
Inside the image are tools to perform modification on how the image runs.

### Shell Access
For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name) bash
```
### Manual Synchronization

## Contributions
Welcomed. Please fork the repository and submit a [pull request](../../pulls) for any bug fixes, features or additions you propose to be included in the image. If it does not impact my intended usage case, it will be merged into the tree, tagged as a release and credit to the contributor in the [CHANGELOG](CHANGELOG).

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.


## References

* https://support.google.com/a/answer/106368?hl=en&ref_topic=4497998

