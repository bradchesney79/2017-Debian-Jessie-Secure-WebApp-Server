printf "\n\n##### Beginning 00300-update-system.sh\n\n" >> /root/report/build-report.sh

printf "\n## UPDATE THE APT SOURCES \n\n"

cat <<EOF > /etc/apt/sources.list
deb http://ftp.us.debian.org/debian jessie main contrib non-free

deb http://httpredir.debian.org/debian jessie-updates main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free

deb http://http.debian.net/debian jessie-backports main contrib non-free

deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7
EOF

# gpg key for Oracle Community MySQL Server 5.7
gpg --keyserver hkp://keys.gnupg.net --recv-keys 5072E1F5
gpg --export -a 5072e1f5 > pubkey_mysql.asc
sudo apt-key add pubkey_mysql.asc

printf "\n## UPDATE THE SYSTEM ###\n"


printf "\nUpdate the system\n\n"
printf "Update the system\n\n"

apt-get -y update


printf "\nUpgrade the system\n\n"
printf "Upgrade the system\n\n"

apt-get -y dist-upgrade
apt-get -y upgrade

printf "\n## INSTALL THE FIRST BATCHES OF PACKAGES ###\n"


printf "\nInstall the first batch of packages\n\n"

apt-get -y install sudo tcl perl python3 tmux ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban git debconf-utils curl imagemagick expect

printf "\n## CLEAN UP ###\n"

printf "\nFirst autoremove of packages\n\n"

apt-get -y autoremove
