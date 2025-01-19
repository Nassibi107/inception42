FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php7.4-fpm \
    git netcat mycli \
    php-mysql mariadb-client wget 

COPY /conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY /tools/wpc.sh /

RUN  chmod +x wpc.sh

RUN mkdir wp_log

EXPOSE 9000

ENTRYPOINT ["bash","./wpc.sh"]