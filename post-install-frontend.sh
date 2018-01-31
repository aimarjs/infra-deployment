NGINX_DOMAIN_NAME='cosmospoc.ml'
NGINX_AVAILABLE_VHOSTS='/etc/nginx/sites-available'
NGINX_ENABLED_VHOSTS='/etc/nginx/sites-enabled'

sudo apt-get update -y
sudo apt-get install nginx -y
sudo add-apt-repository -y ppa:nginx/development
sudo apt update && sudo apt install -y nginx
sudo ufw allow 'Nginx Full'
sudo ufw allow 'OpenSSH'
sudo ufw --force enable
sudo mkdir -p /var/www/$NGINX_DOMAIN_NAME/html
sudo chown -R $USER:$USER /var/www/$NGINX_DOMAIN_NAME/html
sudo chmod -R 755 /var/www
echo '<html><head><title>Welcome to Testpage!</title></head><body><h1>Success! The production server block is working!</h1></body></html>' >> /var/www/$NGINX_DOMAIN_NAME/html/index.html

sudo rm -rf $NGINX_AVAILABLE_VHOSTS/default
sudo tee $NGINX_AVAILABLE_VHOSTS/$NGINX_DOMAIN_NAME > /dev/null <<EOF
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/$NGINX_DOMAIN_NAME/html;

        index index.html index.htm index.nginx-debian.html;

        server_name $NGINX_DOMAIN_NAME www.$NGINX_DOMAIN_NAME;

        location / {
                try_files $uri $uri/ =404;
        }
}

EOF

sudo rm -rf $NGINX_ENABLED_VHOSTS/$NGINX_DOMAIN_NAME
sudo ln -s $NGINX_AVAILABLE_VHOSTS/$NGINX_DOMAIN_NAME $NGINX_ENABLED_VHOSTS
sudo sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/' /etc/nginx/nginx.conf                                                                     c/nginx/nginx.conf
sudo systemctl restart nginx
