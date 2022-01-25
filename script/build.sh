#!/usr/bin/env bash

docker build --file Dockerfile --tag percygrunwald/docker-ci-base .

docker images
