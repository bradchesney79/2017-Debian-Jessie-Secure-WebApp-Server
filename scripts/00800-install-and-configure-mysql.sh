printf "\n\n##### Beginning 00800-install-and-configure-mysql.sh\n\n" >> /root/report/build-report.txt

printf "\n## INSTALLING AND CONFIGURING MYSQL ###\n"

export DEBIAN_FRONTEND="noninteractive"

debconf-set-selections <<<  "mysql-server mysql-server/root_password select $DBROOTPASSWORD" 
debconf-set-selections <<<  "mysql-server mysql-server/root_password_again select $DBROOTPASSWORD"

apt-get -y install mysql-server

mysql -uroot -p"$DBROOTPASSWORD" <<< "DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;"

#A common vector is to attack the MySQL root user since it is the default omipotent user put on almost all #MySQL installs.
#So, give your 'root' user a different name. (Is admin more secure than root, meh. Yeah, I guess.)

mysql -uroot -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'localhost' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"
mysql -uroot -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'127.0.0.1' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"
mysql -uroot -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON *.* TO '$DBROOTUSER'@'::1' IDENTIFIED BY '$DBROOTPASSWORD' WITH GRANT OPTION;"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "DELETE FROM mysql.user WHERE User='root';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE USER 'backup'@'localhost' IDENTIFIED BY '$DBBACKUPUSERPASSWORD';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "FLUSH PRIVILEGES;"

apt-get remove debconf* --purge
