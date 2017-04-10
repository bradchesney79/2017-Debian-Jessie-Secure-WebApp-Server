

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


##### PUSH ENVIRONMENT VARIABLES INTO PHP ENVIRONMENT

environment_host=AWS >> /etc/php/7.1/fpm/???external php.ini file???/php.ini

#rando-script-whatever.php

#get_cfg_var('environment_type') // returns 'dev'
