#!/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'


bong() {
    nc -zv mariadb 3306  &> /dev/null
    return $?
}

tts=$(date +%s)
tte=$((tts + 25))
while [ $(date +%s) -lt $tte ]; do
    if bong; then
        echo -e "${GREEN}[========🎉 MARIADB IS READY! 🎉========]${RESET}"
        break
    else
        echo -e "${YELLOW}⏳ WAITING FOR MARIADB TO RUN... ⏳${RESET}"
        sleep 1
    fi
done

if [ $(date +%s) -ge $end_time ]; then
    echo -e "${RED} ❌ MARIADB IS NOT RESPONDING AFTER ~25 SECONDS~ ❌${RESET}"
    exit 1
fi

if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi


cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress


check_core_files() {
    wp core is-installed --allow-root &> /dev/null
    return $?
}


if check_core_files; then
    echo -e "${GREEN} ✅ WordPress core already present ${RESET}"
else
    echo -e "${GREEN} ⚙️ WP config .... ${RESET}"
    find /var/www/wordpress/ -mindepth 1 -delete

    wp core download --allow-root

    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" \
                    --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" \
                    --allow-root

    wp core install --url="$DNS_LOCAL" --title="$WP_TITLE" \
                    --admin_user="$WP_USER_ADMIN" --admin_password="$WP_PASS_ADMIN" \
                    --admin_email="$WP_EMAIL_ADMIN" --allow-root

    wp user create "$WP_USER_UINIT" "$WP_EMAIN_UINIT" \
                    --user_pass="$WP_PASS_UINIT" --role="$WP_ROLE_UINIT" \
                    --allow-root

    echo -e  "${GREEN}. ...⚙️........⚙️ ....⚙️.....⚙️.....  ${RESET}"
fi

sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F
