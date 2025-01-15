FROM debian:buster

RUN apt-get update && \
    apt-get install -y redis && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/redisConfig.sh /tmp/redisConfig.sh

RUN chmod +x /tmp/redis.sh

EXPOSE 6379

ENTRYPOINT ["sh", "/tmp/redis.sh"]
