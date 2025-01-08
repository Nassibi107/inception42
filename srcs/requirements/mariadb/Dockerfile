
FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        mariadb-server \
        vim \
        wget \
        git \
        mycli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY script/mysql_dbConf.sh /mysql_dbConf.sh

# Ensure the configuration script is executable
RUN chmod +x /mysql_dbConf.sh

# Set the script as the container's entrypoint
ENTRYPOINT ["/mysql_dbConf.sh"]
