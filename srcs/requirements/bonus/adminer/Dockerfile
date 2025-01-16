FROM alpine:3.15.0

COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

RUN /usr/local/bin/setup.sh

COPY /conf/www.conf /etc/php8/php-fpm.d/www.conf

EXPOSE 9000
STOPSIGNAL SIGQUIT


CMD ["php-fpm8", "--nodaemonize"]
