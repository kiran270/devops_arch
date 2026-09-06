#!/bin/bash
set -e

# Log everything
exec > >(tee /var/log/coolify-install.log)
exec 2>&1

echo "Starting Coolify installation at $(date)"

# Update system
apt-get update
apt-get upgrade -y

# Set hostname
hostnamectl set-hostname ${hostname}

# Install required packages
apt-get install -y curl wget git jq openssh-server

# Ensure SSH server is running
systemctl enable ssh
systemctl start ssh

# Configure SSH for root
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Generate SSH key for Coolify
ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -N "" -q
cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chmod 600 /root/.ssh/id_ed25519

# Allow root SSH login for Coolify
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin no/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
systemctl restart ssh

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
echo "Installing Coolify..."
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

# Wait for Coolify to initialize
echo "Waiting for Coolify to start..."
sleep 45

# Test SSH connectivity
echo "Testing SSH connectivity..."
ssh -o StrictHostKeyChecking=no -o BatchMode=yes root@localhost "echo 'SSH test successful'" || echo "SSH test failed - will retry"

# Get public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Log completion
echo "========================================"
echo "Coolify installation completed at $(date)"
echo "Public IP: $PUBLIC_IP"
echo "Access Coolify at: http://$PUBLIC_IP:8000"
echo "SSH command: ssh -i <key>.pem ubuntu@$PUBLIC_IP"
echo "Root SSH key location: /root/.ssh/id_ed25519"
echo "========================================"
echo ""
echo "IMPORTANT: Coolify needs localhost SSH access."
echo "The SSH server is configured and keys are set up."
echo "If you see connection errors in Coolify, wait a few minutes for services to fully start."
echo "========================================"

# Save SSH key info to a file for easy access
cat > /home/ubuntu/coolify-info.txt << EOFINFO
Coolify Installation Info
========================
Installed: $(date)
Public IP: $PUBLIC_IP
Coolify URL: http://$PUBLIC_IP:8000

SSH Access:
- Ubuntu user: ssh -i <key>.pem ubuntu@$PUBLIC_IP
- Root SSH key: /root/.ssh/id_ed25519

Coolify Server Configuration:
- Host: 127.0.0.1 or localhost
- Port: 22
- User: root
- Private Key: Use the key from /root/.ssh/id_ed25519

To get the private key:
sudo cat /root/.ssh/id_ed25519

Common Commands:
- View logs: sudo docker logs coolify
- Restart: sudo docker restart coolify
- Check status: sudo docker ps
- SSH test: sudo ssh root@localhost
EOFINFO

chown ubuntu:ubuntu /home/ubuntu/coolify-info.txt

echo "Installation script completed!"
