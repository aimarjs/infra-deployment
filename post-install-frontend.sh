AZURE_RESEARCH_GROUP='cosmospoc'
AZURE_REGION='westeurope'
NGINX_DOMAIN_NAME='cosmospoc.ml'
NGINX_AVAILABLE_VHOSTS='/etc/nginx/sites-available'
NGINX_ENABLED_VHOSTS='/etc/nginx/sites-enabled'

#### AZURE CREATE VM ####
# az login 
# az group create --location $AZURE_REGION --name $AZURE_RESEARCH_GROUP
# az network public-ip create --name frontend-ip --resource-group $AZURE_RESEARCH_GROUP --location $AZURE_REGION
# az network vnet create --name $AZURE_RESEARCH_GROUP-vnet --resource-group $AZURE_RESEARCH_GROUP --address-prefixes 10.10.0.0/16 --location $AZURE_REGION --subnet-name vmsubnet --subnet-prefix 10.10.1.0/24
# az network nsg create --name $AZURE_RESEARCH_GROUP-nsg --resource-group $AZURE_RESEARCH_GROUP --location $AZURE_REGION
# az network vnet subnet update --name vmsubnet --resource-group $AZURE_RESEARCH_GROUP --vnet-name $AZURE_RESEARCH_GROUP-vnet --network-security-group vmsubnet
# az network nic create --resource-group $AZURE_RESEARCH_GROUP --name $AZURE_RESEARCH_GROUP-nic --subnet vmsubnet --vnet-name $AZURE_RESEARCH_GROUP-vnet --location $AZURE_REGION --public-ip-address frontend-ip
# az vm create --name frontend --resource-group $AZURE_RESEARCH_GROUP --admin-username devops --admin-password !1qwerty123456 --image Ubuntu --authentication-type password --nics $AZURE_RESEARCH_GROUP-nic  --size Standard_DS1 --location $AZURE_REGION
# az vm open-port --name frontend --port 22 --resource-group $AZURE_RESEARCH_GROUP --apply-to-subnet --priority 1000
#OR
# az network nsg rule create --name SSH --nsg-name vmsubnet --priority 1100 --resource-group clivm --source-address-prefix * --source-port-range * --destination-address-prefix * --destination-port-range 22 --protocol Tcp

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
