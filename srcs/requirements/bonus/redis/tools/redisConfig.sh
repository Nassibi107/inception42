#!/bin/env sh

REDIS_CONF="/etc/redis/redis.conf"
REDIS_CONF_BAK="${REDIS_CONF}.bak"

if [ ! -f "$REDIS_CONF_BAK" ]; then
    cp "$REDIS_CONF" "$REDIS_CONF_BAK"
    
    sed -i "s|^bind 127.0.0.1|#bind 127.0.0.1|g" "$REDIS_CONF"
    sed -i "s|^# maxmemory <bytes>|maxmemory 2mb|g" "$REDIS_CONF"
    sed -i "s|^# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" "$REDIS_CONF"
fi

exec redis-server --protected-mode no
