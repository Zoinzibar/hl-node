# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y curl tar cron && \
    apt-get clean

# Create necessary directories with appropriate permissions for the 'ubuntu' user
RUN mkdir -p /home/ubuntu/hl/data /home/ubuntu/hl/data/replica_cmds /home/ubuntu/hl/data/periodic_abci_states /home/ubuntu/hl/data/visor_child_stderr && \
    chown -R ubuntu:ubuntu /home/ubuntu

# Switch to the 'ubuntu' user
USER ubuntu

# Set the working directory
WORKDIR /home/ubuntu/

# Download initial peers file
RUN curl https://binaries.hyperliquid.xyz/Testnet/initial_peers.json -o /home/ubuntu/initial_peers.json

# Configure chain to testnet
RUN echo '{"chain": "Testnet"}' > /home/ubuntu/visor.json

# Download non-validator configuration file
RUN curl https://binaries.hyperliquid.xyz/Testnet/non_validator_config.json -o /home/ubuntu/non_validator_config.json

# Download the visor binary and make it executable
RUN curl https://binaries.hyperliquid.xyz/Testnet/hl-visor -o /home/ubuntu/hl-visor && \
    chmod a+x /home/ubuntu/hl-visor

# Expose necessary ports
EXPOSE 8000
EXPOSE 9000

# Set the entrypoint to run the visor binary and cron daemon
ENTRYPOINT ["/home/ubuntu/hl-visor"]

