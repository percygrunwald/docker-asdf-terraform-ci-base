#!/usr/bin/env bash

# Tag the latest Dockerfile commit
#
# Required env vars:
#   - COMMIT_MESSAGE
#   - CURRENT_DIGEST_SHORT
#   - RELEASE_TAG
#
# Other dependencies
#   - git config user.email and user.name set

set -e

if [ ! $(git tag -l "${RELEASE_TAG}") ]; then
  git tag -a -m "${COMMIT_MESSAGE}" "${RELEASE_TAG}"
fi

UBUNTU_TAG="ubuntu-${CURRENT_DIGEST_SHORT//:/-}"
if [ ! $(git tag -l "${UBUNTU_TAG}") ]; then
  git tag -a -m "${COMMIT_MESSAGE}" "${UBUNTU_TAG}"
fi
