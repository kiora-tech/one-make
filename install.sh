#!/bin/bash

# Déterminer le chemin vers la racine du projet
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../../.."
ONE_MAKE_PATH="vendor/kiora/one-make/make"

# Récupération des informations de l'utilisateur
read -p "Entrez l'IP du serveur de préproduction : " preprod_ip
read -p "Entrez le nom d'utilisateur du serveur de préproduction : " preprod_user
read -p "Entrez le nom d'utilisateur de la base de données : " db_user
read -p "Entrez l'hôte de la base de données : " db_host
read -p "Entrez le nom de la base de données : " db_name
read -p "Entrez le port de la base de données : " db_port

# Recherche de l'utilisation de MySQL ou PostgreSQL dans le fichier .env
db_type=""
if grep -q "DATABASE_URL=mysql" "$PROJECT_ROOT/.env"; then
  db_type="mysql"
elif grep -q "DATABASE_URL=pgsql" "$PROJECT_ROOT/.env"; then
  db_type="pgsql"
else
  read -p "Utilisez-vous MySQL ou PostgreSQL (mysql/pgsql) ? " db_type
fi

echo "PHP = php" >> "$PROJECT_ROOT/Makefile"

# Vérification de l'utilisation de Docker
use_docker=false
if [ -f "$PROJECT_ROOT/Dockerfile" ] || [ -f "$PROJECT_ROOT/docker-compose.yml" ]; then
  use_docker=true
fi

# Génération du fichier Makefile
echo "PREPROD_IP=$preprod_ip" > "$PROJECT_ROOT/Makefile"
echo "PREPROD_USER=$preprod_user" >> "$PROJECT_ROOT/Makefile"
echo "DB_USER=$db_user" >> "$PROJECT_ROOT/Makefile"
echo "DB_HOST=$db_host" >> "$PROJECT_ROOT/Makefile"
echo "DB_NAME=$db_name" >> "$PROJECT_ROOT/Makefile"
echo "DB_PORT=$db_port" >> "$PROJECT_ROOT/Makefile"
echo "DB_TYPE=$db_type" >> "$PROJECT_ROOT/Makefile"

echo "include $ONE_MAKE_PATH/$db_type.mk" >> "$PROJECT_ROOT/Makefile"
if [ "$use_docker" = true ]; then
  echo "include $ONE_MAKE_PATH/docker.mk" >> "$PROJECT_ROOT/Makefile"
fi
echo "include $ONE_MAKE_PATH/help.mk" >> "$PROJECT_ROOT/Makefile"
echo "include $ONE_MAKE_PATH/symfony.mk" >> "$PROJECT_ROOT/Makefile"

echo "Makefile généré avec succès !"