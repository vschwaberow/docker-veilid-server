# Use a Debian base image
FROM debian:latest

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND noninteractive

# Install necessary tools
RUN apt-get update && apt-get install -y \
    wget \
    gpg \
    apt-transport-https \
    software-properties-common \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Step 1: Add the GPG keys to your operating systems keyring
RUN wget -O- https://packages.veilid.net/gpg/veilid-packages-key.public | gpg --dearmor -o /usr/share/keyrings/veilid-packages-keyring.gpg

# Step 2: Add Veilid to your list of available software
# Assuming AMD64 architecture for Docker image
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/veilid-packages-keyring.gpg] https://packages.veilid.net/apt stable main" | tee /etc/apt/sources.list.d/veilid.list

# Step 4: Refresh the package manager and install Veilid
RUN apt-get update && apt-get install -y veilid-server veilid-cli

# Copy the veilid-server.conf file from the local directory to the container
COPY veilid-server.conf /etc/veilid-server/veilid-server.conf

# Expose the required ports
EXPOSE 5959/tcp 5050/tcp 5050/udp

# Set entrypoint to start Veilid server
# This assumes that the veilid-server can be started directly. Adjust if necessary.
# ENTRYPOINT ["veilid-server"]

CMD ["/usr/bin/veilid-server","--foreground"]