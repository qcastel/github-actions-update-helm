FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget python3 python3-pip && \
    wget https://github.com/mikefarah/yq/releases/download/v4.9.8/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq

# Set the working directory
WORKDIR /github/workspace

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
