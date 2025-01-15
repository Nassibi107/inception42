#!/bin/env sh

REDIS_CONF="/etc/redis/redis.conf"
REDIS_CONF_BAK="${REDIS_CONF}.bak"

# Check if the backup file already exists
if [ ! -f "$REDIS_CONF_BAK" ]; then
    # Create a backup of the original configuration
    cp "$REDIS_CONF" "$REDIS_CONF_BAK"
    # Update the Redis configuration
    sed -i "s|^bind 127.0.0.1|#bind 127.0.0.1|g" "$REDIS_CONF"
    # Uncomment and set the requirepass if needed
    # sed -i "s|^# requirepass foobared|requirepass $REDIS_PWD|g" "$REDIS_CONF"
    sed -i "s|^# maxmemory <bytes>|maxmemory 2mb|g" "$REDIS_CONF"
    sed -i "s|^# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" "$REDIS_CONF"
fi

# Start Redis server with protected mode disabled
exec redis-server --protected-mode no
