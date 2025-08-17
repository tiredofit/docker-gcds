# nfrastack/container-gcds

## About

This will build a container for Google Cloud Directory Sync. A tool to synchronize user and group data from your local LDAP directory to Google Workspace.

* Executes synchronization routines on a scheduled basis
* Error detection with customizable notification endpoints
* Sends statistics to Zabbix Server

This image needs manual configuration to get started. You will need to manually create the configuration file on another system with the `config-manager` GCDS GUI before the scheduler will occur. You will also need to import an OAUTH Token into that configuration file that was generated from another machine as of GCDS 5.x versions.

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Notifications](#notifications)
      - [Custom Notifications](#custom-notifications)
      - [Email Notifications](#email-notifications)
      - [Matrix Notifications](#matrix-notifications)
      - [Mattermost Notifications](#mattermost-notifications)
      - [Rocketchat Notifications](#rocketchat-notifications)
  - [Users and Groups](#users-and-groups)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  - [Manual Synchronization](#manual-synchronization)
- [Contributions](#contributions)
- [Contributions](#contributions)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)

## Installation

### Prebuilt Images
Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-gcds/pkgs/container/container-gcds) and [Docker Hub](https://hub.docker.com/r/nfrastack/gcds).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-gcds:(image_tag)
docker.io/nfrastack/gcds:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional_distribution>_<optional_distribution_variant>`

Example:

`ghcr.io/nfrastack/container-gcds:latest` or

`ghcr.io/nfrastack/container-gcds:1.0`

* `latest` will be the most recent commit
* An otpional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
* If it is built for multiple distributions there may exist a value of `alpine` or `debian`
* If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description                                                                                                  |
| ---------- | ------------------------------------------------------------------------------------------------------------ |
| `/config/` | Map this directory and place your GCDS .xml file here. State information is also stored here for encryption. |
| `/logs/`   | GCDS Log Output Directory                                                                                    |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description |
| ------------------------------------------------------- | ----------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image  |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Parameter             | Description                                                                                                                                    | Default              | Advanced |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- | -------- |
| `AUTO_UPGRADE_CONFIG` | Automatically upgrade older versions configuration AND import OAUTH_TOKEN                                                                      | `FALSE`              |          |
| `CONFIG_PATH`         | Configuration Path                                                                                                                             | `/config/`           |          |
| `CONFIG_FILE`         | The name of your GCDS configuration file (e.g. `config_file.xml`)                                                                              |                      |          |
| `DOMAIN`              | The Domain in question that is being synced                                                                                                    |                      |          |
| `DRY_RUN`             | Execute a Dry Run Test `TRUE` / `FALSE`                                                                                                        | `TRUE`               |          |
| `FLUSH_REMOTE_DATA`   | Enable Flushing of Data after Sync `TRUE`/`FALSE`                                                                                              | `FALSE`              |          |
| `MODE`                | `STANDALONE` (Do Nothing) `SCHEDULER` (run at scheduled time)                                                                                  | `STANDALONE`         |          |
| `LOG_LEVEL`           | GCDS Error Logging level (e.g. `ERROR`)                                                                                                        | `INFO`               |          |
| `LOG_PATH`            | Path where logs are kept                                                                                                                       | `/logs/`             |          |
| `LOG_FILE`            | Name of Logfile to output                                                                                                                      | `${DOMAIN}-sync.log` |          |
| `OAUTH_TOKEN`         | Oauth Token string as recieved from another machine capable of exporting authentication information eg `3FD988...`                             |                      |          |
| `OAUTH_TOKEN_PASS`    | If token has been encrypted, enter it here                                                                                                     |                      |          |
| `SYNC_BEGIN`          | What time to do the first sync. Defaults to immediate. Must be in one of two formats                                                           | `+0`                 |          |
|                       | Absolute HHMM, e.g. `2330` or `0415`                                                                                                           |                      |          |
|                       | Relative +MM, i.e. how many minutes after starting the container, e.g. `+0` (immediate), `+10` (in 10 minutes), or `+90` in an hour and a half |                      |          |
| `SYNC_INTERVAL`       | How often to sync, in minutes.                                                                                                                 | `60`                 |          |


#### Notifications

| Parameter           | Description                                                                       | Default |
| ------------------- | --------------------------------------------------------------------------------- | ------- |
| `NOTIFICATION_TYPE` | `CUSTOM` `EMAIL` `MATRIX` `MATTERMOST` `ROCKETCHAT` - Seperate Multiple by commas |         |

##### Custom Notifications

The following is sent to the custom script. Use how you wish:

````bash
$1 unix timestamp
$2 logfile
$3 errorcode
$4 subject
$5 body/error message
````

| Parameter                    | Description                                             | Default |
| ---------------------------- | ------------------------------------------------------- | ------- |
| `NOTIFICATION_CUSTOM_SCRIPT` | Path and name of custom script to execute notification. |         |


##### Email Notifications
| Parameter   | Description                                                                               | Default |
| ----------- | ----------------------------------------------------------------------------------------- | ------- |
| `MAIL_FROM` | What email address to send mail from for errors                                           |         |
| `MAIL_TO`   | What email address to send mail to for errors. Send to multiple by seperating with comma. |         |
| `SMTP_HOST` | What SMTP server to use for sending mail                                                  |         |
| `SMTP_PORT` | What SMTP port to use for sending mail                                                    |         |

##### Matrix Notifications

Fetch a `MATRIX_ACCESS_TOKEN`:

````bash
curl -XPOST -d '{"type":"m.login.password", "user":"myuserid", "password":"mypass"}' "https://matrix.org/_matrix/client/r0/login"
````

Copy the JSON response `access_token` that will look something like this:

````json
{"access_token":"MDAxO...blahblah","refresh_token":"MDAxO...blahblah","home_server":"matrix.org","user_id":"@myuserid:matrix.org"}
````

| Parameter             | Description                                                                              | Default |
| --------------------- | ---------------------------------------------------------------------------------------- | ------- |
| `MATRIX_HOST`         | URL (https://matrix.example.com) of Matrix Homeserver                                    |         |
| `MATRIX_ROOM`         | Room ID eg `\!abcdef:example.com` to send to. Send to multiple by seperating with comma. |         |
| `MATRIX_ACCESS_TOKEN` | Access token of user authorized to send to room                                          |         |


##### Mattermost Notifications

| Parameter                | Description                                                                                  | Default |
| ------------------------ | -------------------------------------------------------------------------------------------- | ------- |
| `MATTERMOST_WEBHOOK_URL` | Full URL to send webhook notifications to                                                    |         |
| `MATTERMOST_RECIPIENT`   | Channel or User to send Webhook notifications to. Send to multiple by seperating with comma. |         |
| `MATTERMOST_USERNAME`    | Username to send as eg `GCDS`                                                                |         |

##### Rocketchat Notifications

| Parameter                | Description                                                                                  | Default |
| ------------------------ | -------------------------------------------------------------------------------------------- | ------- |
| `ROCKETCHAT_WEBHOOK_URL` | Full URL to send webhook notifications to                                                    |         |
| `ROCKETCHAT_RECIPIENT`   | Channel or User to send Webhook notifications to. Send to multiple by seperating with comma. |         |
| `ROCKETCHAT_USERNAME`    | Username to send as eg `GCDS`                                                                |         |


## Users and Groups

| Type | Name   | ID   |
| ---- | ------ | ---- |
| User | `gcds` | 4237 |


* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

### Manual Definition Updates

Manual Definition Updates can be performed by entering the container and typing `update-now`

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## References

* https://support.google.com/a/answer/106368?hl=en&ref_topic=4497998

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

