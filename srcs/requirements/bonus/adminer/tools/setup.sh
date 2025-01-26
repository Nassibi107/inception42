apt install php php-mysql wget -y 

wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php
chown -R www-data:www-data /var/www/html/adminer.php
chmod 755 /var/www/html/adminer.php

cd /var/www/html

rm -rf index.html

php -S 0.0.0.0:600 /var/www/html/adminer.php