#!/usr/bin/env bash

set -ex

docker_helper () {
    yes | gcloud auth configure-docker
    docker pull $FULL_CACHE_IMAGE_NAME
    docker build --cache-from $FULL_CACHE_IMAGE_NAME -f Dockerfile -t $FULL_IMAGE_NAME --network=host .
    docker push ${FULL_IMAGE_NAME}
    yes | gcloud container images add-tag ${FULL_IMAGE_NAME} gcr.io/$PROJECT_ID/${IMAGE_NAME}:${TRAVIS_COMMIT}
    yes | gcloud container images add-tag ${FULL_IMAGE_NAME} ${FULL_CACHE_IMAGE_NAME}
}

if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "staging" ]]
then
    IMAGE_TAG=staging-latest
    CACHE_IMAGE_TAG=cache-latest
    FULL_IMAGE_NAME=gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}
    FULL_CACHE_IMAGE_NAME=gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${CACHE_IMAGE_TAG}
    # run the docker function
    docker_helper
elif [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]
then
    IMAGE_TAG=production-latest
    CACHE_IMAGE_TAG=production-cache-latest
    FULL_IMAGE_NAME=gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}
    FULL_CACHE_IMAGE_NAME=gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${CACHE_IMAGE_TAG}
    # run the docker function
    docker_helper
fi