#!/bin/sh

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
MYSQL_DATABASE="melisprint"
MYSQL_USER="meli_sprint_user"
MYSQL_PASS="Meli_Sprint#123"
# ANSI colors variables for shell scripts
    Black='\E[0;30m'
    Red='\E[0;31m'
    Green='\E[0;32m'
    Yellow='\E[0;33m'
    Blue='\E[0;34m'
    Purple='\E[0;35m'
    Cyan='\E[0;36m'
    White='\E[0;37m'
    Grey='\E[0;37m'
    LightGrey='\E[0;37m'
    LightRed='\E[1;31m'
    LightGreen='\E[1;32m'
    LightYellow='\E[1;33m'
    LightBlue='\E[1;34m'
    LightPurple='\E[1;35m'
    LightCyan='\E[1;36m'
    LightWhite='\E[1;37m'
    NC='\E[0m'

# Check if mysql is currently running
check_mysql_running() {
    if [ -z "$(ps -ef | grep mysql | grep -v grep)" ]; then
        echo -e "${Red}MySQL is not running.${NC}"
        start_mysql
    fi
}

# Start mysql
start_mysql() {
    echo -e "${Green}Starting mysql...${NC}"
    sudo service mysql start
}


# Check if mysql is installed
check_mysql_installed() {
    if [ -z "$(which mysql)" ]; then
        echo -e "${Red}MySQL is not installed.${NC}"
        install_mysql
    fi
}

# Install mysql using homebrew
install_mysql() {
   echo -e "${Green}Installing mysql...${NC}"
   brew install mysql
   check_mysql_running
}

# Get the mysql root password from the user
get_mysql_root_password() {
    echo "Please enter the mysql root password"
    read MYSQL_ROOT_PASSWORD
    echo
}

# Use the mysql root password to create the database
create_database() {
    get_mysql_root_password
    echo -e "${Blue}Creating database ${MYSQL_DATABASE}${NC}"
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE"
    mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < db.sql
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASS'"
	mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON * . * TO '$MYSQL_USER'@'localhost'"
	mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES"
}

rebuild_database() {
    get_mysql_root_password
    echo -e "${Blue}Rebuilding database ${MYSQL_DATABASE}...${NC}"
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP DATABASE IF EXISTS $MYSQL_DATABASE"
	mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE"
	mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < db.sql
	mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES"
}

main() {
    check_mysql_installed
    check_mysql_running
    # if argument is "create" then create the database and if its "rebuild" then rebuild the database
    if [ "$1" = "create" ]; then
        create_database
    elif [ "$1" = "rebuild" ]; then
        rebuild_database
    else
        echo -e "${Red}Invalid argument.${NC}"
        echo -e "${Blue}Usage: ./build_meli_database.sh [create|rebuild]${NC}"
    fi
}

main $1