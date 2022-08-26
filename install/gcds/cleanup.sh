#!/command/with-contenv bash
source /assets/functions/00-container
source /assets/defaults/10-gcds

cd /var/log/gcds
DATEH=(`date -d "1 hour ago" +%Y%m%d-%H`)
DATE=(`date -d "1 hour ago" +%Y%m%d`)
cat ${LOG_PATH}${DATEH}*-$LOGFILE > ${LOG_PATH}$DATEH-${LOGFILE%.*}.logs
rm -rf ${LOG_PATH}$DATEH*-$LOGFILE

if [ $DATEH = $DATE"-23" ] ; then
	gzip ${LOG_PATH}*.logs
fi

if [ ! -s "${LOG_PATH}$DATEH-${LOGFILE$.*}.logs" ] ; then
    rm -rf ${LOG_PATH}$DATEH-${LOGFILE$.*}.logs
fi

find ${LOG_PATH} -mtime +7 -type f -delete
