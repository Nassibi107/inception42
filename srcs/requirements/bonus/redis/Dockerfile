FROM debian:bullseye


RUN apt-get update && \
    apt-get install -y redis && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/redisConfig.sh /tmp/redisConfig.sh

RUN chmod +x /tmp/redisConfig.sh

EXPOSE 6379


ENTRYPOINT ["sh", "/tmp/redisConfig.sh"]