#!/bin/bash

# 1. Recreate the missing Laravel framework cache storage paths dynamically
mkdir -p /home/site/wwwroot/storage/framework/views
mkdir -p /home/site/wwwroot/storage/framework/cache
mkdir -p /home/site/wwwroot/storage/framework/sessions
mkdir -p /home/site/wwwroot/storage/logs

# 2. Fix the file permissions so Nginx can write to the cache
chmod -R 775 /home/site/wwwroot/storage
chown -R www-data:www-data /home/site/wwwroot/storage

# 3. Overwrite Nginx configuration to point directly to the public folder
echo "server {
    listen 8080;
    listen [::]:8080;
    root /home/site/wwwroot/public;
    index index.php index.html;
    server_name localhost;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}" > /etc/nginx/sites-available/default

# 4. Reload the web routing server securely
service nginx reload
