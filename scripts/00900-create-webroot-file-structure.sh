printf "\n\n##### Beginning 00900-create-webroot-file-structure.sh\n\n" >> /root/report/build-report.txt

printf "\n## CREATE WEBROOT FILE STRUCTURE\n\n"

#printf "        SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS\n" >> /etc/apache2/includes/vhost-ssl

#chown www-data:www-data /etc/apache2/includes/vhost-ssl

printf "\n## CONFIGURE THE DEFAULT SITE\n"

printf "\n## PREPARE DIRECTORY STRUCTURE FOR DEFAULT SITE\n"

mkdir -p "$LOGDIR"
mkdir -p "$PROJECTROOT"
mkdir -p "$HTTPSWEBROOT"
mkdir -p "$APIWEBROOT"
mkdir -p "$PROJECTROOT/sockets"
mkdir -p "$PROJECTROOT/tmp"
mkdir -p "$PROJECTROOT/api/o/v1"
mkdir -p "$PROJECTROOT/api/p/v1"

chown -R $USER:$USER $PROJECTROOT
chmod -R 774 $PROJECTROOT

chown -R www-data:www-data $PROJECTROOT/sockets
find $PROJECTROOT -type d -exec chmod -R 775 {} \;

printf "\n## A PLACEHOLDER FAVICON \n"

# This plain grey favicon will be displayed when requested.
# It prevents unnecessary automatic 404 errors from polluting the logs.

printf 'AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABILAAASCwAAAAAAAAAAAACwsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/sLCw/7CwsP+wsLD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==' | python -m base64 -d > /var/www/html/favicon.ico
