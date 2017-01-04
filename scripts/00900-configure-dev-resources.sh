printf "\n\n##### Beginning 00900-configure-dev-resources.sh\n\n" >> /root/report/build-report.txt

printf "\n## CONFIGURE DEV RESOURCES IF APPLICABLE\n\n"

printf "\n## INSTALL XDEBUG IF DEV ENVIRONMENT ###\n"

if [ "$DEV" = "true" ]
    then
    printf "\n## INSTALLING XDEBUG ###\n"
    apt-get install -y php7.0-xdebug
fi
