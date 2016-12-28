printf "\n\n##### Beginning 00300-update-system.sh\n\n" >> /root/report/build-report.txt

printf "\n## UPDATE THE APT SOURCES \n\n"

cat <<EOF > /etc/apt/sources.list
deb http://ftp.us.debian.org/debian jessie main contrib non-free

deb http://httpredir.debian.org/debian jessie-updates main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free

deb http://http.debian.net/debian jessie-backports main contrib non-free

deb http://packages.dotdeb.org jessie all

deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7
EOF

# gpg key for Dotdeb
wget -q -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -

# gpg key for Oracle Community MySQL Server 5.7
gpg --keyserver hkp://keys.gnupg.net --recv-keys 5072E1F5
gpg --export -a 5072e1f5 > pubkey_mysql.asc
sudo apt-key add pubkey_mysql.asc

printf "\n## UPDATE THE SYSTEM ###\n"

apt-get -y update


printf "\n## UPGRADE THE SYSTEM\n\n"

apt-get -y dist-upgrade
apt-get -y upgrade

printf "\n## INSTALL THE FIRST BATCHES OF PACKAGES ###\n"

#apt-get -y install sudo tcl perl python3 tmux ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban git curl imagemagick expect

apt-get -y install sudo perl python3 tmux ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban curl imagemagick expect

printf "\n## CLEAN UP ###\n"

printf "\nFirst autoremove of packages\n\n"

apt-get -y autoremove
