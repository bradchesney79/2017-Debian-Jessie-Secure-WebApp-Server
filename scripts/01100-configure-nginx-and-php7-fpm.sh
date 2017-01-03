printf "\n\n##### Beginning 01100-configure-nginx-and-php7-fpm.sh\n\n" >> /root/report/build-report.txt

# sidestepping a missing variable issue
# $ is both a native dynamic character in nginx.conf & bash
DOLLARSIGN='$'

if [ "$SSLPROVIDER"='letsencrypt' ]
  then

    printf "\n## TEMPORARY NGINX HTTP SERVER FOR CERTBOT VERIFICATION ###\n"

printf "\n## CONFIGURING NGINX ###"

echo "" > /etc/nginx/sites-available/default


cat <<EOF > /etc/nginx/sites-available/default
server {
  listen 80 default_server;
  server_name $DOMAIN $HOSTNAME.$DOMAIN;
  resolver 8.8.8.8;
  root $WEBROOT;
  index index.html;

  location '/.well-known/acme-challenge' {
    root $WEBROOT;
  }
  access_log $WEBROOT/logs/access-ssl.log;
}
EOF
    
    systemctl start nginx
    
    printf "\n## INVOKE CERTBOT FOR LETS ENCRYPT MULTIDOMAIN CERT ###\n"
  
    # multi-domain is not "wild card"

    # non-interactive command only

    certbot certonly --agree-tos --non-interactive --text --rsa-key-size $KEYSIZE --email $USERID1001EMAIL --webroot --webroot-path $WEBROOT --domains "$DOMAIN, $HOSTNAME.$DOMAIN"
    
    systemctl stop nginx
    
cat <<EOF > /tmp/letsencrypt-brad-junk.txt

server {
  listen 80 default_server;
  server_name kingchesney.com www.kingchesney.com;
  resolver 8.8.8.8;
  root /var/www;
  index index.html;

  location '/.well-known/acme-challenge' {
    root /var/www;
  }
  access_log /var/www/logs/access-ssl.log;
}

certbot certonly --agree-tos --non-interactive --text --rsa-key-size 4096 --email bradchesney79@gmail.com --webroot --webroot-path /var/www --domains "kingchesney.com, www.kingchesney.com"
EOF

fi

printf "\n## CONFIGURING NGINX ###"

echo "" > /etc/nginx/sites-available/default


cat <<EOF > /etc/nginx/sites-available/default
server {
  listen 80 default_server;
  listen 443 ssl http2 default_server;
  server_name $DOMAIN $HOSTNAME.$DOMAIN;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
  ssl_prefer_server_ciphers On;
  ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/${DOMAIN}/chain.pem;
  ssl_session_cache shared:SSL:128m;
  add_header Strict-Transport-Security "max-age=31557600; includeSubDomains";
  add_header X-Frame-Options "SAMEORIGIN" always;
  add_header X-Content-Type-Options "nosniff" always;
  add_header X-Xss-Protection "1";
  add_header Content-Security-Policy "default-src 'self'; script-src 'self' *.google-analytics.com";
  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 8.8.8.8;
  root $HTTPSWEBROOT;
  index index.html;

  location '/.well-known/acme-challenge' {
    root $HTTPSWEBROOT;
  }

  location / {
    if ($scheme = http) {
      return 301 https://${DOLLARSIGN}server_name${DOLLARSIGN}request_uri;
    }
  }
     
  location ~ [^/]\.php(/|$) {
    include fastcgi_params;
    fastcgi_split_path_info ^(.+?\.php)(/.*)$;

    # Mitigate https://httpoxy.org/ vulnerabilities
    fastcgi_param HTTP_PROXY "";

    fastcgi_pass unix:$WEBROOT/sockets/$DOMAIN.sock;
    fastcgi_index index.php;

    if (!-f ${DOLLARSIGN}document_root${DOLLARSIGN}fastcgi_script_name) {
      return 404;
    }
  }
  # static contents regex match to directory stored in
  location ~ \.(gif|jpg|png)$ {
     root $HTTPSWEBROOT/images;
  }
  access_log $WEBROOT/logs/access-ssl.log;
}
EOF
#TODO Change the location of the SSL Cert in the nginx config

printf "\n## DEFAULT HTTP POOL ###\n"

printf "\n## CONFIG PHP-FPM ###\n"

mv /etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf.original
cp /etc/php/7.0/fpm/pool.d/www.conf.original /etc/php/7.0/fpm/pool.d/${DOMAIN}.conf
cp /etc/php/7.0/fpm/pool.d/www.conf.original /etc/php/7.0/fpm/pool.d/${DOMAIN}-ssl.conf

printf "\n## DEFAULT HTTP POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN\]/" /etc/php/7.0/fpm/pool.d/${DOMAIN}.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN.sock|" /etc/php/7.0/fpm/pool.d/${DOMAIN}.conf

sed -i "s/user = www-data/user = $USER/" /etc/php/7.0/fpm/pool.d/${DOMAIN}.conf
sed -i "s/group = www-data/group = $USER/" /etc/php/7.0/fpm/pool.d/${DOMAIN}.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php/7.0/fpm/pool.d/${DOMAIN}.conf

printf "\n## DEFAULT HTTPS POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN-SSL\]/" /etc/php/7.0/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN-SSL.sock|" /etc/php/7.0/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/user = www-data/user = $USER/" /etc/php/7.0/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s/group = www-data/group = $USER/" /etc/php/7.0/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php/7.0/fpm/pool.d/${DOMAIN}-ssl.conf




printf "\n## CONFIGURE PHP ###\n"

cp /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.original


sed -i "s/;*short_open_tag.*/short_open_tag = Off/" /etc/php/7.0/fpm/php.ini

sed -i "s/;*post_max_size.*/post_max_size = 12M/" /etc/php/7.0/fpm/php.ini


sed -i "s/;*upload_max_filesize.*/upload_max_filesize = 12M/" /etc/php/7.0/fpm/php.ini


sed -i "s/;*session.cookie_secure.*/session.cookie_secure = 1/" /etc/php/7.0/fpm/php.ini


sed -i "s/;*session.cookie_httponly.*/session.cookie_httponly = 1/" /etc/php/7.0/fpm/php.ini


sed -i "s/;*disable_functions.*/disable_functions = apache_child_terminate, apache_setenv, define_syslog_variables, escapeshellarg, escapeshellcmd, eval, exec, fp, fput, ftp_connect, ftp_exec, ftp_get, ftp_login, ftp_nb_fput, ftp_put, ftp_raw, ftp_rawlist, highlight_file, ini_alter, ini_get_all, ini_restore, inject_code, mysql_pconnect, openlog, passthru, pcntl_alarm, pcntl_exec, pcntl_fork, pcntl_get_last_error, pcntl_getpriority, pcntl_setpriority, pcntl_signal, pcntl_signal_dispatch, pcntl_sigprocmask, pcntl_sigtimedwait, pcntl_sigwaitinfo, pcntl_strerror, pcntl_wait, pcntl_waitpid, pcntl_wexitstatus, pcntl_wifexited, pcntl_wifsignaled, pcntl_wifstopped, pcntl_wstopsig, pcntl_wtermsig, phpAds_XmlRpc, phpAds_remoteInfo, phpAds_xmlrpcDecode, phpAds_xmlrpcEncode, php_uname, popen, posix_getpwuid, posix_kill, posix_mkfifo, posix_setpgid, posix_setsid, posix_setuid, posix_uname, proc_close, proc_get_status, proc_nice, proc_open, proc_terminate, shell_exec, syslog, system, xmlrpc_entity_decode/" /etc/php/7.0/fpm/php.ini
