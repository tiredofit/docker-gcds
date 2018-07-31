#!/usr/bin/with-contenv bash

GCDS_XML_FILE=/gcds/gcds_conf.xml

echo "**** [gcds] "
echo "*** 		  GOOGLE CLOUD DIR SYNC OAUTH STEP"
echo "***"
echo "***         This script will connect to Google's Servers and provide you with a link to visit using your local webbrowser. "
echo "***"
echo "***"
read -rsp $'Press any key to continue...\n' -n 1 key

if [ "$DEBUG_MODE" = "TRUE" ] || [ "$DEBUG_MODE" = "true" ];  then
  set -x
fi

#refreshing GCDS oauth token
/gcds/upgrade-config -Oauth $DOMAIN -c $GCDS_XML_FILE

#visit resulting URL, copy confirmation code, paste back into prompt
/gcds/upgrade-config -testgoogleapps -c $GCDS_XML_FILE
cp /gcds/gcds_conf.xml /assets/config/$CONFIGFILE
echo $CONFIGFILE > /assets/config/AUTHORIZED_CONFIG

echo "*** Process Complete, you may now exit the container and it should function normally.."
date +"   Manual OAUTH2 Authorization Completed on %a %b %e %H:%M:$S %Z %Y" >/gcds/oauthorized

