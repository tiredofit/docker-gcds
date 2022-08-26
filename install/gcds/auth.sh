#!/command/with-contenv bash
source /assets/functions/00-container
source /assets/defaults/10-gcds

print_notice ""
echo "*** 		  GOOGLE CLOUD DIR SYNC OAUTH STEP"
echo "***"
echo "***         This script will connect to Google's Servers and provide you with a link to visit using your local web browser. "
echo "***"
echo "***"
read -rsp $'Press any key to continue...\n' -n 1 key

#refreshing GCDS oauth token
/gcds/upgrade-config -Oauth $DOMAIN -c $GCDS_XML_FILE

#visit resulting URL, copy confirmation code, paste back into prompt
/gcds/upgrade-config -testgoogleapps -c $GCDS_XML_FILE
cp $GCDS_XML_FILE /assets/config/$CONFIG_FILE
echo $CONFIG_FILE > /assets/config/AUTHORIZED_CONFIG

print_notice "*** Process Complete, you may now exit the containers shell and it should function normally.."
date +"   Manual OAUTH2 Authorization Completed on %a %b %e %H:%M:%S %Z %Y" >/gcds/oauthorized

