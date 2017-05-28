printf "\n\n##### Beginning 00200-configure-time.sh\n\n" >> /root/report/build-report.txt

printf "\n## SET THE TIME & TIME ZONE\n\n"

echo $TIMEZONE > /etc/timezone                     
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime # This sets the time

apt-get -y install ntp
