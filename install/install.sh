#!/usr/bin/expect

spawn /bin/sh /usr/src/gcds.sh
expect "This will install Google Cloud Directory Sync on your computer."
send -- "\n"
expect "API"
send -- "\n"
expect "I accept the agreement"
send -- "1\n"
expect "Where should Google Cloud Directory Sync be installed?"
send -- "\n"
expect "Create symlinks?"
send -- "\n"
expect "Select the folder where you would like Google Cloud Directory Sync to create symlinks, then click Next."
send -- "\n"
expect "#"
exit 0

