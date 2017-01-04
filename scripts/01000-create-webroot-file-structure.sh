printf "\n\n##### Beginning 01000-create-webroot-file-structure.sh\n\n" >> /root/report/build-report.txt

printf "\n## CREATE WEBROOT FILE STRUCTURE\n\n"

#printf "        SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS\n" >> /etc/apache2/includes/vhost-ssl

#chown www-data:www-data /etc/apache2/includes/vhost-ssl

printf "\n## CONFIGURE THE DEFAULT SITE\n"

printf "\n## PREPARE DIRECTORY STRUCTURE FOR DEFAULT SITE\n"

mkdir -p "$WEBROOT/fonts"
mkdir -p "$WEBROOT/certs"
mkdir -p "$WEBROOT/certs/$YEAR"
mkdir -p "$WEBROOT/certs/$YEAR/$SSLPROVIDER"
mkdir -p "$LOGDIR"
mkdir -p "$WEBROOT/sockets"
mkdir -p "$WEBROOT/tmp"

chown -R $USER:$USER $WEBROOT
chmod -R 774 $WEBROOT

chown -R www-data:www-data $WEBROOT/sockets
find $WEBROOT -type d -exec chmod -R 775 {} \;
