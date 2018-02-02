#!/bin/bash

echo "***"
echo "*** GOOGLE CLOUD DIR SYNC OAUTH STEP"
echo "***"
echo "*** This script will connect to Google's Servers and provide you with a link to visit using your local webbrowser. "
echo "***"
echo "***"
read -rsp $'Press any key to continue...\n' -n 1 key

#refreshing GCDS oauth token

#the business
/usr/local/GoogleCloudDirSync/upgrade-config -Oauth $DOMAIN -c gcds_conf.xml

#visit resulting URL, copy confirmation code, paste back into prompt
/usr/local/GoogleCloudDirSync/upgrade-config -testgoogleapps -c gcds_conf.xml

echo "*** Process Complete, you may now exit the container and it should function normally.."
date +"Manual OAUTH2 Authorization Completed on %a %b %e %H:%M:$S %Z %Y" >/usr/local/GoogleCloudDirSync/oauthorized

