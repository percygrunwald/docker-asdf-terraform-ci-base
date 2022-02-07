#!/usr/bin/env bash

# Tag the latest Dockerfile commit
#
# Required env vars:
#   - CURRENT_DIGEST_SHORT
#   - RELEASE_TAG
#
# Other dependencies
#   - git config user.email and user.name set

set -e

UBUNTU_TAG="ubuntu-${CURRENT_DIGEST_SHORT//:/-}"

if [ ! $(git tag -l "${RELEASE_TAG}") ]; then
  git tag -a -m "${RELEASE_TAG} - ${UBUNTU_TAG}" "${RELEASE_TAG}"
fi

if [ ! $(git tag -l "${UBUNTU_TAG}") ]; then
  git tag -a -m "${UBUNTU_TAG} - ${RELEASE_TAG}" "${UBUNTU_TAG}"
fi
