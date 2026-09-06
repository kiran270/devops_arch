# Coolify Troubleshooting Guide

## Can't Access Coolify Dashboard

### 1. Check Instance is Running

```bash
# Via AWS CLI
aws ec2 describe-instances --instance-ids <instance-id> --query 'Reservations[0].Instances[0].State.Name'
```

**Expected**: `running`

### 2. Verify Public IP

```bash
# Get the public IP from Terraform output
cd devops_arch/usage/dev
terraform output coolify_public_ip
```

Try accessing: `http://<public-ip>:8000`

### 3. Check Security Group Rules

```bash
# Via AWS CLI
aws ec2 describe-security-groups --group-ids <sg-id>
```

**Required ports**:
- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS)
- 8000 (Coolify Dashboard)
- 6001 (Docker Registry)

### 4. SSH into Instance and Check Installation

```bash
ssh -i <your-key>.pem ubuntu@<public-ip>

# Check if Coolify is running
sudo docker ps

# Check installation logs
cat /var/log/coolify-install.log

# Check Coolify service
sudo systemctl status coolify

# Check Docker service
sudo systemctl status docker
```

### 5. Verify Coolify Installation

```bash
# SSH into the instance
ssh -i <your-key>.pem ubuntu@<public-ip>

# Check Coolify containers
sudo docker ps | grep coolify

# Check Coolify logs
sudo docker logs coolify

# Restart Coolify if needed
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

### 6. Check Network Connectivity

```bash
# From your local machine
curl -v http://<public-ip>:8000

# Check if port is open
nc -zv <public-ip> 8000

# Or use telnet
telnet <public-ip> 8000
```

### 7. Common Issues

#### Issue: Connection Timeout
**Cause**: Security group not allowing traffic
**Fix**: 
```bash
# Update security group via Terraform
terraform apply -target=module.coolify.aws_security_group.coolify
```

#### Issue: Coolify Not Starting
**Cause**: Installation didn't complete or failed
**Fix**:
```bash
ssh ubuntu@<public-ip>

# Re-run installation
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

# Check system resources
free -h
df -h
```

#### Issue: Instance Not in Public Subnet
**Cause**: Instance launched in wrong subnet
**Fix**: Check that the instance is in a public subnet with route to Internet Gateway

#### Issue: No Public IP
**Cause**: Elastic IP not attached or subnet doesn't auto-assign public IPs
**Fix**: Verify EIP is attached:
```bash
aws ec2 describe-addresses --filters "Name=instance-id,Values=<instance-id>"
```

### 8. Wait Time

Coolify takes **2-5 minutes** to fully initialize after instance launch. Wait and try again.

### 9. Check User Data Execution

```bash
ssh ubuntu@<public-ip>

# Check cloud-init logs
sudo cat /var/log/cloud-init-output.log

# Check if user-data script completed
sudo tail -100 /var/log/cloud-init-output.log
```

### 10. Manual Installation (If Automated Failed)

```bash
ssh ubuntu@<public-ip>

# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker ubuntu

# Install Coolify
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | sudo bash

# Check if running
sudo docker ps
```

## Quick Fix Commands

### Restart Coolify
```bash
ssh ubuntu@<public-ip>
sudo docker restart $(sudo docker ps -q --filter name=coolify)
```

### View Live Logs
```bash
ssh ubuntu@<public-ip>
sudo docker logs -f coolify
```

### Check Disk Space
```bash
ssh ubuntu@<public-ip>
df -h
```

### Check Memory Usage
```bash
ssh ubuntu@<public-ip>
free -h
```

## Get Help

If still not working, collect these details:
1. Instance ID
2. Public IP
3. Security group rules
4. Output of: `sudo docker ps`
5. Output of: `cat /var/log/coolify-install.log`
6. Output of: `sudo tail -100 /var/log/cloud-init-output.log`

## Force Re-apply Security Group

If you updated the Terraform code to open port 8000:

```bash
cd devops_arch/usage/dev

# Re-apply just the security group
terraform apply -target=module.coolify.aws_security_group.coolify
```
