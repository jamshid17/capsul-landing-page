#!/bin/bash

# Capsul Landing Page Deployment Script (No SSL)
# This script deploys the landing page without SSL for initial setup

echo "🚀 Deploying Capsul Landing Page (HTTP only)..."

# Configuration
DOMAIN="landing.usechai.com"
WEB_ROOT="/var/www/html"
BACKUP_DIR="/var/www/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

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

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    print_status "Creating backup directory..."
    mkdir -p "$BACKUP_DIR"
fi

# Backup existing website if it exists
if [ -d "$WEB_ROOT" ] && [ "$(ls -A $WEB_ROOT)" ]; then
    print_status "Creating backup of existing website..."
    tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" -C "$WEB_ROOT" .
    print_status "Backup saved to $BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
fi

# Create web root directory if it doesn't exist
if [ ! -d "$WEB_ROOT" ]; then
    print_status "Creating web root directory..."
    mkdir -p "$WEB_ROOT"
fi

# Copy files to web root
print_status "Copying files to web root..."
cp index.html "$WEB_ROOT/"
cp styles.css "$WEB_ROOT/"
cp script.js "$WEB_ROOT/"

# Set proper permissions
print_status "Setting file permissions..."
chown -R www-data:www-data "$WEB_ROOT"
chmod -R 755 "$WEB_ROOT"
chmod 644 "$WEB_ROOT"/*.html "$WEB_ROOT"/*.css "$WEB_ROOT"/*.js

# Create nginx configuration (HTTP only)
print_status "Creating nginx configuration..."
cat > /etc/nginx/sites-available/capsul << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    root $WEB_ROOT;
    index index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss;

    # Cache static assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Main location block
    location / {
        try_files \$uri \$uri/ =404;
    }

    # Error pages
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
}
EOF

# Enable the site
print_status "Enabling nginx site..."
ln -sf /etc/nginx/sites-available/capsul /etc/nginx/sites-enabled/

# Remove default nginx site if it exists
if [ -L /etc/nginx/sites-enabled/default ]; then
    print_status "Removing default nginx site..."
    rm /etc/nginx/sites-enabled/default
fi

# Test nginx configuration
print_status "Testing nginx configuration..."
if nginx -t; then
    print_status "Nginx configuration is valid"
else
    print_error "Nginx configuration test failed"
    exit 1
fi

# Reload nginx
print_status "Reloading nginx..."
systemctl reload nginx

# Check if nginx is running
if systemctl is-active --quiet nginx; then
    print_status "Nginx is running successfully"
else
    print_error "Nginx failed to start"
    systemctl status nginx
    exit 1
fi

# Get server IP
SERVER_IP=$(curl -s ifconfig.me)

print_status "Deployment completed successfully!"
print_status "Your website is now accessible at:"
echo "  - http://$SERVER_IP"
echo "  - http://$DOMAIN (when DNS is configured)"
echo
print_warning "To add SSL later, run: sudo ./deploy.sh"
print_warning "To check DNS configuration, run: ./check-dns.sh"

echo
print_status "Useful commands:"
echo "  - View nginx logs: tail -f /var/log/nginx/access.log"
echo "  - View error logs: tail -f /var/log/nginx/error.log"
echo "  - Restart nginx: systemctl restart nginx"
echo "  - Check DNS: ./check-dns.sh" 