#!/usr/bin/env bash

set -o errexit 
set -o nounset

export_metadata() {
  cd /home/kenechukwunnamani/PostIt
  curl http://metadata.google.internal/computeMetadata/v1/project/attributes/postit_metadata -H "Metadata-Flavor: Google" > .env
}

start_app() {
  NODE_ENV=production npm run build
  NODE_ENV=production npm run start
}

export_metadata
start_app
