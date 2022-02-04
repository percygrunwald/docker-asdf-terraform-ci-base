#!/usr/bin/env bash

# Commit the latest Dockerfile changes
#
# Required env vars:
#   - COMMIT_MESSAGE
#   - CURRENT_DIGEST_SHORT
#   - DATETIME
#
# Other dependencies
#   - git config user.email and user.name set

set -e

git add Dockerfile
git commit -m "${COMMIT_MESSAGE}" --author "${GIT_AUTHOR_NAME}"
