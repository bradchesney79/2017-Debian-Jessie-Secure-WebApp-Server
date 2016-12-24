printf "\n\n##### Beginning 00700-install-nginx-and-php7-fpm.sh\n\n" >> /root/report/build-report.txt

printf "\n## INSTALLING THE PILE OF NGINX & PHP PACKAGES###\n"

apt-get install -qy git curl gd imagemagick nginx php-all-dev php-pear php7.0-fpm php7.0-dev php7.0-bz2 php7.0-calendar php7.0-curl php7.0-gd php7.0-imagick php7.0-imap php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-pdo php7.0-phar php7.0-pspell php7.0-tidy php7.0-xml php7.0-xmlrpc php7.0-zip

systemctl stop nginx
systemctl stop php7.0-fpm

if [ "$DEV" = "true" ]
    then
    apt-get install -y php7.0-xdebug
fi
