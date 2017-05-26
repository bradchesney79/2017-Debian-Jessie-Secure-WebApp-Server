printf "\n\n##### Beginning 00300-update-system.sh\n\n" >> /root/report/build-report.txt

printf "\n## UPDATE THE APT SOURCES \n\n"

cat <<EOF > /etc/apt/sources.list
deb http://ftp.us.debian.org/debian jessie main contrib non-free

deb http://httpredir.debian.org/debian jessie-updates main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free

deb http://http.debian.net/debian jessie-backports main contrib non-free

deb https://packages.sury.org/php/ jessie main

#deb http://nginx.org/packages/debian/ jessie nginx

deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7
EOF

apt-get -qy install apt-transport-https lsb-release ca-certificates
#FIXME You know better than to shove something unconfirmed in... bah

#curl -s https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
#echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

cd /root

printf "\n## INSTALL THE ORACLE MYSQL GPG KEY ###\n"

# gpg key for Oracle Community MySQL Server 5.7

echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

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
=tUml
-----END PGP PUBLIC KEY BLOCK-----" | apt-key add -

# how to programmatically install the gpg key blindly
#gpg --keyserver hkp://keys.gnupg.net --recv-keys 5072E1F5
#gpg --export -a 5072e1f5 > pubkey_mysql.asc
#sudo apt-key add pubkey_mysql.asc



#gpg --keyserver hkp://pgp.mit.edu --recv-keys 5072E1F5
#gpg --export -a 5072e1f5 > pubkey_mysql.asc
#sudo apt-key add pubkey_mysql.asc

printf "\n## SET NONINTERACTIVE CONFIGS ###\n"
export DEBIAN_FRONTEND=noninteractive

cat <<EOF > /etc/apt/listchanges.conf
[cmdline]
frontend=none

[apt]
frontend=none
email_address=root
confirm=1
EOF

printf "\n## UPDATE THE SYSTEM ###\n"

apt-get update

printf "\n## UPGRADE THE SYSTEM\n\n"

printf "\nca-certificates\n"
apt-get install -y ca-certificates

printf "\ndist-upgrade\n"
apt-get -y dist-upgrade

printf "\n## INSTALL THE FIRST BATCHES OF PACKAGES ###\n"

#TODO Set this back to more full install
# Full list of intended packages
#apt-get -y install sudo tcl perl python3 tmux ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban git curl imagemagick

apt-get -y install sudo perl python3 ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban curl expect

printf "\n## CLEAN UP ###\n"

printf "\nFirst autoremove of packages\n\n"

apt-get -y autoremove
