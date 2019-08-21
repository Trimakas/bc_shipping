#!/usr/bin/env bash

set -ex

# gcloud components install kubectl --quiet
gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud config set project $PROJECT_ID
gcloud config set compute/zone $ZONE
