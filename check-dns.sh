#!/bin/bash

# DNS Check Script for Capsul Deployment
# This script helps troubleshoot domain and SSL issues

echo "🔍 Checking DNS and server configuration..."

# Configuration
DOMAIN="usechat.com"
WEB_ROOT="/var/www/html"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_info() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

# Get server IP
SERVER_IP=$(curl -s ifconfig.me)
print_info "Your server IP: $SERVER_IP"

# Check domain DNS
print_info "Checking DNS for $DOMAIN..."
DOMAIN_IP=$(dig +short $DOMAIN | head -1)

if [ -z "$DOMAIN_IP" ]; then
    print_error "Domain $DOMAIN does not resolve to any IP address"
    print_warning "You need to configure your domain's DNS settings"
else
    print_status "Domain $DOMAIN resolves to: $DOMAIN_IP"
    
    if [ "$DOMAIN_IP" = "$SERVER_IP" ]; then
        print_status "✅ DNS is correctly configured!"
    else
        print_error "❌ DNS mismatch! Domain points to $DOMAIN_IP but your server is $SERVER_IP"
        print_warning "You need to update your domain's DNS A record to point to $SERVER_IP"
    fi
fi

# Check www subdomain
print_info "Checking www.$DOMAIN..."
WWW_IP=$(dig +short www.$DOMAIN | head -1)

if [ -z "$WWW_IP" ]; then
    print_warning "www.$DOMAIN does not resolve"
else
    print_status "www.$DOMAIN resolves to: $WWW_IP"
    
    if [ "$WWW_IP" = "$SERVER_IP" ]; then
        print_status "✅ www subdomain is correctly configured!"
    else
        print_warning "www subdomain points to $WWW_IP (should be $SERVER_IP)"
    fi
fi

# Check if nginx is running
print_info "Checking nginx status..."
if systemctl is-active --quiet nginx; then
    print_status "✅ Nginx is running"
else
    print_error "❌ Nginx is not running"
    systemctl status nginx
fi

# Check if port 80 is accessible
print_info "Checking if port 80 is accessible..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:80 | grep -q "200\|404"; then
    print_status "✅ Port 80 is accessible locally"
else
    print_error "❌ Port 80 is not accessible locally"
fi

# Check firewall
print_info "Checking firewall status..."
if ufw status | grep -q "Status: active"; then
    print_status "✅ Firewall is active"
    if ufw status | grep -q "80/tcp.*ALLOW"; then
        print_status "✅ Port 80 is allowed in firewall"
    else
        print_warning "⚠️  Port 80 might be blocked by firewall"
    fi
else
    print_warning "⚠️  Firewall is not active"
fi

# Test external accessibility
print_info "Testing external accessibility..."
EXTERNAL_TEST=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 http://$SERVER_IP:80 2>/dev/null)

if [ "$EXTERNAL_TEST" = "200" ] || [ "$EXTERNAL_TEST" = "404" ]; then
    print_status "✅ Server is accessible externally on port 80"
else
    print_error "❌ Server is not accessible externally on port 80 (HTTP code: $EXTERNAL_TEST)"
fi

# Check nginx configuration
print_info "Checking nginx configuration..."
if nginx -t 2>/dev/null; then
    print_status "✅ Nginx configuration is valid"
else
    print_error "❌ Nginx configuration has errors"
    nginx -t
fi

# Check if site files exist
print_info "Checking website files..."
if [ -f "$WEB_ROOT/index.html" ]; then
    print_status "✅ index.html exists"
else
    print_error "❌ index.html is missing"
fi

if [ -f "$WEB_ROOT/styles.css" ]; then
    print_status "✅ styles.css exists"
else
    print_error "❌ styles.css is missing"
fi

if [ -f "$WEB_ROOT/script.js" ]; then
    print_status "✅ script.js exists"
else
    print_error "❌ script.js is missing"
fi

echo
print_info "=== DNS Configuration Instructions ==="
echo
echo "To fix DNS issues, you need to configure your domain's DNS settings:"
echo
echo "1. Log into your domain registrar (where you bought usechat.com)"
echo "2. Find the DNS management section"
echo "3. Add or update these records:"
echo
echo "   Type: A"
echo "   Name: @ (or leave blank)"
echo "   Value: $SERVER_IP"
echo "   TTL: 300 (or default)"
echo
echo "   Type: A"
echo "   Name: www"
echo "   Value: $SERVER_IP"
echo "   TTL: 300 (or default)"
echo
echo "4. Wait 5-30 minutes for DNS propagation"
echo "5. Run this script again to verify: ./check-dns.sh"
echo
print_warning "After DNS is configured correctly, run: sudo ./deploy.sh" 