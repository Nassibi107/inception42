#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

mariaDB_luncher() {
    echo -e "${GREEN}..🔥..Booting up MariaDB 🛠️.${RESET}"
    service mariadb start
    until mysqladmin ping --silent; do sleep 1; done
    echo -e "${GREEN}🚀--------------------🚀${RESET}"
}

mariaDB_tuning() {
    echo -e "${GREEN} Adjusting MariaDB configurations... 🧰${RESET}"
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"
    mariadb -e "FLUSH PRIVILEGES;"
    echo -e "${GREEN}⚙️--------------------⚙️${RESET}"
}

mariaDB_reloading() {
    echo -e "${GREEN} Restarting MariaDB... 🔄${RESET}"
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown 
    sleep 2
    mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql' 
    sleep 5
    echo -e "${GREEN} MariaDB restarted successfully! 🚀${RESET}"
}

mariaDB_luncher
mariaDB_tuning
mariaDB_reloading
