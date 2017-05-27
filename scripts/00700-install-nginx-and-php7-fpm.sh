
printf "\n\n##### Beginning 00700-install-nginx-and-php7-fpm.sh\n\n" >> /root/report/build-report.txt

printf "\n## CREATE THE LIMITED PRIVILEGE USERS FOR ADMINISTERING THE WEBSITE ###\n"

adduser --system --no-create-home nginx

useradd --system --no-create-home ${USER}

# ToDo: use this user as the nginx user...

printf "\n## INSTALLING NGINX ###\n"
 
apt-get install -y nginx nginx-common

systemctl stop nginx

# Since we are installing a non-Debian oriented packages
# The Debian Way (tm) directories are missing
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled



printf "\n## INSTALLING PHP7 ###\n"

if [ "$DEMO" = "true" ]
  then
    # Shorter list of packages for the demo install
    apt-get install -y php7.1-fpm php7.1-common php7.1-xml
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

# The main nginx.conf is also not The Debian Way (tm)
cat <<EOF > /etc/nginx/nginx.conf
user www-data;
worker_processes 4;
pid /run/nginx.pid;

events {
        worker_connections 768;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;
        gzip_disable "msie6";

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
}

#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}
EOF
