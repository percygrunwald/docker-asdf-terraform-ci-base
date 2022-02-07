#!/usr/bin/env bash

# Update the Dockerfile if there is a newer digest of Ubuntu 20.04, build the
# image, test the image, create a commit and upload the built image to Docker
# Hub.
#
# Required env vars:
#   - DOCKER_PASSWORD
#
# Optional env vars:
#   - IMAGE_NAME
#   - GIT_AUTHOR_NAME
#   - GIT_AUTHOR_EMAIL
#   - DOCKER_USERNAME

UPDATE_DOCKERFILE=n
GIT_COMMIT=n
GIT_TAG=n
DOCKER_PUSH=n
while getopts 'cptu' OPTION; do
  case ${OPTION} in
    c ) GIT_COMMIT=y ;;
    p ) DOCKER_PUSH=y ;;
    t ) GIT_TAG=y ;;
    u ) UPDATE_DOCKERFILE=y ;;
    * ) printf "Usage: %s [-u]\n" ${0##*/} >&2
        exit 2
        ;;
  esac
done
shift $(($OPTIND - 1))

set -e
SCRIPT_DIR=$(dirname "$0")

# Update digest
CURRENT_DIGEST=$(grep "^FROM" Dockerfile | cut -d'@' -f2-)
if [ "${UPDATE_DOCKERFILE}" == y ]; then
  printf "Updating Dockerfile if necessary...\n" >&2

  LATEST_DIGEST=$(${SCRIPT_DIR}/get_latest_digest.sh)

  printf "Latest digest:\t'%s'\n" "${LATEST_DIGEST}" >&2
  printf "Current digest:\t'%s'\n" "${CURRENT_DIGEST}" >&2

  if [ "${CURRENT_DIGEST}" == "${LATEST_DIGEST}" ]; then
    printf "Digests are equal, doing nothing.\n" >&2
    exit 0
  fi

  printf "Digests are not equal, updating Dockerfile...\n" >&2
  sed -e "s/${CURRENT_DIGEST}/${LATEST_DIGEST}/" -i ./Dockerfile
  CURRENT_DIGEST=${LATEST_DIGEST}
fi

# Build
printf "Building docker image...\n" >&2
DATETIME=$(date -u +"%Y-%m-%d-%H%M%S")
RELEASE_TAG="v${DATETIME}"
export IMAGE_NAME=${IMAGE_NAME:-percygrunwald/docker-asdf-terraform-ci-base}
export IMAGE_UNIQUE="${IMAGE_NAME}:${RELEASE_TAG}"
${SCRIPT_DIR}/docker_build.sh

# Test
printf "Testing docker image...\n" >&2
docker run --rm -v $PWD:/repo ${IMAGE_UNIQUE} /repo/script/test.sh

# Commit and tag
export RELEASE_TAG
export CURRENT_DIGEST_SHORT="${CURRENT_DIGEST:0:16}"
export COMMIT_MESSAGE="Updates Dockerfile to ubuntu@${CURRENT_DIGEST_SHORT}"
GIT_AUTHOR_NAME=${GIT_AUTHOR_NAME:-"Percy Grunwald"}
GIT_AUTHOR_EMAIL=${GIT_AUTHOR_EMAIL:-"percy.grunwald@gmail.com"}
git config --global user.email "${GIT_AUTHOR_EMAIL}"
git config --global user.name "${GIT_AUTHOR_NAME}"
if [ "${GIT_COMMIT}" == y ]; then
  printf "Running git commit...\n" >&2
  ${SCRIPT_DIR}/git_commit.sh
fi
if [ "${GIT_TAG}" == y ]; then
  printf "Applying git tags...\n" >&2
  ${SCRIPT_DIR}/git_tag.sh
fi

# Push
if [ "${DOCKER_PUSH}" == y ]; then
  printf "Running docker push...\n" >&2
  export IMAGE_NAME
  export IMAGE_UNIQUE
  export DOCKER_USERNAME=${DOCKER_USERNAME:-percygrunwald}
  export DOCKER_PASSWORD
  ${SCRIPT_DIR}/docker_push.sh
fi

printf "::set-output name=release-tag::${RELEASE_TAG}\n"
