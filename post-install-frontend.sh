sudo apt-get update -y
sudo apt-get install nginx -y
sudo add-apt-repository -y ppa:nginx/development
sudo apt update && sudo apt install -y nginx
sudo ufw allow 'Nginx Full'
sudo ufw allow 'OpenSSH'
sudo ufw --force enable

sudo mkdir -p /var/www/html
sudo chown -R $USER:$USER /var/www/html
sudo chmod -R 755 /var/www
echo '<html><head><title>Welcome to Testpage!</title></head><body><h1>Success! The production server block is working!</h1></body></html>' >> /var/www/html/index.html
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
        listen 80 default_server;

        server_name _;

        root /var/www/html;

        index index.html;

}
EOF
sudo sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/' /etc/nginx/nginx.conf
sudo systemctl restart nginx
