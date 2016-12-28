printf "\n\n##### Beginning 00800-install-and-configure-mysql.sh\n\n" >> /root/report/build-report.txt

printf "\n## CONFIGRING MYSQL DEBCONF ###\n"

export DEBIAN_FRONTEND="noninteractive"

apt-get install -y debconf debconf-utils

debconf-set-selections <<<  "mysql-server mysql-server/root_password select $DBROOTPASSWORD" 
debconf-set-selections <<<  "mysql-server mysql-server/root_password_again select $DBROOTPASSWORD"

printf "\n## INSTALLING MYSQL ###\n"

apt-get -y install mysql-server

printf "\n## SIMULATE MYSQL SAFE INSTALL ###\n"

mysql -uroot -p"$DBROOTPASSWORD" <<< "DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;"

#A common vector is to attack the MySQL root user since it is the default omipotent user put on almost all #MySQL installs.
#So, give your 'root' user a different name. (Is admin more secure than root, meh. Yeah, I guess.)

printf "\n## ADD REPLACEMENT 'ROOT' MYSQL USER ###\n"

mysql -uroot -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'localhost' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"
mysql -uroot -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'127.0.0.1' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"
mysql -uroot -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'::1' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"

printf "\n## REMOVE DEFAULT MYSQL ROOT USER ###\n"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "DELETE FROM mysql.user WHERE User='root';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE USER 'backup'@'localhost' IDENTIFIED BY '$DBBACKUPUSERPASSWORD';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';"

printf "\n## MAKE PRIVILEGES CHANGES LIVE ###\n"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "FLUSH PRIVILEGES;"

printf "\n## PREVENT A DEBCONF ERROR RELATED TO NEW INSTALLS OF NGINX###\n"

apt-get -y remove debconf debconf-utils --purge

apt-get clean
apt-get update
apt-get -y install --reinstall coreutils sysvinit-utils
apt-get -y autoremove
