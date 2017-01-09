printf "\n\n##### Beginning 01300-install-dev-tools.sh\n\n" >> /root/report/build-report.txt

printf "\n## PLACE PHPINFO FILE IN THE WEBROOT ###"

if [ "$DEV" = "true" ]
  then
    
    printf '<?php phpinfo(); ?>' > $HTTPSWEBROOT
  fi
