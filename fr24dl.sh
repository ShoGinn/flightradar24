#!/usr/bin/env bash
set -e

if [[ $# -eq 0 ]] ; then
    echo 'No Arguments'
    exit 1
fi
#Usually set from the outside
DOCKER_ARCH_ACTUAL="$(docker version -f '{{.Server.Arch}}')"
: ${DOCKER_ARCH:="$DOCKER_ARCH_ACTUAL"}

if [[ $DOCKER_ARCH =~ arm ]] ; then
	echo "Download armhf version"
	curl --output fr24feed.tgz "http://repo.feed.flightradar24.com/rpi_binaries/fr24feed_${1}_armhf.tgz" && \
    sha256sum fr24feed.tgz && echo "${2}  fr24feed.tgz" | sha256sum -c && \
    tar -xvf fr24feed.tgz --strip-components=1 fr24feed_armhf/fr24feed && \
    mv fr24feed /usr/bin/fr24feed && \
    rm fr24feed.tgz
fi
if [ "$DOCKER_ARCH" = "amd64" ] ; then
	echo "Download AMD64 version"
	curl --output fr24feed.tgz "https://repo-feed.flightradar24.com/linux_x86_64_binaries/fr24feed_${3}_amd64.tgz" && \
	sha256sum fr24feed.tgz && echo "${4}  fr24feed.tgz" | sha256sum -c && \
	tar -xvf fr24feed.tgz --strip-components=1 fr24feed_amd64/fr24feed && \
    mv fr24feed /usr/bin/fr24feed && \
    rm fr24feed.tgz
fi
