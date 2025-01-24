
wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php 
chown -R www-data:www-data /var/www/html/adminer.php 
chmod 755 /var/www/html/adminer.php

mv ./adminer-4.8.1.php /var/www/html/index.php

cd /var/www/html
adduser -u 82 -D -S -G www-data www-data
rm -rf index.html

php-fpm8 --nodaemonize