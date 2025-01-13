FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php7.4-fpm \
    php-mysql mariadb-client wget \
    vim  git netcat mycli

COPY /conf/www.conf /var/www/html/

COPY /tools/wpc.sh /

RUN  chmod +x wpc.sh

RUN mkdir wp_log

EXPOSE 9000

ENTRYPOINT ["bash","./wpc.sh"]