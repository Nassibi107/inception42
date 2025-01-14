#!/bin/bash

LOG_DIR="/var/www/wordpress/logs"
mkdir -p $LOG_DIR

cp /var/log/nginx/access.log $LOG_DIR/access.log
cp /var/log/nginx/error.log $LOG_DIR/error.log


tar -czf $LOG_DIR/nginx_logs_$(date +%F).tar.gz -C $LOG_DIR access.log error.log


> /var/log/nginx/access.log
> /var/log/nginx/error.log

echo "Logs copied and compressed."
