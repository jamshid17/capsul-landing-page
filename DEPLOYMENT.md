# VDS Deployment Guide for Capsul Landing Page

## Quick Deployment (5 minutes)

### Step 1: Upload Files to Your Server

Upload these files to your VDS server:
- `index.html`
- `styles.css` 
- `script.js`
- `deploy.sh`
- `setup-server.sh`

You can use:
- **SCP**: `scp *.html *.css *.js *.sh user@your-server-ip:/home/user/`
- **SFTP**: Use FileZilla or similar
- **Git**: Clone your repository if you have one

### Step 2: Run Server Setup (First time only)

```bash
# SSH into your server
ssh user@your-server-ip

# Make scripts executable
chmod +x setup-server.sh deploy.sh

# Run server setup (as root)
sudo ./setup-server.sh
```

### Step 3: Configure and Deploy

```bash
# Edit the domain in deploy.sh
nano deploy.sh
# Change: DOMAIN="your-domain.com" to your actual domain

# Run deployment
sudo ./deploy.sh
```

## Manual Deployment (Alternative)

If you prefer manual steps:

### 1. Install Nginx
```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 2. Copy Files
```bash
sudo cp index.html /var/www/html/
sudo cp styles.css /var/www/html/
sudo cp script.js /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
```

### 3. Configure Nginx
```bash
sudo nano /etc/nginx/sites-available/capsul
```

Add this configuration:
```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

### 4. Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/capsul /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # Remove default
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Configure Firewall
```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw enable
```

## SSL Certificate (Optional but Recommended)

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

## Troubleshooting

### Check Nginx Status
```bash
sudo systemctl status nginx
sudo nginx -t
```

### View Logs
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Common Issues

1. **Permission Denied**: 
   ```bash
   sudo chown -R www-data:www-data /var/www/html/
   sudo chmod -R 755 /var/www/html/
   ```

2. **Port 80 Blocked**: 
   ```bash
   sudo ufw allow 80
   sudo ufw allow 443
   ```

3. **Domain Not Resolving**: Make sure your domain points to your server's IP address

## Performance Optimization

The deployment script includes:
- Gzip compression
- Static file caching
- Security headers
- Optimized nginx configuration

## Backup and Updates

### Backup Current Site
```bash
sudo tar -czf /var/www/backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /var/www/html .
```

### Update Site
```bash
# Upload new files
sudo cp new-index.html /var/www/html/index.html
sudo cp new-styles.css /var/www/html/styles.css
sudo cp new-script.js /var/www/html/script.js
sudo chown www-data:www-data /var/www/html/*
sudo systemctl reload nginx
```

## Monitoring

### Check Website Status
```bash
curl -I http://your-domain.com
```

### Monitor Resource Usage
```bash
htop
df -h
free -h
```

Your Capsul landing page should now be live at `http://your-domain.com`! 