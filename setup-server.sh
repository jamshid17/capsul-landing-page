#!/bin/bash

# Server Setup Script for Capsul Landing Page
# This script prepares your VDS server for deployment

echo "🔧 Setting up server for Capsul deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run this script as root (use sudo)"
    exit 1
fi

# Update system packages
print_status "Updating system packages..."
apt update && apt upgrade -y

# Install nginx
print_status "Installing nginx..."
apt install -y nginx

# Install firewall and configure it
print_status "Configuring firewall..."
apt install -y ufw
ufw allow 'Nginx Full'
ufw allow ssh
ufw --force enable

# Start and enable nginx
print_status "Starting nginx service..."
systemctl start nginx
systemctl enable nginx

# Create web directory
print_status "Creating web directory..."
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Create backup directory
print_status "Creating backup directory..."
mkdir -p /var/www/backups
chown -R www-data:www-data /var/www/backups

# Install certbot for SSL (optional)
read -p "Do you want to install certbot for SSL certificates? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Installing certbot..."
    apt install -y certbot python3-certbot-nginx
fi

# Check nginx status
if systemctl is-active --quiet nginx; then
    print_status "Nginx is running successfully"
else
    print_error "Nginx failed to start"
    systemctl status nginx
    exit 1
fi

print_status "Server setup completed!"
print_status "You can now run the deployment script: sudo ./deploy.sh"
print_status "Make sure to update the DOMAIN variable in deploy.sh with your actual domain" 