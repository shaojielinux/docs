#!/bin/bash

set -ex

image_biz_version=$1
CI_JOB_ID=$2

DOCKER_USERNAME=gitlab
DOCKER_PASSWORD=B3udHgG6n3ak!
DOCKER_SERVER=harbor.matrixport.dev

echo "$DOCKER_PASSWORD" | docker login $DOCKER_SERVER -u "$DOCKER_USERNAME" --password-stdin

script_dir=$(dirname "$0")
nvwa_dir=$(dirname "${script_dir}")
cd ${nvwa_dir}

docker build -f ./Dockerfile . -t ${DOCKER_SERVER}/spot/api-reference:${image_biz_version}_Build${CI_JOB_ID}

docker push ${DOCKER_SERVER}/spot/api-reference:${image_biz_version}_Build${CI_JOB_ID}

docker rmi ${DOCKER_SERVER}/spot/api-reference:${image_biz_version}_Build${CI_JOB_ID}

