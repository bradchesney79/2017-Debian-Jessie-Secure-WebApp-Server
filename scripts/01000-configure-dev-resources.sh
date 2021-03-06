printf "\n\n##### Beginning 01000-configure-dev-resources.sh\n\n" >> /root/report/build-report.txt

printf "\n## CONFIGURE DEV RESOURCES IF APPLICABLE\n\n"

printf "\n## INSTALL XDEBUG IF DEV ENVIRONMENT ###\n"

if [ "$DEV" = "true" ]
    then
    printf "\n## INSTALLING XDEBUG ###\n"
    apt-get install -y php7.1-xdebug
 
printf "\n## PUT INFO.PHP IN THE HTTPSWEBROOT ###\n"

cat <<EOF > $HTTPSWEBROOT/info.php
<?php
phpinfo();
?>
EOF

printf "\n## PUT INFO.PHP IN THE APIWEBROOT ###\n"
    
cat <<EOF > $APIWEBROOT/info.php
<?php
phpinfo();
?>
EOF
fi
