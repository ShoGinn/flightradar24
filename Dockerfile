ARG BASE=debian:stretch-slim

FROM $BASE

ARG arch=none
ENV ARCH=$arch

COPY qemu/qemu-$ARCH-static* /usr/bin/

ARG FR24FEED_ARM_VERSION=1.0.23-8
ARG FR24FEED_ARM_HASH=adc72b6a5ffe0eb089748cd26a981eac7468b5a61ee0783c7e3bc3c0ee9c52b4
ARG FR24FEED_AMD_VERSION=1.0.18-5
ARG FR24FEED_AMD_HASH=770e86b640bcbb8850df67aaa8072a85ac941e2e2f79ea25ef44d67e89bc5649

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates iputils-ping dnsutils

COPY fr24dl.sh /usr/bin/fr24dl.sh

RUN fr24dl.sh ${FR24FEED_ARM_VERSION} ${FR24FEED_ARM_HASH} ${FR24FEED_AMD_VERSION} ${FR24FEED_AMD_HASH} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# https://feed.flightradar24.com/fr24feed-manual.pdf
COPY fr24feed.ini /etc/fr24feed.ini
COPY fr24feed-runner.sh /usr/bin/fr24feed-runner

EXPOSE 8754/tcp

HEALTHCHECK --start-period=1m --interval=30s --timeout=5s --retries=3 CMD curl --fail http://localhost:8754/ || exit 1

ENTRYPOINT ["fr24feed-runner"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="ginnserv@gmail.com" \
      org.label-schema.name="Docker ADS-B - flightradar24" \
      org.label-schema.description="Docker container for ADS-B - This is the flightradar24.com component" \
      org.label-schema.url="https://github.com/ShoGinn/flightradar24" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/ShoGinn/flightradar24" \
      org.label-schema.schema-version="1.0"
