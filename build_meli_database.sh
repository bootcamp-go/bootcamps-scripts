#!/bin/sh

# Import mysql_commons.sh functions
. ./mysql_commons.sh --source-only
. ./colors.sh --source-only

# Variables
MYSQL_DATABASE="test"
MYSQL_USER="meli_sprint_user"
MYSQL_PASS="Meli_Sprint#123"

# Use the mysql root password to create the database
function create_database() {
    get_mysql_root_password
    echo -e "${Blue}Creating database ${MYSQL_DATABASE}${NC}"
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE"
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e $MYSQL_DATABASE < db.sql
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASS'"
	mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON * . * TO '$MYSQL_USER'@'localhost'"
	mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES"
}

function main() {
    check_mysql_installed
    check_mysql_running
    create_database
}

main