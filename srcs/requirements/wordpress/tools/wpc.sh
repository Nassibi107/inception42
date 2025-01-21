#!/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

bong() {
    nc -zv mariadb 3306 &> /dev/null
    return $?
}

pass=1
tts=$(date +%s)
tte=$((tts + 25))

# Wait for MariaDB to start
while [ $(date +%s) -lt $tte ]; do
    if bong; then
        echo -e "${GREEN}[========🎉 MARIADB IS READY! 🎉========]${RESET}"
        pass=0
        break
    else
        echo -e "${YELLOW}⏳ WAITING FOR MARIADB TO RUN... ⏳${RESET}"
        sleep 1
    fi
done

# Exit if MariaDB is not responsive
if [ $pass -ne 0 ]; then
    echo -e "${RED} ❌ MARIADB IS NOT RESPONDING AFTER ~25 SECONDS~ ❌${RESET}"
    exit 1
fi

# Install WP-CLI if it doesn't exist
if [ ! -f /usr/local/bin/wp ]; then
    echo -e "${YELLOW}Downloading WP-CLI...${RESET}"
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to download WP-CLI ❌${RESET}"
        exit 1
    fi
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Setup WordPress
cd /var/www/wordpress || exit 1
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress

wpChecker() {
    wp core is-installed --allow-root &> /dev/null
    return $?
}

# If WordPress isn't installed, install and configure it
if wpChecker; then
    echo -e "${GREEN} ✅ WordPress core already present ${RESET}"
else
    echo -e "${GREEN} ⚙️ Setting up WordPress... ${RESET}"
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

    pass=0
    echo -e "${GREEN}. ...⚙️........⚙️ ....⚙️.....⚙️..... ${RESET}"
fi

# Check if Redis is running, and set up caching
if [ $pass -eq 0 ]; then
    if nc -zv redis 6379 &> /dev/null; then
        echo -e "${GREEN} ✅ Redis is running! ${RESET}"

        # Enable Redis caching (no need for --host, --port, or --password)
        wp redis enable --allow-root
    else
        echo -e "${RED}❌ Redis is not running ❌${RESET}"
        exit 1
    fi

    # Update wp-config.php to configure Redis (no password needed)
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp plugin update --all --allow-root
    wp config set WP_CACHE_KEY_SALT "$DNS_LOCAL" --allow-root
    wp cache flush --allow-root
fi

# Update PHP-FPM config to listen on TCP/IP
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F
