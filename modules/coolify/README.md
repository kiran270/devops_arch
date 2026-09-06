# Coolify Module

This module creates an EC2 instance with Coolify pre-installed.

## What is Coolify?

Coolify is an open-source, self-hostable Heroku/Netlify/Vercel alternative that allows you to deploy applications with just a few clicks.

## Features

- Ubuntu 22.04 LTS
- Docker & Docker Compose pre-installed
- Coolify automatically installed and configured
- Elastic IP for consistent access
- Security group configured for web traffic
- SSH access for management

## Access Points

After deployment, you can access:

- **Coolify Dashboard**: `http://<public-ip>:8000`
- **SSH**: `ssh -i <key>.pem ubuntu@<public-ip>`

## Default Ports

- 22: SSH
- 80: HTTP
- 443: HTTPS
- 8000: Coolify Dashboard
- 6001: Docker Registry

## Instance Requirements

**Minimum**:
- Instance Type: t3.medium
- Storage: 30 GB
- RAM: 4 GB

**Recommended for Production**:
- Instance Type: t3.large or higher
- Storage: 50+ GB
- RAM: 8+ GB

## First Time Setup

1. Wait 2-3 minutes after deployment for Coolify to fully initialize
2. Access the dashboard at `http://<public-ip>:8000`
3. Complete the initial setup wizard
4. Set up your admin password
5. Configure your first project

## Usage

```hcl
module "coolify" {
  source = "../../modules/coolify"

  name              = "my-coolify"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_ids[0]
  instance_type     = "t3.medium"
  key_name          = "my-key-pair"
  root_volume_size  = 30
  hostname          = "coolify"
  allocate_eip      = true

  tags = {
    Environment = "production"
  }
}
```

## Outputs

- `instance_id` - EC2 instance ID
- `public_ip` - Public IP address
- `coolify_url` - Dashboard URL
- `ssh_command` - SSH connection command

## Security Considerations

- Change the default SSH CIDR from `0.0.0.0/0` to your IP range
- Enable HTTPS with a valid SSL certificate
- Configure firewall rules based on your needs
- Regular backups recommended
- Keep Docker and Coolify updated

## Cost Estimate (us-east-1)

- t3.medium: ~$30/month
- 30 GB EBS gp3: ~$2.40/month
- Elastic IP: Free (while attached)
- **Total**: ~$32-35/month

## Troubleshooting

Check installation logs:
```bash
ssh ubuntu@<public-ip>
cat /var/log/coolify-install.log
sudo docker ps
```

Restart Coolify:
```bash
sudo systemctl restart coolify
```
