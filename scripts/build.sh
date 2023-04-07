#!/usr/bin/env bash

# stop on first error
set -e

IMAGE_NAME=mathlore-dev

MLG_VERSION=$(grep MLG_VERSION fly.toml | sed 's| ||g' | sed 's|"||g')
MATHLORE_SHA=$(grep MATHLORE_SHA fly.toml | sed 's| ||g' | sed 's|"||g')

docker build --build-arg ${MLG_VERSION} --build-arg ${MATHLORE_SHA} -t ${IMAGE_NAME} .
docker run --publish 8080:8080 ${IMAGE_NAME}
