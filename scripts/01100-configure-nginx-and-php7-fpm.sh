
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
  root $HTTPSWEBROOT;
  index index.html;

  location '/.well-known/acme-challenge' {
    root $HTTPSWEBROOT;
  }
  access_log $LOGDIR/access-ssl.log;
}
EOF
  
    systemctl start nginx
    
    printf "\n## INVOKE CERTBOT FOR LETS ENCRYPT MULTIDOMAIN CERT ###\n"
  
    # multi-domain is not "wild card"

    # non-interactive command only

    certbot certonly --renew-by-default --agree-tos --non-interactive $STAGING --text --allow-subset-of-names --rsa-key-size $KEYSIZE --email $USERID1001EMAIL --webroot --webroot-path $HTTPSWEBROOT --domains "$DOMAIN, $HOSTNAME.$DOMAIN, api.$DOMAIN"
    
    echo "certbot certonly --renew-by-default --agree-tos --non-interactive $STAGING --text --allow-subset-of-names --rsa-key-size $KEYSIZE --email $USERID1001EMAIL --webroot --webroot-path $HTTPSWEBROOT --domains \"$DOMAIN, $HOSTNAME.$DOMAIN, api.$DOMAIN\""
    
    # certbot certonly --renew-by-default --agree-tos --non-interactive --staging --text --allow-subset-of-names --rsa-key-size 4096 --email bradchesney79@gmail.com --webroot --webroot-path /var/www/html --domains "kingchesney.com, www.kingchesney.com, api.kingchesney.com"

## CONFIGURING NGINX ###
## CONFIG PHP-FPM ###

## DEFAULT HTTPS POOL ###

## API POOL ###

## CONFIGURE PHP ###

########## INSTALL WEBDEVELOPER RESOURCES ###


    
    systemctl stop nginx
    
fi

printf "\n## CONFIGURING NGINX ###"



cat <<"EOF" > /etc/nginx/fastcgi_params
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;

fastcgi_param  SCRIPT_NAME        $document_root$fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  REQUEST_SCHEME     $scheme;
fastcgi_param  HTTPS              $https if_not_empty;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
EOF

cp /etc/nginx/fastcgi_params /etc/nginx/fastcgi.conf



# ToDo: remove this

cp /etc/nginx/fastcgi_params /etc/nginx/backups/fastcgi.conf.bak

cat <<EOF > /etc/nginx/sites-available/default

server { 
  listen 80; 
  listen 443 ssl http2;
  server_name $DOMAIN;
  return 301 https://$HOSTNAME.$DOMAIN${DOLLARSIGN}request_uri;
}

server { 
  listen 80 default_server;
  listen 443 ssl http2 default_server;
  server_name www.$DOMAIN;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
  ssl_prefer_server_ciphers On;
  ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/$DOMAIN/chain.pem;
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
    if (${DOLLARSIGN}scheme = http) {
      return 301 https://www.$DOMAIN${DOLLARSIGN}request_uri;
    }
  }  
     
  location ~ \.php${DOLLARSIGN} {
    include fastcgi_params; 
    fastcgi_split_path_info ^(.+?\.php)(/.*)${DOLLARSIGN};
    
    # Mitigate https://httpoxy.org/ vulnerabilities
    fastcgi_param HTTP_PROXY "";
    fastcgi_param SCRIPT_FILENAME ${DOLLARSIGN}document_root${DOLLARSIGN}fastcgi_script_name;
    
    fastcgi_pass unix:/var/run/$DOMAIN.sock;
    fastcgi_index index.php;
    
    if (!-f ${DOLLARSIGN}document_root${DOLLARSIGN}fastcgi_script_name) {
      return 404;
    }
  }  
  
  access_log $LOGDIR/access.log;
  error_log $LOGDIR/error.log warn;
}
EOF



ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

cat <<EOF > /etc/nginx/sites-available/open-api
server { 
  listen 80;
  listen 443 ssl http2;
  server_name api.$DOMAIN;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
  ssl_prefer_server_ciphers On;
  ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/$DOMAIN/chain.pem;
  ssl_session_cache shared:SSL:128m;
  add_header Strict-Transport-Security "max-age=31557600; includeSubDomains";
  add_header X-Frame-Options "SAMEORIGIN";
  add_header X-Content-Type-Options "nosniff";
  add_header X-Xss-Protection "1";
  add_header Content-Security-Policy "default-src 'self'; script-src 'self' *.google-analytics.com";
  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 8.8.8.8;
  root $APIWEBROOT;
  index index.html;

  location '/.well-known/acme-challenge' {
    root $APIWEBROOT/o;
  }
  
  location / {
    if (${DOLLARSIGN}scheme = http) {
      return 301 https://api.$DOMAIN${DOLLARSIGN}request_uri;
    }
  }  

    location ~ \.php${DOLLARSIGN} {
    include fastcgi_params; 
    fastcgi_split_path_info ^(.+?\.php)(/.*)${DOLLARSIGN};
    
    # Mitigate https://httpoxy.org/ vulnerabilities
    fastcgi_param HTTP_PROXY "";
    fastcgi_param SCRIPT_FILENAME ${DOLLARSIGN}document_root${DOLLARSIGN}fastcgi_script_name;
    
    fastcgi_pass unix:/var/run/api.$DOMAIN.sock;
    fastcgi_index index.php;
    
    if (!-f ${DOLLARSIGN}document_root${DOLLARSIGN}fastcgi_script_name) {
      return 404;
    }
  }  
  
  access_log $LOGDIR/access-open-api.log;
  error_log $LOGDIR/error-open-api.log warn;
}
EOF


ln -s /etc/nginx/sites-available/open-api /etc/nginx/sites-enabled/open-api

cat <<EOF > /etc/nginx/sites-available/private-api
server {
  listen 80;
  listen 443 ssl http2;
  server_name api.$DOMAIN;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
  ssl_prefer_server_ciphers On;
  ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/$DOMAIN/chain.pem;
  ssl_session_cache shared:SSL:128m;
  add_header Strict-Transport-Security "max-age=31557600; includeSubDomains";
  add_header X-Frame-Options "SAMEORIGIN" always;
  add_header X-Content-Type-Options "nosniff" always;
  add_header X-Xss-Protection "1";
  add_header Content-Security-Policy "default-src 'self'; script-src 'self' *.google-analytics.com";
  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 8.8.8.8;
  root $APIWEBROOT/p;
  index index.html;

  location '/.well-known/acme-challenge' {
    root $APIWEBROOT;
  }

  location / {
    if (${DOLLARSIGN}scheme = http) {
      return 301 https://api.$DOMAIN${DOLLARSIGN}request_uri;
    }
  }

    location ~ \.php${DOLLARSIGN} {
    include fastcgi_params;
    fastcgi_split_path_info ^(.+?\.php)(/.*)${DOLLARSIGN};

    # Mitigate https://httpoxy.org/ vulnerabilities
    fastcgi_param HTTP_PROXY "";
    fastcgi_param SCRIPT_FILENAME ${DOLLARSIGN}document_root${DOLLARSIGN}fastcgi_script_name;

    fastcgi_pass unix:/var/run/api.$DOMAIN.sock;
    fastcgi_index index.php;

    if (!-f ${DOLLARSIGN}document_root${DOLLARSIGN}fastcgi_script_name) {
      return 404;
    }
  }

  access_log $LOGDIR/access-private-api.log;
  error_log $LOGDIR/error-private-api.log warn;
}
EOF



ln -s /etc/nginx/sites-available/private-api /etc/nginx/sites-enabled/private-api

printf "\n## CONFIG PHP-FPM ###\n"

mv /etc/php/7.1/fpm/pool.d/www.conf /etc/php/7.1/fpm/pool.d/www.conf.original
cp /etc/php/7.1/fpm/pool.d/www.conf.original /etc/php/7.1/fpm/pool.d/${DOMAIN}.conf


printf "\n## DEFAULT HTTPS POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN\]/" /etc/php/7.1/fpm/pool.d/${DOMAIN}.conf

#sed delimiters are not a fixed character -- pipe symbol used to avoid escaping path in substitution
sed -i "s|listen =.*|listen = /var/run/$DOMAIN.sock|" /etc/php/7.1/fpm/pool.d/${DOMAIN}.conf

sed -i "s/user = www-data/user = $USER/" /etc/php/7.1/fpm/pool.d/${DOMAIN}.conf
sed -i "s/group = www-data/group = $USER/" /etc/php/7.1/fpm/pool.d/${DOMAIN}.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php/7.1/fpm/pool.d/${DOMAIN}.conf


printf "\n## API POOL ###\n"

cp /etc/php/7.1/fpm/pool.d/${DOMAIN}.conf /etc/php/7.1/fpm/pool.d/api-${DOMAIN}.conf

sed -i "s/\[$DOMAIN\]/\[API-DOMAIN\]/" /etc/php/7.1/fpm/pool.d/api-${DOMAIN}.conf

#sed delimiters are not a fixed character -- pipe symbol used to avoid escaping path in substitution
sed -i "s|listen =.*|listen = /var/run/api.$DOMAIN.sock|" /etc/php/7.1/fpm/pool.d/api-${DOMAIN}.conf


printf "\n## CONFIGURE PHP ###\n"

cp /etc/php/7.1/fpm/php.ini /etc/php/7.1/fpm/php.ini.original


sed -i "s/;*cgi.fix_pathinfo.*/cgi.fix_pathinfo = 0/" /etc/php/7.1/fpm/php.ini

sed -i "s/;*short_open_tag.*/short_open_tag = Off/" /etc/php/7.1/fpm/php.ini

sed -i "s/;*post_max_size.*/post_max_size = 12M/" /etc/php/7.1/fpm/php.ini


sed -i "s/;*upload_max_filesize.*/upload_max_filesize = 12M/" /etc/php/7.1/fpm/php.ini


sed -i "s/;*session.cookie_secure.*/session.cookie_secure = 1/" /etc/php/7.1/fpm/php.ini


sed -i "s/;*session.cookie_httponly.*/session.cookie_httponly = 1/" /etc/php/7.1/fpm/php.ini


#sed -i "s/;*disable_functions.*/disable_functions = apache_child_terminate, apache_setenv, define_syslog_variables, escapeshellarg, escapeshellcmd, eval, exec, fp, fput, ftp_connect, ftp_exec, ftp_get, ftp_login, ftp_nb_fput, ftp_put, ftp_raw, ftp_rawlist, highlight_file, ini_alter, ini_get_all, ini_restore, inject_code, mysql_pconnect, openlog, passthru, pcntl_alarm, pcntl_exec, pcntl_fork, pcntl_get_last_error, pcntl_getpriority, pcntl_setpriority, pcntl_signal, pcntl_signal_dispatch, pcntl_sigprocmask, pcntl_sigtimedwait, pcntl_sigwaitinfo, pcntl_strerror, pcntl_wait, pcntl_waitpid, pcntl_wexitstatus, pcntl_wifexited, pcntl_wifsignaled, pcntl_wifstopped, pcntl_wstopsig, pcntl_wtermsig, phpAds_XmlRpc, phpAds_remoteInfo, phpAds_xmlrpcDecode, phpAds_xmlrpcEncode, php_uname, popen, posix_getpwuid, posix_kill, posix_mkfifo, posix_setpgid, posix_setsid, posix_setuid, posix_uname, proc_close, proc_get_status, proc_nice, proc_open, proc_terminate, shell_exec, syslog, system, xmlrpc_entity_decode/" /etc/php/7.1/fpm/php.ini
