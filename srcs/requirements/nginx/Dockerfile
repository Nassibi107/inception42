FROM debian:bullseye

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim zsh wget git nginx openssl php7.4-fpm php7.4-mysql php7.4-cli

# Create SSL directory and generate self-signed certificates
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/ynassibi_1337.crt -keyout \
    /etc/nginx/ssl/ynassibi_42.key -subj "/C=MO/ST=KH/L=KH/O=1337/OU=1337/CN=ynassibi/UID=ynassibi"

# Generate DH parameters for stronger security
RUN mkdir -p /etc/ssl/certs

# Copy the Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set up WordPress directory (you may need to configure this with Docker volumes later)
RUN mkdir -p /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress

# Expose necessary ports
EXPOSE 443

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
