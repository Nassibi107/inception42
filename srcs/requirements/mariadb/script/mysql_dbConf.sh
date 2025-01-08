#!/bin/bash

start_mariadb() {
    echo "Starting MariaDB service..."
    service mariadb start
    while ! mysqladmin ping --silent; do sleep 1; done
}

configure_mariadb() {
    echo "Configuring MariaDB..."
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"
    mariadb -e "FLUSH PRIVILEGES;"
}

restart_mariadb() {
    echo "Restarting MariaDB..."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
}

start_mariadb
configure_mariadb
restart_mariadb
