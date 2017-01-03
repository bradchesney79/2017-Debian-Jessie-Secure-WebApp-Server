#!/bin/bash

printf "\n##################################################"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n# SETUP SCRIPT START                             #"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n##################################################\n\n"

printf "##### Entering build-script.sh\n\n" >> /root/report/build-report.txt

pushd /root/bin

printf "\n########## SCRIPT EXECUTION PARTICULARS ##########\n\n"

. /root/bin/setup.conf

printf "\n******/root/bin/setup.conf******\n" >> /root/report/build-report.txt
printf "%s" "$(</root/bin/setup.conf)" >> /root/report/build-report.txt
printf "\n******/root/bin/setup.conf******\n" >> /root/report/build-report.txt

printf "\n########## CONFIGURE THE HOSTNAME & HOSTS OVERRIDES ###\n"

. /root/bin/scripts/00100-configure-hostname.sh

printf "\n########## SET THE TIMEZONE & TIME ###\n\n"

. /root/bin/scripts/00200-configure-time.sh

printf "\n########## APT SOURCES, FIRST UPDATE, & COMMON PACKAGES INSTALL ###\n\n"

. /root/bin/scripts/00300-update-system.sh

printf "\n########## ALLOW SUPPLEMENTAL SSH ALGORITHMS ###\n"

. /root/bin/scripts/00400-configure-sshd.sh

printf "\n########## UPDATE THE IPTABLES RULES ###\n"

. /root/bin/scripts/00500-configure-iptables.sh

printf "\n########## CONFIGURE FAIL2BAN ###\n"

. /root/bin/scripts/00600-configure-fail2ban.sh

printf "\n########## INSTALL NGINX ###\n"

. /root/bin/scripts/00700-install-nginx-and-php7-fpm.sh

printf "\n########## INSTALL MYSQL ###\n"

. /root/bin/scripts/00800-install-and-configure-mysql.sh

printf "\n########## CONFIGURE DEVELOPMENT INSTANCE PACKAGES ###\n"

. /root/bin/scripts/00900-configure-dev-resources.sh

printf "\n########## CREATE WEBROOT FILE STRUCTURE ###\n"

. /root/bin/scripts/01000-create-webroot-file-structure.sh

printf "\n########## CONFIGURE NGINX AND PHP-FPM ###\n\n"

. /root/bin/scripts/01100-configure-nginx-and-php7-fpm.sh

printf "\n########## INSTALL WEBDEVELOPER RESOURCES ###\n"

#. /root/bin/scripts/01300-install-dev-tools.sh

printf "\n########## INSTALL AND CONFIGURE MAIL ###\n"

. /root/bin/scripts/01400-install-and-configure-system-mail.sh

printf "\n########## INSTALL AND CONFIGURE SYSSTAT ###\n"

. /root/bin/scripts/01600-install-and-configure-sysstat.sh
#sed -i "s/ENABLED=\"false\"/ENABLED=\"true\"/" /etc/default/sysstat

printf "\n########## CLEAN UP ###\n"

printf "\nLast autoremove of packages\n\n"

apt-get -y autoremove

printf "\n########## START THE WEBSERVER SERVICES ###\n"

systemctl start php7-fpm
systemctl start nginx

printf "\n##################################################"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n# SETUP SCRIPT END                               #"
printf "\n#                                                #"
printf "\n#                                                #"
printf "\n##################################################\n\n"

#. /root/bin/scripts/troubleshooting.sh

#FIXME Commenting these until front end is squared away-- or I make an expect script for them and configuration settings for it.

printf "\n Add a person user. Best practices dictate using the root account less. ( ./add-web-person-user.sh $USERID1001 TRUE )\n"

#. /root/bin/add-web-person-user.sh $USERID1001 TRUE

#usermod -a --groups $USER $USERID1001

printf "\nSSL Certs come from a third-party, be sure to back up the applicable files and link them in the appropriate directory.\n"

printf "\nThinking inside my head that a few minutes of uptime is trivial at this point-- nobody is actually depending on the system being up or even using it at this exact moment-- a reboot might be a smart idea.\n"

printf "\nSet up Reverse DNS while you wait if applicable-- gets rid of those pesky problem with the server being referred to by the linode assigned machine name in most places."

date +%s >> /root/report/build-report.txt

popd

#TODO remove this --exits the ssh connection
#exit 0
