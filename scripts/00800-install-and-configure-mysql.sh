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

printf "\n## MAKE PRIVILEGES CHANGES LIVE ONCE ###\n"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "FLUSH PRIVILEGES;"

printf "\n## START SETTING UP SUPPORTING SYSTEM THINGS\n\n"

cd $PROJECTROOT

# Create databases for the app and sentinel
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE DATABASE $PROJECTDB;"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE DATABASE $SENTINELDB;"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $PROJECTDB.* TO '$USERID1001'@'$PROJECTDBHOST' IDENTIFIED BY '$USERID1001PASSWORD' WITH GRANT OPTION;"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $SENTINELDB.* TO '$USERID1001'@'$SENTINELDBHOST' IDENTIFIED BY '$USERID1001PASSWORD' WITH GRANT OPTION;"


mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $PROJECTDB.* TO '$DEFAULTSITEDBUSER'@'$PROJECTDBHOST' IDENTIFIED BY '$DEFAULTSITEDBPASSWORD';"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $SENTINELDB.* TO '$DEFAULTSITEDBUSER'@'$SENTINELDBHOST' IDENTIFIED BY '$DEFAULTSITEDBPASSWORD';"

printf "\n## OUTPUT THE COMMANDS ###\n"
printf "\n\n
mysql -u\"$DBROOTUSER\" -p\"$DBROOTPASSWORD\" <<< \"CREATE DATABASE $PROJECTDB;\"
mysql -u\"$DBROOTUSER\" -p\"$DBROOTPASSWORD\" <<< \"CREATE DATABASE $SENTINELDB;\"
mysql -u\"$DBROOTUSER\" -p\"$DBROOTPASSWORD\" <<< \"GRANT ALL PRIVILEGES ON $PROJECTDB.* TO '$USERID1001'@'$PROJECTDBHOST' IDENTIFIED BY '$USERID1001PASSWORD' WITH GRANT OPTION;\"
mysql -u\"$DBROOTUSER\" -p\"$DBROOTPASSWORD\" <<< \"GRANT ALL PRIVILEGES ON $SENTINELDB.* TO '$USERID1001'@'$SENTINELDBHOST' IDENTIFIED BY '$USERID1001PASSWORD' WITH GRANT OPTION;\"


mysql -u\"$DBROOTUSER\" -p\"$DBROOTPASSWORD\" <<< \"GRANT ALL PRIVILEGES ON $PROJECTDB.* TO '$DEFAULTSITEDBUSER'@'$PROJECTDBHOST' IDENTIFIED BY '$DEFAULTSITEDBPASSWORD';\"
mysql -u\"$DBROOTUSER\" -p\"$DBROOTPASSWORD\" <<< \"GRANT ALL PRIVILEGES ON $SENTINELDB.* TO '$DEFAULTSITEDBUSER'@'$SENTINELDBHOST' IDENTIFIED BY '$DEFAULTSITEDBPASSWORD';\"

mysql -u\"$DBROOTUSER\" -p\"$DBROOTPASSWORD\" <<< \"FLUSH PRIVILEGES;\"
\n\n"

printf "\n## MAKE PRIVILEGES CHANGES LIVE TWICE ###\n"

mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "FLUSH PRIVILEGES;"

# Fill the database with data structure goodness

mkdir -p /root/sql

cat <<EOF > /root/sql/schema.sql
USE $PROJECTDB;

SET foreign_key_checks = 0;

CREATE TABLE users (
  userid int unsigned NOT NULL AUTO_INCREMENT COMMENT 'This is the be all and end all id, this is what identifies our user in our system.',
  active char(1) DEFAULT NULL COMMENT 'Is this person active or "deleted"? y, n, or NULL=n',
  fname char(50) DEFAULT NULL COMMENT 'This is the user''s first name, birth certificate/legal name stuff',
  nickname char(50) DEFAULT NULL COMMENT 'This is the nickname that a user would prefer to use in place of a first name-- which our app will respect',
  lname char(50) DEFAULT NULL COMMENT 'The last name of the user',
  password char(255) DEFAULT NULL COMMENT '--NOT USED-- This field stores the password hash particulars / salted hash',
  sessionStart int unsigned DEFAULT NULL COMMENT 'When the user initially ''logged in'' and had a successful authentication as a timestamp',
  sessionRenewal int unsigned DEFAULT NULL COMMENT 'This is an activity that extends the active sesion as a timestamp',
  lastModified int unsigned DEFAULT NULL COMMENT 'This field stores the last change for searching in the logs',
  PRIMARY KEY (userid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table is what it is all about.';

CREATE TABLE emails (
  emailsid int unsigned NOT NULL AUTO_INCREMENT,
  userid int unsigned DEFAULT NULL COMMENT 'The foreign key id',
  title char(80) DEFAULT NULL COMMENT 'What the email is to display',
  account char(70) DEFAULT NULL COMMENT 'The part of the account before the @ sign',
  host char(255) DEFAULT NULL COMMENT 'The fqdn, hostname, or IP of the email server',
  lastModified int unsigned DEFAULT NULL COMMENT 'This field is used to track the last change in the logs',
  PRIMARY KEY (emailsid),
  KEY emails_account_idx (account),
  KEY emails_host_idx (host),
  CONSTRAINT emails_userid
    FOREIGN KEY (userid)
    REFERENCES users (userid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This is THE emails table';

CREATE TABLE phones (
  phonesid int unsigned NOT NULL AUTO_INCREMENT,
  userid int unsigned DEFAULT NULL COMMENT 'The id that ties the phone to a user',
  phoneType enum('landline','mobile','multi-ring','fax','tdd-tty','other') DEFAULT NULL COMMENT 'What type of device or endpoint is this number representing',
  sms char(1) DEFAULT NULL COMMENT 'Can this phone receive sms entries? y, n, or NULL=n',
  title char(80) DEFAULT NULL COMMENT 'What the phone is to display to the user',
  areaCode smallint DEFAULT NULL COMMENT 'The area code of the phone number',
  prefix smallint DEFAULT NULL COMMENT 'The phone number prefix',
  number smallint DEFAULT NULL COMMENT 'The four numbers that make a phone number individual',
  extention char(80) DEFAULT NULL COMMENT 'Extension information about the phone number',
  lastModified int unsigned DEFAULT NULL COMMENT 'This field is used to track the last change in the logs',
  PRIMARY KEY (phonesid),
  CONSTRAINT phones_userid
    FOREIGN KEY (userid)
    REFERENCES users (userid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='the table with US format phone numbers';

SET foreign_key_checks = 1;


EOF

mysql -u"$DEFAULTSITEDBUSER" -p"$DEFAULTSITEDBPASSWORD" < /root/sql/schema.sql

cat <<EOF > /root/sql/testdata.sql
USE $PROJECTDB;

SET foreign_key_checks = 0;

INSERT INTO users (userid, active, fname, nickname, lname, password, sessionsStart, sessionRenewal, lastModified) VALUES (NULL, 'y', 'Brad', 'CAB', 'Chesney', NULL, UNIX_TIMESTAMP(NOW()), UNIX_TIMESTAMP(NOW()), UNIX_TIMESTAMP(NOW()));

INSERT INTO emails (emailsid, userid, title, account, host, lastModified) VALUES (NULL, 1, 'My gMail', 'bradchesney79', 'gmail.com', UNIX_TIMESTAMP(NOW())),(NULL, 1, 'Made Up gMail', 'brianchesney81', 'gmail.com', UNIX_TIMESTAMP(NOW()));


INSERT INTO phones (phonesid, userid, phoneType, sms, title, areaCode, prefix, number, extention, lastModified) VALUES (NULL, 1, 'mobile', 'y', 'Primary Mobile', 440, 954, 0151, NULL,  UNIX_TIMESTAMP(NOW())),(NULL, 1, 'landline', 'n', 'Fake Landline', 123, 456, 7890, NULL,  UNIX_TIMESTAMP(NOW()));

SET foreign_key_checks = 1;

EOF

mysql -u"$DEFAULTSITEDBUSER" -p"$DEFAULTSITEDBPASSWORD" < /root/sql/testdata.sql


