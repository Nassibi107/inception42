FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y nginx openssl  wget vim 

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/ynassibi.crt -keyout \
    /etc/nginx/ssl/ynassibi.key -subj "/C=MO/ST=KH/L=KH/O=1337/OU=1337/CN=ynassibi.42.fr/UID=ynassibi"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

RUN rm /etc/nginx/sites-enabled/default

CMD ["nginx", "-g", "daemon off;"]