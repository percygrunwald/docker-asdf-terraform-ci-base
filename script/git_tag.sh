#!/usr/bin/env bash

# Tag the latest Dockerfile commit
#
# Required env vars:
#   - COMMIT_HASH
#   - CURRENT_DIGEST_SHORT
#   - RELEASE_TAG
#
# Other dependencies
#   - git config user.email and user.name set

set -e

UBUNTU_TAG="ubuntu-${CURRENT_DIGEST_SHORT//:/-}"

git tag -a -m "${RELEASE_TAG} - ${UBUNTU_TAG}" "${RELEASE_TAG}" "${COMMIT_HASH}"

# Use -f since this tag will move if there is a new build based off the same
# version of the base image (e.g. update deps)
git tag -a -f -m "${UBUNTU_TAG} - ${RELEASE_TAG}" "${UBUNTU_TAG}" "${COMMIT_HASH}"
