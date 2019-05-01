#!/bin/sh

set -o errexit          # Exit on most errors (see the manual)
#set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
#set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)


echo "Waiting for dump1090 to start up"
sleep 5s

echo "Creating the base ini file"
cat <<- EOF > /etc/fr24feed.ini
receiver="beast-tcp"
host="dump1090:30005"

bs="no"
raw="no"

logmode="0"

bind-interface="0.0.0.0"

mlat="yes"
mlat-without-gps="yes"
EOF

# https://forum.flightradar24.com/threads/11943-Problems-with-feeder-statistics-and-data-sharing
nslookup feed.flightradar24.com
ping -c 1 feed.flightradar24.com
echo

exec fr24feed --config-file=/etc/fr24feed.ini \
           --fr24key="${FR24FEED_KEY}"