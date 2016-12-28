printf "\n\n##### Beginning 00700-install-nginx-and-php7-fpm.sh\n\n" >> /root/report/build-report.txt

printf "\n## CREATE THE LIMITED PRIVILEGE USER FOR ADMINISTERING THE WEBSITE ###\n"
useradd -d $WEBROOT -p $PASSWORD -c "Default Web Site User" $USER

printf "\n## LOCK THE NOT USER ACCOUNT ###\n"
passwd -l $USER


printf "\n## INSTALLING NGINX ###\n"
 
apt-get install -y nginx nginx-common

systemctl stop nginx

printf "\n## INSTALLING PHP7 ###\n"

# Full list of intended packages
#apt-get install -y php7.0-fpm php7.0-common php7.0-curl php7.0-gd php7.0-imagick php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-xml php7.0-intl php7.0-xmlrpc php7.0-zip php-pear

apt-get install -y php7.0-fpm php7.0-common

systemctl stop php7.0-fpm

if [ "$SSLPROVIDER"='lets-encrypt' ]
  then
  printf "\n## INSTALLING CERTBOT ###\n"
  apt-get install -y certbot
fi

printf "\n## INSTALL XDEBUG IF DEV ENVIRONMENT ###\n"

if [ "$DEV" = "true" ]
    then
    printf "\n## INSTALLING XDEBUG ###\n"
    apt-get install -y php7.0-xdebug
fi
