#!/bin/env sh

REDIS_CONF="/etc/redis/redis.conf"
REDIS_CONF_BAK="${REDIS_CONF}.bak"

if [ ! -f "$REDIS_CONF_BAK" ]; then
    cp "$REDIS_CONF" "$REDIS_CONF_BAK"
    
    echo "maxmemory 256mb" >> "$REDIS_CONF"

    echo "maxmemory-policy allkeys-lru" >> "$REDIS_CONF"

    sed -i -r "s/bind 127.0.0.1/#bind 127.0.0.0/" "$REDIS_CONF"
fi

exec redis-server --protected-mode no
