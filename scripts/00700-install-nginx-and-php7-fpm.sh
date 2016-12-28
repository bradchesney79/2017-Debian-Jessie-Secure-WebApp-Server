printf "\n\n##### Beginning 00700-install-nginx-and-php7-fpm.sh\n\n" >> /root/report/build-report.txt

printf "\n## CREATE THE LIMITED PRIVILEGE USER FOR ADMINISTERING THE WEBSITE ###\n"
useradd -d $WEBROOT -p $PASSWORD -c "Default Web Site User" $USER

printf "\n## LOCK THE NOT USER ACCOUNT ###"
passwd -l $USER


printf "\n## INSTALLING THE PILE OF NGINX & PHP PACKAGES###\n"
 
apt-get install -y nginx nginx-common php7.0-fpm php7.0-common php7.0-curl php7.0-gd php7.0-imagick php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-xml php7.0-intl php7.0-xmlrpc php7.0-zip php-pear

printf "\n## PHP7.0-PEAR JUST BECAUSE... ###\n"

apt-get install -y php7.0-pear

# currently under test php7.0-intl php7.0-xmlrpc php7.0-zip

# php7.0-dev php7.0-bz2 php7.0-imap

# replaced by php7.0-common
# php7.0-phar php7.0-calendar php7.0-pdo
# php7.0-ldap  php7.0-pspell php7.0-tidy php-all-dev php-pear

systemctl stop nginx
systemctl stop php7.0-fpm

printf "\n## INSTALL XDEBUG IF DEV ENVIRONMENT ###\n"

if [ "$DEV" = "true" ]
    then
    apt-get install -y php7.0-xdebug
fi
