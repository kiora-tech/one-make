#!/bin/bash

# Determine the path to the project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../.."
ONE_MAKE_PATH="vendor/kiora/one-make/make"
LOCAL_MAKE_PATH="$PROJECT_ROOT/make"

# Function to create the 'make' directory if it doesn't exist
create_make_dir() {
  if [ ! -d "$LOCAL_MAKE_PATH" ]; then
    mkdir -p "$LOCAL_MAKE_PATH"
  fi
}
