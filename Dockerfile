FROM qcastel/maven-release:0.0.15

RUN apk add --no-cache curl yq git


# Copy the entrypoint script
COPY entrypoints.sh /entrypoints.sh
COPY add-ssh-key.sh /add-ssh-key.sh
RUN chmod +x /entrypoints.sh
RUN chmod +x /add-ssh-key.sh

ENTRYPOINT ["/entrypoints.sh"]
