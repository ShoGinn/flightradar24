# flightradar24
Docker container for ADS-B - This is the flightradar24.com component

This is part of a suite of applications that can be used if you have a dump1090 compatible device including:
* Any RTLSDR USB device
* Any network AVR or BEAST device
* Any serial AVR or BEAST device

# Container Requirements

This is a multi architecture build that supports arm (armhf/arm64) and amd64

You must first have a running setup for before using this container as it will not help you on initial setup

# Container Setup

Env variables must be passed to the container containing the flightradar24 required items

### Defaults
* DUMP1090_SERVER=dump1090 -- make sure your dump1090 container is named this and on the same network (hard coded cannot change)
* DUMP1090_PORT=30005 -- default port (hard coded cannot change)
* Port 8754/tcp is exposed to show you the status of flightradar (web ui)


### User Configured
* FR24FEED_KEY - This is your user specific key

#### Example docker run

```
docker run -d \
--restart unless-stopped \
--name='flightradar24' \
-e FR24FEED_KEY="321349dd" \
shoginn/flightradar24:latest-amd64

```
# Status
| branch | Status |
|--------|--------|
| master | [![Build Status](https://travis-ci.org/ShoGinn/flightradar24.svg?branch=master)](https://travis-ci.org/ShoGinn/flightradar24) |

| Arch | Size/Layers | Commit |
|------|-------------|--------|
[![](https://images.microbadger.com/badges/version/shoginn/flightradar24:latest-arm.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-arm "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/shoginn/flightradar24:latest-arm.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-arm "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/shoginn/flightradar24:latest-arm.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-arm "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/shoginn/flightradar24:latest-arm64.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-arm64 "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/shoginn/flightradar24:latest-arm64.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-arm64 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/shoginn/flightradar24:latest-arm64.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-arm64 "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/shoginn/flightradar24:latest-amd64.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-amd64 "Get your own version badge on microbadger.com") | [![](https://images.microbadger.com/badges/image/shoginn/flightradar24:latest-amd64.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-amd64 "Get your own image badge on microbadger.com") | [![](https://images.microbadger.com/badges/commit/shoginn/flightradar24:latest-amd64.svg)](https://microbadger.com/images/shoginn/flightradar24:latest-amd64 "Get your own commit badge on microbadger.com")

