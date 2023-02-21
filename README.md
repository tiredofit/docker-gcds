# github.com/tiredofit/docker-gcds

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-gcds?style=flat-square)](https://github.com/tiredofit/docker-gcds/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-gcds/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-gcds/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/gcds.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/gcds/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/gcds.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/gcds/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a container for Google Cloud Directory Sync. A tool to synchronize user and group data from your local LDAP directory to Google Workspace.

* Executes synchronization routines on a scheduled basis
* Error detection with customizable notification endpoints
* Sends statistics to Zabbix Server

This image needs manual configuration to get started. You will need to manually create the configuration file on another system with the `config-manager` GCDS GUI before the scheduler will occur. You will also need to import an OAUTH Token into that configuration file that was generated from another machine as of GCDS 5.x versions.

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Notifications](#notifications)
    - [Custom Notifications](#custom-notifications)
    - [Email Notifications](#email-notifications)
    - [Matrix Notifications](#matrix-notifications)
    - [Mattermost Notifications](#mattermost-notifications)
    - [Rocketchat Notifications](#rocketchat-notifications)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  - [Manual Synchronization](#manual-synchronization)
- [Contributions](#contributions)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
- You have an active Google Workspace Account with appropriate Administration privileges.

## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/gcds)

```bash
docker pull docker.io/tiredofdit/gcds:(latest)
```

## Configuration
### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* On another machine, you must setup Oauth tokens, as this container cannot set them up for you. You must enter  `upgrade-config -exportkeys encrypted.key [password]` on the source system.
* Get the contents of this new file and paste it in `OAUTH_TOKEN` environment variable or use `upgrade-config -importkeys encrypted.key [password]` inside the container.
* Set `MODE` environment variables
* Set any environment variables to support scheduling or notifications


### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description                                                                                                  |
| ---------- | ------------------------------------------------------------------------------------------------------------ |
| `/config/` | Map this directory and place your GCDS .xml file here. State information is also stored here for encryption. |
| `/logs/`   | GCDS Log Output Directory                                                                                    |


### Environment Variables

#### Base Images used

This image relies on a [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-debian/) | Customized Image based on debian Linux |


| Parameter             | Description                                                                                                                                    | Default              |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `AUTO_UPGRADE_CONFIG` | Automatically upgrade older versions configuration AND import OAUTH_TOKEN                                                                      | `FALSE`              |
| `CONFIG_PATH`         | Configuration Path                                                                                                                             | `/config/`           |
| `CONFIG_FILE`         | The name of your GCDS configuration file (e.g. `config_file.xml`)                                                                              |                      |
| `DOMAIN`              | The Domain in question that is being synced                                                                                                    |                      |
| `DRY_RUN`             | Execute a Dry Run Test `TRUE` / `FALSE`                                                                                                        | `TRUE`               |
| `FLUSH_REMOTE_DATA`   | Enable Flushing of Data after Sync `TRUE`/`FALSE`                                                                                              | `FALSE`              |
| `MODE`                | `STANDALONE` (Do Nothing) `SCHEDULER` (run at scheduled time)                                                                                  | `STANDALONE`         |
| `LOG_LEVEL`           | GCDS Error Logging level (e.g. `ERROR`)                                                                                                        | `INFO`               |
| `LOG_PATH`            | Path where logs are kept                                                                                                                       | `/logs/`             |
| `LOG_FILE`            | Name of Logfile to output                                                                                                                      | `${DOMAIN}-sync.log` |
| `OAUTH_TOKEN`         | Oauth Token string as recieved from another machine capable of exporting authentication information eg `3FD988...`                             |                      |
| `OAUTH_TOKEN_PASS`    | If token has been encrypted, enter it here                                                                                                     |                      |
| `SYNC_BEGIN`          | What time to do the first sync. Defaults to immediate. Must be in one of two formats                                                           | `+0`                 |
|                       | Absolute HHMM, e.g. `2330` or `0415`                                                                                                           |                      |
|                       | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half |                      |
| `SYNC_INTERVAL`       | How often to sync, in minutes.                                                                                                                 | `60`                 |


#### Notifications
| Parameter           | Description                                                                       | Default |
| ------------------- | --------------------------------------------------------------------------------- | ------- |
| `NOTIFICATION_TYPE` | `CUSTOM` `EMAIL` `MATRIX` `MATTERMOST` `ROCKETCHAT` - Seperate Multiple by commas |         |

#### Custom Notifications

The following is sent to the custom script. Use how you wish:

````
$1 unix timestamp
$2 logfile
$3 errorcode
$4 subject
$5 body/error message
````

| Parameter                    | Description                                             | Default |
| ---------------------------- | ------------------------------------------------------- | ------- |
| `NOTIFICATION_CUSTOM_SCRIPT` | Path and name of custom script to execute notification. |         |


#### Email Notifications
| Parameter   | Description                                                                               | Default |
| ----------- | ----------------------------------------------------------------------------------------- | ------- |
| `MAIL_FROM` | What email address to send mail from for errors                                           |         |
| `MAIL_TO`   | What email address to send mail to for errors. Send to multiple by seperating with comma. |         |
| `SMTP_HOST` | What SMTP server to use for sending mail                                                  |         |
| `SMTP_PORT` | What SMTP port to use for sending mail                                                    |         |

#### Matrix Notifications

Fetch a `MATRIX_ACCESS_TOKEN`:

````
curl -XPOST -d '{"type":"m.login.password", "user":"myuserid", "password":"mypass"}' "https://matrix.org/_matrix/client/r0/login"
````

Copy the JSON response `access_token` that will look something like this:

````
{"access_token":"MDAxO...blahblah","refresh_token":"MDAxO...blahblah","home_server":"matrix.org","user_id":"@myuserid:matrix.org"}
````

| Parameter             | Description                                                                              | Default |
| --------------------- | ---------------------------------------------------------------------------------------- | ------- |
| `MATRIX_HOST`         | URL (https://matrix.example.com) of Matrix Homeserver                                    |         |
| `MATRIX_ROOM`         | Room ID eg `\!abcdef:example.com` to send to. Send to multiple by seperating with comma. |         |
| `MATRIX_ACCESS_TOKEN` | Access token of user authorized to send to room                                          |         |



#### Mattermost Notifications
| Parameter                | Description                                                                                  | Default |
| ------------------------ | -------------------------------------------------------------------------------------------- | ------- |
| `MATTERMOST_WEBHOOK_URL` | Full URL to send webhook notifications to                                                    |         |
| `MATTERMOST_RECIPIENT`   | Channel or User to send Webhook notifications to. Send to multiple by seperating with comma. |         |
| `MATTERMOST_USERNAME`    | Username to send as eg `GCDS`                                                                |

#### Rocketchat Notifications


| Parameter                | Description                                                                                  | Default |
| ------------------------ | -------------------------------------------------------------------------------------------- | ------- |
| `ROCKETCHAT_WEBHOOK_URL` | Full URL to send webhook notifications to                                                    |         |
| `ROCKETCHAT_RECIPIENT`   | Channel or User to send Webhook notifications to. Send to multiple by seperating with comma. |         |
| `ROCKETCHAT_USERNAME`    | Username to send as eg `GCDS`                                                                |


## Maintenance

### Shell Access
For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name) bash
```
### Manual Synchronization

Visit the inside of the container and execute `sync-now`


## Contributions
Welcomed. Please fork the repository and submit a [pull request](../../pulls) for any bug fixes, features or additions you propose to be included in the image. If it does not impact my intended usage case, it will be merged into the tree, tagged as a release and credit to the contributor in the [CHANGELOG](CHANGELOG).

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support.
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

