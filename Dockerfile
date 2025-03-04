FROM qcastel/maven-release:0.0.15

RUN apk add --no-cache curl yq git

# Copy the entrypoint script
COPY entrypoints.sh /entrypoints.sh
RUN chmod +x /entrypoints.sh

WORKDIR /