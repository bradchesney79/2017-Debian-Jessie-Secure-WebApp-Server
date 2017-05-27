printf "\n\n##### Beginning 00000-make-environment-variables-persist.sh\n\n" >> /root/report/build-report.txt

##### CONVERT BASH VARIABLES TO ENVIRONMENT VARIABLES

export HOSTNAME=$HOSTNAME

export DOMAIN=$DOMAIN

export HOSTINGSERV=$HOSTINGSERV

export DEV=$DEV

export TARGETEMAIL=$TARGETEMAIL

export COUNTRY=$COUNTRY
export STATE=$STATE
export LOCALITY=$LOCALITY
export ORGANIZATION=$ORGANIZATION
export ORGANIZATIONALUNIT=$ORGANIZATIONALUNIT

export DEFAULTSITEDBUSER=$DEFAULTSITEDBUSER
export DEFAULTSITEDBPASSWORD=$DEFAULTSITEDBPASSWORD

export
##### CONVERT BASH VARIABLES TO PERSISTENT GLOBAL ENVIRONMENT VARIABLES

printf "HOSTNAME=$HOSTNAME" >> /etc/environment

printf "\nDOMAIN=$DOMAIN" >> /etc/environment

printf "\nHOSTINGSERV=$HOSTINGSERV" >> /etc/environment

printf "\nDEV=$DEV" >> /etc/environment

printf "\nTARGETEMAIL=$TARGETEMAIL" >> /etc/environment

#printf "\nCOUNTRY=$COUNTRY" >> /etc/environment
#printf "\nSTATE=$STATE" >> /etc/environment
#printf "\nLOCALITY=$LOCALITY" >> /etc/environment
#printf "\nORGANIZATION=$ORGANIZATION" >> /etc/environment
#printf "\nORGANIZATIONALUNIT=$ORGANIZATIONALUNIT" >> /etc/environment

printf "\nDEFAULTSITEDBUSER=$DEFAULTSITEDBUSER" >> /etc/environment
printf "\nDEFAULTSITEDBPASSWORD=$DEFAULTSITEDBPASSWORD" >> /etc/environment


##### ENVIRONMENT VARIABLES LATER USED TO PUSH THESE VALUES TO THE PHP ENVIRONMENT
##### VIA AN /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\n\n******/etc/environment******\n" >> /root/report/build-report.txt
printf "%s" "$(</etc/environment)" >> /root/report/build-report.txt
printf "\n******/etc/environment******\n\n" >> /root/report/build-report.txt

tail -n100000 /root/report/build-report.txt
