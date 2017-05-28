
printf "\n\n##### Beginning 00700-install-nginx-and-php7-fpm.sh\n\n" >> /root/report/build-report.txt

printf "\n## CREATE THE LIMITED PRIVILEGE USERS FOR ADMINISTERING THE WEBSITE ###\n"

adduser --system --no-create-home nginx

useradd --system --no-create-home ${USER}

# ToDo: use this user as the nginx user...

printf "\n## INSTALLING NGINX ###\n"
 
apt-get install -yt jessie-backports nginx nginx-common

systemctl stop nginx

# Since we are installing a non-Debian oriented packages
# The Debian Way (tm) directories are missing
#mkdir -p /etc/nginx/sites-available
#mkdir -p /etc/nginx/sites-enabled



printf "\n## INSTALLING PHP7 ###\n"

if [ "$DEMO" = "true" ]
  then
    # Shorter list of packages for the demo install
    apt-get install -y php7.1-fpm php7.1-common php7.1-xml php7.1-gd php7.1-mbstring php7.1-mcrypt php7.1-curl
else
  # Full list of intended packages
  apt-get install -y php7.1-fpm php7.1-common php7.1-curl php7.1-gd php7.1-imagick php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-xml php7.1-intl php7.1-xmlrpc php7.1-zip php-pear
fi

systemctl stop php7.1-fpm

if [ "$SSLPROVIDER"='lets-encrypt' ]
  then
  printf "\n## INSTALLING CERTBOT ###\n"
  apt-get install -yt jessie-backports certbot python-certbot python-acme python-cryptography
fi
