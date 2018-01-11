#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

create_directory(){
  echo "Creating a directory ..."
  mkdir -p okbb
  echo "Directory Okbb created"
}

move_directory(){
  echo "Move directory ...."
  mv okbb terraform/
  echo "Directory moved"
}

copy_file(){
  echo "Copying file from setup.sh to setup_backup.sh"
  cp setup setup_backup.sh
  echo "File copied"
}

list_dir_content(){
  echo "Directory contents ..."
  ls -a
  echo "There you go!"
}

say_your_masters_name(){
  echo "Hello master! I think I found your name: " $@
}

say_your_masters_name "echo 'Kene'"