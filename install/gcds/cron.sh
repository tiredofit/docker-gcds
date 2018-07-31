#!/usr/bin/with-contenv bash

if [ "$DEBUG_MODE" = "TRUE" ] || [ "$DEBUG_MODE" = "true" ];  then
  set -x
fi

DATE=(`date "+%Y%m%d-%H%M%S"`)
FILENAME=$DATE-$LOGFILE
GCDS_XML_FILE=/gcds/gcds_conf.xml
MAIL_FROM=${MAIL_FROM:-"gcds@example.com"}
MAIL_TO=${MAIL_TO:-"admin@example.com"}
SMTP_HOST=${SMTP_HOST-"postfix-relay"}
SMTP_PORT=${SMTP_PORT:-"25"}
ENABLE_EMAIL_NOTIFICATIONS=${ENABLE_EMAIL_NOTIFICATIONS:-TRUE}
ENABLE_WEBHOOK_NOTIFICATIONS=${ENABLE_WEBHOOK_NOTIFICATIONS:-TRUE}
WEBHOOK_CHANNEL=${WEBHOOK_CHANNEL:-"#it-systems"}
WEBHOOK_CHANNEL_ESCALATED=${WEBHOOK_CHANNEL:-$WEBHOOK_CHANNEL}

/gcds/sync-cmd -a -l ERROR -r /var/log/gcds/$FILENAME -c $GCDS_XML_FILE -o

if ls /assets/config/.syncState/*.lock >/dev/null 2>&1; then
LOCKFILE=`ls -C /assets/config/.SyncState/*.lock | sed "s~/assets/config/.syncState/~~g"`

	if [ `stat --format=%Y /assets/config/.syncState/$LOCKFILE` -le $(( `date +%s` - 1800 )) ]; then 
		if [ "$ENABLE_WEBHOOK_NOTIFICATIONS" = "TRUE" ] || [ "$ENABLE_WEBHOOK_NOTIFICATIONS" = "true" ];  then
			/usr/local/bin/webhook-alert $WEBHOOK_CHANNEL "*Lockfile Issue*" "The Google Cloud Directory Sync seems to be hung due to a stale lockfile. I've deleted it, however this was after 30 minutes of hanging. Please monitor the container for any further issues.\n "  "gcds-app"\;
		fi
		if [ "$ENABLE_EMAIL_NOTIFICATIONS" = "TRUE" ] || [ "$ENABLE_EMAIL_NOTIFICATIONS" = "true" ];  then
			    echo "The Google Cloud Directory Sync seems to be hung due to a stale lockfile. I've deleted it, however this was after 30 minutes of hanging. Please monitor the container for any further issues." | s-nail -v \
			      -r "$MAIL_FROM" \
			      -s "[GCDS] Lockfile Issue" \
			      -S smtp="$SMTP_HOST:$SMTP_PORT" \
			      $MAIL_TO & >/dev/null 2>&1
		fi	
		rm -rf  /assets/config/.syncState/$LOCKFILE
	fi
fi;

if [ ! -s "/var/log/gcds/$FILENAME" ] ; then
    rm -rf /var/log/gcds/$FILENAME;
fi

if grep '[ERROR] [usersyncapp.sync.ConfigErrorHandler]' /tmp/$FILENAME ; then
	if [ "$ENABLE_WEBHOOK_NOTIFICATIONS" = "TRUE" ] || [ "$ENABLE_WEBHOOK_NOTIFICATIONS" = "true" ];  then
		/usr/local/bin/webhook-alert $WEBHOOK_CHANNEL "*Synchronization Failed*" "The Google Cloud Directory Sync is reporting Fatal Errors. Please login to the host server, enter the GCDS container and troubleshoot. I think it's something to do with the OAUTH key. See the file */tmp/$FILENAME.error* for hints.\n "  "gcds-app"
	fi
	if [ "$ENABLE_EMAIL_NOTIFICATIONS" = "TRUE" ] || [ "$ENABLE_EMAIL_NOTIFICATIONS" = "true" ];  then
		    echo "The Google Cloud Directory Sync is reporting Fatal Errors. Please login to the host server, enter the GCDS container and troubleshoot. I think it's something to do with the OAUTH key. See the file */tmp/"$FILENAME".error* for hints. " | s-nail -v \
		      -r "$MAIL_FROM" \
		      -s "[GCDS] Synchronization Failed" \
		      -S smtp="$SMTP_HOST:$SMTP_PORT" \
		      $MAIL_TO & >/dev/null 2>&1
    fi
	mv /tmp/$FILENAME /tmp/$FILENAME.error
fi

if grep '"LDAP Plugin" threw a fatal exception' /tmp/$FILENAME ; then
	if [ "$ENABLE_WEBHOOK_NOTIFICATIONS" = "TRUE" ] || [ "$ENABLE_WEBHOOK_NOTIFICATIONS" = "true" ];  then
		/usr/local/bin/webhook-alert $WEBHOOK_CHANNEL "*Synchronization Failed*" "The Google Cloud Directory Sync is reporting Fatal Errors. Please login to the host server, enter the GCDS container and troubleshoot. I think it's something to do with improper LDAP Hostname, or Credentials. See the file */tmp/$FILENAME.error* for hints.\n "  "gcds-app"
	fi
	if [ "$ENABLE_EMAIL_NOTIFICATIONS" = "TRUE" ] || [ "$ENABLE_EMAIL_NOTIFICATIONS" = "true" ];  then
		    echo "The Google Cloud Directory Sync is reporting Fatal Errors. Please login to the host server, enter the GCDS container and troubleshoot. I think it's something to do with improper LDAP Hostname, or Credentials. See the file */tmp/"$FILENAME".error* for hints.\n " | s-nail -v \
		      -r "$MAIL_FROM" \
		      -s "[GCDS] Synchronization Failed" \
		      -S smtp="$SMTP_HOST:$SMTP_PORT" \
		      $MAIL_TO & >/dev/null 2>&1
    fi
	mv /tmp/$FILENAME /tmp/$FILENAME.error
fi

rm -rf /tmp/$FILENAME
