FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install redis-server php-redis -y

RUN echo "maxmemory 256mb" >> /etc/redis/redis.conf
RUN echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf
RUN sed -i -r "s/bind 127.0.0.1/#bind 127.0.0.0/" /etc/redis/redis.conf

ENTRYPOINT ["redis-server", "--protected-mode", "no"]