#!/bin/bash

# Determine the path to the project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../.."
ONE_MAKE_PATH="vendor/kiora/one-make/make"
LOCAL_MAKE_PATH="$PROJECT_ROOT/make"

# Function to get user input
get_user_input() {
  read -p "Enter the preproduction server IP: " preprod_ip
  read -p "Enter the preproduction server username: " preprod_user
  read -p "Enter the database username: " db_user
  read -p "Enter the database host: " db_host
  read -p "Enter the database name: " db_name
  read -p "Enter the database port: " db_port

  echo "PREPROD_IP=$preprod_ip" > "$LOCAL_MAKE_PATH/one-make.mk"
  echo "PREPROD_USER=$preprod_user" >> "$LOCAL_MAKE_PATH/one-make.mk"
  echo "DB_USER=$db_user" >> "$LOCAL_MAKE_PATH/one-make.mk"
  echo "DB_HOST=$db_host" >> "$LOCAL_MAKE_PATH/one-make.mk"
  echo "DB_NAME=$db_name" >> "$LOCAL_MAKE_PATH/one-make.mk"
  echo "DB_PORT=$db_port" >> "$LOCAL_MAKE_PATH/one-make.mk"
  echo "DB_TYPE=$db_type" >> "$LOCAL_MAKE_PATH/one-make.mk"
}


# Create the 'make' directory if it doesn't exist
if [ ! -d "$LOCAL_MAKE_PATH" ]; then
  mkdir "$LOCAL_MAKE_PATH"
fi

if [ -f "$LOCAL_MAKE_PATH/one-make.mk" ]; then
    echo "The required information is already present in the Makefile."
else
  # Search for the usage of MySQL or PostgreSQL in the .env file
  db_type=""
  if grep -q "DATABASE_URL=\"mysql" "$PROJECT_ROOT/.env"; then
    db_type="mysql"
  elif grep -q "DATABASE_URL=\"pgsql" "$PROJECT_ROOT/.env"; then
    db_type="pgsql"
  else
    read -p "Are you using MySQL or PostgreSQL (mysql/pgsql)? " db_type
  fi

  get_user_input
fi



# Check if Docker is being used
if [ -f "$PROJECT_ROOT/Dockerfile" ] || [ -f "$PROJECT_ROOT/docker-compose.yml" ]; then
  cp -n "$ONE_MAKE_PATH/docker.mk" "$LOCAL_MAKE_PATH/"
fi

if [ ! -z "$db_type" ]; then
  cp -n "$ONE_MAKE_PATH/$db_type.mk" "$LOCAL_MAKE_PATH/"
fi
cp -n "$ONE_MAKE_PATH/help.mk" "$LOCAL_MAKE_PATH/"
cp -n "$ONE_MAKE_PATH/symfony.mk" "$LOCAL_MAKE_PATH/"


# Check if PHPUnit is installed
if grep -q "\"phpunit/phpunit\"" "$PROJECT_ROOT/composer.json"; then
  cp -n "$ONE_MAKE_PATH/tests.mk" "$LOCAL_MAKE_PATH/"
fi


if [ -f "$PROJECT_ROOT/package.json" ]; then
  cp -n "$ONE_MAKE_PATH/node.mk" "$LOCAL_MAKE_PATH/"
fi


# Add "include make/*.mk" only if it's not already present in the Makefile
if ! grep -q "include make/\*.mk" "$PROJECT_ROOT/Makefile"; then
  echo ".DEFAULT_GOAL:=help" >> "$LOCAL_MAKE_PATH/one-make.mk"
  echo "include make/*.mk" >> "$PROJECT_ROOT/Makefile"
fi

echo "Successfully generated Makefile !"