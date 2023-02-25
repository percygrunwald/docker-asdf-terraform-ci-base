#!/usr/bin/env bash

# Check for the latest digest of the Ubuntu $TAG Docker image

set -e

AUTH_SERVICE="registry.docker.io"
REPO="library/ubuntu"
TAG=20.04
AUTH_SCOPE="repository:${REPO}:pull"
REGISTRY_URL="https://index.docker.io"
AUTH_URL="https://auth.docker.io/token?service=${AUTH_SERVICE}&scope=${AUTH_SCOPE}"
TOKEN=$(curl -s ${AUTH_URL} | jq -r '.["token"]')
MANIFEST_URL="${REGISTRY_URL}/v2/${REPO}/manifests/${TAG}"

LATEST_DIGEST=$(curl -s -H 'Accept: application/vnd.oci.image.index.v1+json' \
  -H "Authorization: Bearer $TOKEN" ${MANIFEST_URL} \
  | jq -r '.["manifests"][] | select(.["platform"]["architecture"] == "amd64") | .["digest"]')

printf "${LATEST_DIGEST}\n"
