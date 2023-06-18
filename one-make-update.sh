#!/bin/bash

source one-make-common.sh

# Update the files in LOCAL_MAKE_PATH
update_files() {
  for file in $(ls -1 $LOCAL_MAKE_PATH)
  do
    if [ -f "$ONE_MAKE_PATH/$file" ]; then
        cp "$ONE_MAKE_PATH/$file" "$LOCAL_MAKE_PATH/$file"
    fi
  done
}

update_files
