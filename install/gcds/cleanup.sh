#!/usr/bin/with-contenv bash
source /assets/functions/00-container
source /assets/defaults/10-gcds

cd /var/log/gcds
DATEH=(`date -d "1 hour ago" +%Y%m%d-%H`)
DATE=(`date -d "1 hour ago" +%Y%m%d`)
cat /var/log/gcds/${DATEH}*-$LOGFILE > /var/log/gcds/$DATEH-${LOGFILE%.*}.logs
rm -rf /var/log/gcds/$DATEH*-$LOGFILE

if [ $DATEH = $DATE"-23" ]; then
	gzip /var/log/gcds/*.logs
fi


if [ ! -s "/var/log/gcds/$DATEH-${LOGFILE$.*}.logs" ] ; then
    rm -rf /var/log/gcds/$DATEH-${LOGFILE$.*}.logs;
fi

find /var/log/gcds -mtime +7 -type f -delete
