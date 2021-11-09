#!/bin/sh

# Import mysql_commons.sh functions
. ./mysql_commons.sh --source-only
. ./colors.sh --source-only

# Variables
MYSQL_DATABASE="test"
MYSQL_USER="meli_sprint_user"
MYSQL_PASS="Meli_Sprint#123"

# Use the mysql root password to rebuild the database
function rebuild_database() {
    get_mysql_root_password
    echo -e "${Blue}Rebuilding database ${MYSQL_DATABASE}...${NC}"
    @mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP DATABASE IF EXISTS $MYSQL_DATABASE"
	@mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE"
	@mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < db.sql
	@mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES"
}

function main() {
    check_mysql_installed
    check_mysql_running
    create_database
}

main