FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y  vim zsh wget git nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/ynassibi_1337.crt -keyout \
    /etc/nginx/ssl/ynassibi_42.key -subj "/C=MO/ST=KH/L=KH/O=1337/OU=1337/CN=ynassibi/UID=ynassibi"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

EXPOSE 433

CMD ["nginx", "-g", "daemon off;"]