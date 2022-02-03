#!/usr/bin/env bash

# Build the image and return the image name with tag
#
# Required env vars:
#   IMAGE_NAME
#   IMAGE_UNIQUE

set -e

docker image ls ${IMAGE_NAME} | tail -n +2 | while read _ TAG _; do
  docker image rm -f ${IMAGE_NAME}:${TAG}
done
docker build --tag ${IMAGE_UNIQUE} .
