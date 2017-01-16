#!/bin/bash

####### INIT SCRIPT ####

mkdir -p /root/report

date +%s >> /root/report/build-report.txt

printf "\n\n##### Beginning init-script.sh\n\n" >> /root/report/build-report.txt

mkdir -p /root/bin

pushd /root/bin

printf "\n\n## Downloading the git repo\n\n" >> /root/report/build-report.txt

wget https://github.com/bradchesney79/2017-Debian-Jessie-Secure-WebApp-Server/archive/master.zip

printf "\n\n## Unzipping the compressed git repo\n\n" >> /root/report/build-report.txt

apt-get update && apt-get -y install unzip

unzip /root/bin/master.zip

printf "\n\n## Moving the files\n\n" >> /root/report/build-report.txt

cp -R /root/bin/2017-Debian-Jessie-Secure-WebApp-Server-master/* /root/bin/

printf "\n\n## Setting consistent file permissions\n\n" >> /root/report/build-report.txt

chmod -R 770 /root/bin/*

find /root/bin/* -type d -exec chmod -R 771 {} \;

printf "\n\n## Removing spent resources\n\n" >> /root/report/build-report.txt

rm -rf /root/bin/cut-paste.txt /root/bin/favicon.ico /root/bin/init.sh /root/bin/2017-Debian-Jessie-Secure-WebApp-Server-master /root/bin/master.zip /root/bin/README.md

popd
