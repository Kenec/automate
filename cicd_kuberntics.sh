#!/usr/bin/env bash

# script exits when a command fails.
set -o errexit 
# exit when script tries to use undeclared variables.
set -o nounset

install_kubect1() {
  echo "Installing Kubect1 ...."
  gcloud components install kubectl
  echo "Kubect1 installed!!"
}

# use gcloud to configure two default settings:
# a. default project and
# b. compute zone.

set_default_project() {
  echo "Setting default project ..."
  gcloud config set project [PROJECT_ID]
  echo "Default project set!"
}

set_default_zone() {
  echo "Setting default zone ..."
  gcloud config set compute/zone [COMPUTE_ZONE]
  echo "Defaul zone set!"
}

create_kubect_cluster() {
  echo "Creating Kubect cluster ..."
  gcloud container clusters create [CLUSTER_NAME]
  echo "Kubect cluster created !!"
}

authenticate_cluster() {
  echo "Authenticating cluster ..."
  gcloud container clusters get-credentials [CLUSTER_NAME]
  echo "cluster Authenticated!!"
}
