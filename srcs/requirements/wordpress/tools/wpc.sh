#!/bin/env bash
ping_mariadb_container() {
    nc -zv mariadb 3306 > /dev/null
    return $?
}
start_time=$(date +%s)
end_time=$((start_time + 20))
while [ $(date +%s) -lt $end_time ]; do
    ping_mariadb_container
    if [ $? -eq 0 ]; then
        echo "[========MARIADB IS UP AND RUNNING========]"
        break
    else
        echo "[========WAITING FOR MARIADB TO START...========]"
        sleep 1
    fi
done

if [ $(date +%s) -ge $end_time ]; then
    echo "[========MARIADB IS NOT RESPONDING========]"
fi

#---------------------------------------------------wp installation---------------------------------------------------#

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress

check_core_files() {
    wp core is-installed --allow-root > /dev/null
    return $?
}
if ! check_core_files; then
    echo "[========WP INSTALLATION STARTED========]"
    find /var/www/wordpress/ -mindepth 1 -delete
    wp core download --allow-root
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
    wp core install --url="$DNS_LOCAL" --title="$WP_TITLE" --admin_user="$WP_USER_ADMIN" --admin_password="$WP_PASS_ADMIN" --admin_email="$WP_EMAIL_ADMIN" --allow-root
    wp user create "$WP_USER_UINIT" "$WP_EMAIN_UINIT" --user_pass="$WP_PASS_UINIT" --role="$WP_ROLE_UINIT" --allow-root
else
    echo "[========WordPress files already exist. Skipping installation========]"
fi

#---------------------------------------------------php config---------------------------------------------------#

sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F