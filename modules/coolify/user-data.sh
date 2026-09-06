#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Set hostname
hostnamectl set-hostname ${hostname}

# Install required packages
apt-get install -y curl wget git jq

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
systemctl start docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Coolify
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

# Wait for Coolify to be ready
echo "Waiting for Coolify to start..."
sleep 30

# Log installation completion
echo "Coolify installation completed at $(date)" >> /var/log/coolify-install.log
echo "Access Coolify at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8000" >> /var/log/coolify-install.log
