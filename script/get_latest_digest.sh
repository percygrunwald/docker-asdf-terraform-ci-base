#!/usr/bin/env bash

# Check for the latest digest of the Ubuntu 20.04 Docker image

set -e

AUTH_URL='https://auth.docker.io/token?service=registry.docker.io&scope=repository:library/ubuntu:pull'
MANIFEST_URL='https://index.docker.io/v2/library/ubuntu/manifests/20.04'
TOKEN=$(curl -s ${AUTH_URL} | jq -r '.["token"]')
LATEST_DIGEST=$(curl -s -H 'Accept: application/vnd.docker.distribution.manifest.list.v2+json' \
  -H "Authorization: Bearer $TOKEN" ${MANIFEST_URL} \
  | jq -r '.["manifests"][] | select(.["platform"]["architecture"] == "amd64") | .["digest"]')

printf "${LATEST_DIGEST}\n"
