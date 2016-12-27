printf "\n\n##### Beginning 00700-install-nginx-and-php7-fpm.sh\n\n" >> /root/report/build-report.txt

printf "\n## CREATE THE LIMITED PRIVILEGE USER FOR ADMINISTERING THE WEBSITE ###\n"
useradd -d $WEBROOT -p $PASSWORD -c "Default Web Site User" $USER

printf "\n## LOCK THE NOT USER ACCOUNT ###"
passwd -l $USER


printf "\n## PREVENT A DEBCONF ERROR RELATED TO NEW INSTALLS OF NGINX###\n"

cat <<EOF > /var/lib/dpkg/info/nginx-common.config
#!/bin/sh

set -e

. /usr/share/debconf/confmodule

logdir="/var/log/nginx"

log_symlinks_check() {
   return
    # Skip new installations
    [ -z "$1" ] && return

    # Skip unaffected installations
    dpkg --compare-versions "$1" lt-nl "1.10.2-2~dotdeb+8.2" || return 0

    # Check for unsecure symlinks
    linked_logfiles="` find "$logdir" -type l -user www-data -name '*.log' `"

    # Skip if nothing is found
    [ -z "$linked_logfiles" ] && return

    db_subst nginx/log-symlinks logfiles $linked_logfiles
    db_input high nginx/log-symlinks || true
    db_go || true
}

case "$1" in
    configure|reconfigure)
        log_symlinks_check "$2"
        ;;
    *)
        ;;
esac

# vim: set ts=4 sts=4 sw=4 et sta ai :
EOF

printf "\n## INSTALLING THE PILE OF NGINX & PHP PACKAGES###\n"
 
apt-get install -y nginx nginx-common php-all-dev php-pear php7.0-fpm php7.0-dev php7.0-bz2 php7.0-calendar php7.0-curl php7.0-gd php7.0-imagick php7.0-imap php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-pdo php7.0-phar php7.0-pspell php7.0-tidy php7.0-xml php7.0-xmlrpc php7.0-zip

systemctl stop nginx
systemctl stop php7.0-fpm

if [ "$DEV" = "true" ]
    then
    apt-get install -y php7.0-xdebug
fi
