#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

update_system() {
  echo "System updating ...."
  sudo apt-get update
  echo "System update complete!"
}

install_node() {
  echo "installing node..."

  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt-get install -y nodejs

  sudo apt-get install -y build-essential
  echo "Node installation complete!"
}

install_yarn() {
  echo "installing yarn..."

  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt-get update && sudo apt-get install yarn
  echo "Yarn installation complete!"
}

setup_repo() {
  echo "setting up repo..."
  cd ~
  if [[ -d "Bucketlist-react" ]]; then
      rm -rf Bucketlist-react
  fi
  git clone https://github.com/cjmash/Bucketlist-react.git
  cd Bucketlist-react
  echo "Repo setup successful!"
}

install_dependencies() {
  echo "installing dependencies..."
  yarn install
  echo "Dependencies installed succesfully!"
}

start_app() {
  echo "starting app..."
  yarn start
}

main() {
  echo "Server provisioning in progress..."
  
  set -o errexit
  set -o pipefail
  set -o nounset

  update_system
  install_node
  install_yarn
  setup_repo
  install_dependencies
  start_app
}

main
