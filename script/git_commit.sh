#!/usr/bin/env bash

# Commit the latest Dockerfile changes
#
# Required env vars:
#   COMMIT_MESSAGE
#   COMMIT_AUTHOR
#   CURRENT_DIGEST_SHORT
#   DATETIME

set -e

git add Dockerfile
git commit -m "${COMMIT_MESSAGE}" --author "${COMMIT_AUTHOR}"
