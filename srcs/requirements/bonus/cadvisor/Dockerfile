FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y wget && \
    wget https://github.com/google/cadvisor/releases/download/v0.37.0/cadvisor -O /usr/local/bin/cadvisor && \
    chmod +x /usr/local/bin/cadvisor && \
    apt remove -y wget && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8080

ENTRYPOINT ["/bin/bash"]

CMD ["/usr/local/bin/cadvisor"]
