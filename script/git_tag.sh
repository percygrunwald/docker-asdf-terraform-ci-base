#!/usr/bin/env bash

# Tag the latest Dockerfile commit
#
# Required env vars:
#   COMMIT_MESSAGE
#   CURRENT_DIGEST_SHORT
#   DATETIME

set -e

git tag -a -m "${COMMIT_MESSAGE}" "${DATETIME}"
git tag -a -m "${COMMIT_MESSAGE}" "ubuntu-${CURRENT_DIGEST_SHORT//:/-}"
