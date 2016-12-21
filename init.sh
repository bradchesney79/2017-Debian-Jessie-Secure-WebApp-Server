#!/bin/bash

####### INIT SCRIPT ####

date +%s >> /root/basestarttime.txt

mkdir -p /root/bin

pushd /root/bin

wget https://github.com/bradchesney79/2017-Debian-Jessie-Secure-WebApp-Server/archive/master.zip

apt-get -y install unzip

unzip /root/bin/master.zip

cp -R /root/bin/2017-Debian-Jessie-Secure-WebApp-Server-master/* /root/bin/

chmod -R 770 /root/bin/*

find /root/bin/* -type d -exec chmod -R 771 {} \;

rm -rf /root/init.sh /root/bin/2017-Debian-Jessie-Secure-WebApp-Server /root/bin/master.zip

popd
