#!/usr/bin/env bash

set -ex

: ${BUILD:="$1"} # Latest or test-build

#good defaults
: ${CONFIG_FILE:="./travis/build.config"}
test -e ${CONFIG_FILE} && . ${CONFIG_FILE}


: ${ARCHITECTURES:="arm arm64 amd64"}

for arch in $ARCHITECTURES
do
# Build for all architectures and push manifest
  platforms="linux/$arch,$platforms"
done

platforms=${platforms::-1}


# Login into docker
docker login --username $DOCKER_USER --password $DOCKER_PASS


# Push multi-arch image
buildctl build --frontend dockerfile.v0 \
      --local dockerfile=. \
      --local context=. \
      --output type=image,name=docker.io/$REPO:$BUILD,push=true \
      --opt platform=$platforms \
      --opt "build-arg:BASE=$BASE" \
      --opt "build-arg:VCS_REF=$(git rev-parse --short HEAD)" \
      --opt "build-arg:VCS_URL=$(git config --get remote.origin.url)" \
      --opt "build-arg:BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
      --opt "build-arg:MAINTAINER=$MAINTAINER" \
      --opt "build-arg:NAME=$NAME" \
      --opt "build-arg:DESCRIPTION=$DESCRIPTION" \
      --opt "build-arg:URL=$URL" \
      --opt filename=./Dockerfile.cross

# Push image for every arch with arch prefix in tag
for arch in $ARCHITECTURES
do
# Build for all architectures and push manifest
  buildctl build --frontend dockerfile.v0 \
      --local dockerfile=. \
      --local context=. \
      --output type=image,name=docker.io/$REPO:$BUILD-$arch,push=true \
      --opt platform=linux/$arch \
      --opt "build-arg:BASE=$BASE" \
      --opt "build-arg:VCS_REF=$(git rev-parse --short HEAD)" \
      --opt "build-arg:VCS_URL=$(git config --get remote.origin.url)" \
      --opt "build-arg:BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
      --opt "build-arg:MAINTAINER=$MAINTAINER" \
      --opt "build-arg:NAME=$NAME" \
      --opt "build-arg:DESCRIPTION=$DESCRIPTION" \
      --opt "build-arg:URL=$URL" \
      --opt filename=./Dockerfile.cross &
done

wait

docker pull $REPO:$BUILD-arm
docker tag $REPO:$BUILD-arm $REPO:$BUILD-armhf
docker push $REPO:$BUILD-armhf
