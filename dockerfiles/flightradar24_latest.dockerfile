FROM debian:stretch-slim AS base

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    iputils-ping \
    dnsutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

FROM --platform=$TARGETPLATFORM debian:stretch-slim as builder

ARG TARGETARCH
ARG FR24FEED_ARM_VERSION=1.0.24-7
ARG FR24FEED_ARM_HASH=5f83f65a0a87b464455ce42d508bd0ad61fb605786b5d0d6bd46d45f8747644e
ARG FR24FEED_AMD_VERSION=1.0.24-5
ARG FR24FEED_AMD_HASH=cc88150f753e734327bf35574f6de5b11d8f989ddb1186514a4ce02e6e61600b

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates

RUN set -ex; \
    if [ ${TARGETARCH} != "amd64" ]; then \
    echo "Download armhf version";\
    curl --output fr24feed.tgz "http://repo.feed.flightradar24.com/rpi_binaries/fr24feed_${FR24FEED_ARM_VERSION}_armhf.tgz"; \
    sha256sum fr24feed.tgz && echo "${FR24FEED_ARM_HASH}  fr24feed.tgz" | sha256sum -c ; \
    tar -xvf fr24feed.tgz --strip-components=1 fr24feed_armhf/fr24feed ; \
    mv fr24feed /usr/bin/fr24feed ; \
    rm fr24feed.tgz ; \
    else \
    echo "Download AMD64 version" ; \
    curl --output fr24feed.tgz "https://repo-feed.flightradar24.com/linux_x86_64_binaries/fr24feed_${FR24FEED_AMD_VERSION}_amd64.tgz" ; \
    sha256sum fr24feed.tgz && echo "${FR24FEED_AMD_HASH}  fr24feed.tgz" | sha256sum -c ; \
    tar -xvf fr24feed.tgz --strip-components=1 fr24feed_amd64/fr24feed ; \
    mv fr24feed /usr/bin/fr24feed ; \
    rm fr24feed.tgz ; \
    fi;

FROM base

COPY rootfs /

COPY --from=builder /usr/bin/fr24feed /usr/bin/fr24feed

EXPOSE 8754/tcp

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]