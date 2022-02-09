#!/usr/bin/env bash

# Push image to Docker Hub
#
# Required env vars:
#   - COMMIT_HASH
#   - IMAGE_NAME
#   - IMAGE_UNIQUE
#   - DOCKER_USERNAME
#   - DOCKER_PASSWORD

set -e

DOCKER_USERNAME=${DOCKER_USERNAME:-percygrunwald}

docker image tag ${IMAGE_UNIQUE} ${IMAGE_NAME}:latest
docker image tag ${IMAGE_UNIQUE} ${IMAGE_NAME}:git-${COMMIT_HASH}
docker image tag ${IMAGE_UNIQUE} ${IMAGE_NAME}:ubuntu-${CURRENT_DIGEST_SHORT//:/-}
docker image ls >&2
echo "${DOCKER_PASSWORD}" | docker login --username ${DOCKER_USERNAME} --password-stdin
docker image push --all-tags ${IMAGE_NAME}
