#!/usr/bin/env bash

# Tag the latest Dockerfile commit
#
# Required env vars:
#   - COMMIT_MESSAGE
#   - CURRENT_DIGEST_SHORT
#   - DATETIME
#
# Other dependencies
#   - git config user.email and user.name set

set -e

if [ ! $(git tag -l "${DATETIME}") ]; then
  git tag -a -m "${COMMIT_MESSAGE}" "${DATETIME}"
fi

UBUNTU_TAG="ubuntu-${CURRENT_DIGEST_SHORT//:/-}"
if [ ! $(git tag -l "${UBUNTU_TAG}") ]; then
  git tag -a -m "${COMMIT_MESSAGE}" "${UBUNTU_TAG}"
fi
