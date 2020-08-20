## 5.0.0 2020-08-20 <dave at tiredofit dot ca>

   ### Added
      - Rewrote image for modernization
      - Changed ways of syncing, now choose when you want it to start and the frequency in minutes
      - Added new LOG PATH variable
      - Cleaned up code and moved common things into functions
      - Force start a sync by entering container and typing `sync-now`

   ### Changed
      - Changed some variable names (LOG_FILE, CONFIG_FILE)
      - Fixed a routine with LDAP encrypted password

## 4.5.3 2020-08-20 <dave at tiredofit dot ca>

   ### Changed
      - Update cron.sh to pull container environment variables properly


## 4.5.2 2020-07-27 <dave at tiredofit dot ca>

   ### Changed
      - Logfile Generation Fix


## 4.5.1 2020-07-27 <dave at tiredofit dot ca>

   ### Changed
      - Additional Fixes to support pulling defaults and environment variables to scripts


## 4.5.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/debian 5.0.0 Base image


## 4.4.0 2020-01-12 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/debian base image
      - Debian Buster


## 4.3 2018-08-24 <dave at tiredofit dot ca>

* Fix LOG_LEVEL to work other than ERROR

## 4.2 2018-07-31 <dave at tiredofit dot ca>

* Added ability to enable / disable email notifications and webhook notifications
* Customizable Webhook URL and endpoint
* Add some defaults for Cron execution
* Update Documentation

## 4.1 2018-07-30 <dave at tiredofit dot ca>

* Updated Routines for configuration files to delete old OAuth keys
* Added routine to change hostname in configuration files
* Added routine to update log level in configuration file
* Added routine to change MAIL_FROM MAIL_TO and SMTP_HOST inside configuration

## 4.0 2018-07-24 <dave at tiredofit dot ca>

* Utilize new method to save state for Encryption Keys allowing for easy start and stops only requiring reauthorization if a new
configuration file is used.
* Fix Log Cleanup Script

## 3.56 2018-01-22 <dave at tiredofit dot ca>

* Rip out Logrotate and add gzipping to cleanup.sh and delete files older than 7 days from /var/log/gcds

## 3.55 2018-01-21 <dave at tiredofit dot ca>

* Use FILENAME var instead of hardcoded log file entry fix

## 3.54 2018-01-21 <dave at tiredofit dot ca>

* Logrotate.d

## 3.53 2018-01-21 <dave at tiredofit dot ca>

* Actually make the sync start :P

## 3.52 2018-01-19 <dave at tiredofit dot ca>

* Automatically reset lockfile after 30 minutes for self healing

## 3.51 2018-01-19 <dave at tiredofit dot ca>

* Be more descriptive on types of errors

## 3.5 2018-01-19 <dave at tiredofit dot ca>

* Clean Syncstate lock file upon bootup
* Add error trapping to send Rocketchat Alerts if Oauth Missing
* Add error trapping to send Rocketchat alerts if fatal error occurs
* Cleanup any 0 byte logfiles
* Fix Logrotate and Merged Hourly files (extension `.logs`)

## 3.4 2018-01-03 <dave at tiredofit dot ca>

* Set to Run as gcds user NOT root
* Try for some data persistence

## 3.3 2018-01-03 <dave at tiredofit dot ca>

* Fix Logging to create a new logfile upon each run

## 3.2 2018-01-03 <dave at tiredofit dot ca>

* Fix Logrotate Issues
* Update MailX

## 3.1 2018-01-03 <dave at tiredofit dot ca>

* Switch to Debian:stretch
* Add ENV VARS (SMTP_HOST, SMTP_PORT, MAIL_FROM, MAIL_TO, DOMAIN
* Cleaned up Crontab

## 3.0 2017-08-27 <dave at tiredofit dot ca>

* Support New Base

## 2.0 2017-07-21 <dave at tiredofit dot ca>

* Rebase with S6

## 1.2 2017-04-12 <dave at tiredofit dot ca>

* Added Manual Step for OAUTH2 Integration


## 1.1 2017-04-12 <dave at tiredofit dot ca>

* Built Cron and Startup Tasks
* Added Zabbix Basic Monitoring

## 1.0 2017-01-29 <dave at tiredofit dot ca>

* Initial Relase
* Ubuntu 16.04 Base

