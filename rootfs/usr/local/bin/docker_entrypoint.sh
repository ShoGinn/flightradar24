#!/usr/bin/env sh

set -o errexit # Exit on most errors (see the manual)
#set -o errtrace         # Make sure any error trap is inherited
set -o nounset # Disallow expansion of unset variables
#set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

DUMP1090_SERVER=${DUMP1090_SERVER:=dump1090}
DUMP1090_PORT=${DUMP1090_PORT:=30005}
MLAT=${MLAT:=yes}
MLAT_WITHOUT_GPS=${MLAT_WITHOUT_GPS:=yes}

echo "Waiting for dump1090 to start up"
sleep 5s

echo "Creating the base ini file"
cat <<-EOF >/etc/fr24feed.ini
receiver="beast-tcp"
host="${DUMP1090_SERVER}:${DUMP1090_PORT}"

bs="no"
raw="no"
logmode="0"
windowmode="0"
mpx="no"
mlat="${MLAT}"
mlat-without-gps="${MLAT_WITHOUT_GPS}"
use-http=yes
http-timeout=20
EOF

# https://forum.flightradar24.com/threads/11943-Problems-with-feeder-statistics-and-data-sharing
nslookup feed.flightradar24.com
ping -c 1 feed.flightradar24.com
echo

exec fr24feed --config-file=/etc/fr24feed.ini \
    --fr24key="${FR24FEED_KEY}"
