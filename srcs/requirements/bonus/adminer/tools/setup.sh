#!/bin/sh

PACKAGES=" \
    curl \
    less \
    mariadb-client \
    php8 \
    php8-fpm \
    php8-common \
    php8-session \
    php8-iconv \
    php8-json \
    php8-gd \
    php8-curl \
    php8-xml \
    php8-mysqli \
    php8-imap \
    php8-pdo \
    php8-pdo_mysql \
    php8-soap \
    php8-posix \
    php8-gettext \
    php8-ldap \
    php8-ctype \
    php8-dom \
    php8-simplexml"

apk update && apk add --no-cache $PACKAGES


curl -L -O https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php
mkdir -p /var/www/html
mv ./adminer-4.8.1.php /var/www/html/index.php

adduser -u 82 -D -S -G www-data www-data
