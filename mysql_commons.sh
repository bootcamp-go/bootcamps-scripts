MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}

. ./colors.sh --source-only

# Check if mysql is currently running
function check_mysql_running() {
    if [ -z "$(ps -ef | grep mysql | grep -v grep)" ]; then
        echo -e "${Red}MySQL is not running.${NC}"
        start_mysql
    fi
}

# Start mysql
function start_mysql() {
    echo -e "${Green}Starting mysql...${NC}"
    sudo service mysql start
}


# Check if mysql is installed
function check_mysql_installed() {
    if [ -z "$(which mysql)" ]; then
        echo -e "${Red}MySQL is not installed.${NC}"
        install_mysql
    fi
}

# Install mysql using homebrew
function install_mysql() {
   echo -e "${Green}Installing mysql...${NC}"
   brew install mysql
   check_mysql_running
}

# Get the mysql root password from the user
function get_mysql_root_password() {
    echo "Please enter the mysql root password"
    read MYSQL_ROOT_PASSWORD
    echo
}

main() {
    check_mysql_installed
    check_mysql_running
}

if [ "${1}" != "--source-only" ]; then
    main "${@}"
fi