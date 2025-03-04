FROM qcastel/maven-release:0.0.15

RUN apk add --no-cache curl yq git

# Copy the entrypoint script
COPY ./entrypoints.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoints.sh

WORKDIR /