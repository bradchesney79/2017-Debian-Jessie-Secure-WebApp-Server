printf "\n\n##### Beginning 01700-install-back-end-assets.sh\n\n" >> /root/report/build-report.txt

printf "\n## INSTALL PHP COMPOSER\n\n"

EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
    php composer-setup.php --quiet --install-dir=/bin --filename=composer
    RESULT=$?
    rm composer-setup.php
    exit $RESULT
else
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

printf "\n## FIRST COMPOSER INSTALL\n\n"

composer.phar install --no-ansi --no-dev --no-interaction --no-progress --no-scripts

cat <<EOF > $PROJECTROOT
{
    "name": "viperks/api",
    "description": "The viperks api dependencies",
    "license": "Unlicense",
    "minimum-stability": "dev",
    "prefer-stable": true,
    "require": {
        "cartalyst/sentinel": ">=2.0 <3.0",
        "ext-gd": "*",
        "ext-mcrypt": "*",
        "ezyang/htmlpurifier": ">=4.7 <5.0",
        "firebase/php-jwt": ">=4.0 <5.0",
        "funct/funct": ">=1.1 <2.0",
        "google/apiclient": ">=1.1 <2.0",
        "guzzlehttp/guzzle": ">=6.0 <7.0",
        "illuminate/database": ">=5.2 <6.0",
        "illuminate/events": ">=5.2 <6.0",
        "illuminate/pagination": ">=5.3 <6.0",
        "league/csv": ">=8.0 <9.0",
        "mailgun/mailgun-php": ">=2.1 <3.0",
        "monolog/monolog": ">=1.0 <2.0",
        "mpdf/mpdf": ">=6.0 <7.0",
        "nategood/httpful": ">=0.2 <1.0",
        "paragonie/random_compat": ">=2.0 <3.0",
        "phpmailer/phpmailer": ">=5.2 <6.0",
        "phpoffice/phpexcel": ">=1.8 <2.0",
        "propel/propel": "~2.0@dev",
        "psr/log": ">=1.0 <2.0",
        "swiftmailer/swiftmailer": ">=5.4 <6.0",
        "symfony/intl": ">=3.1 <4.0"
    }
}
EOF

printf "\n## START SETTING UP SUPPORTING SYSTEM THINGS\n\n"

cd $PROJECTROOT

# Set up directories and reverse engineer the DB for the Propel ORM
mkdir -p $PROJECTROOT/dal
mkdir -p $PROJECTROOT/dal/config

# Create databases for the app and sentinel
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE DATABASE $PROJECTDB;"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "CREATE DATABASE $SENTINELDB;"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $PROJECTDB.* TO '$USERID1001'@'$PROJECTDBHOST' IDENTIFIED BY '$USERID1001PASSWORD' WITH GRANT OPTION;"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "GRANT ALL PRIVILEGES ON $SENTINELDB.* TO '$USERID1001'@'$SENTINELDBHOST' IDENTIFIED BY '$USERID1001PASSWORD' WITH GRANT OPTION;"
mysql -u"$DBROOTUSER" -p"$DBROOTPASSWORD" <<< "FLUSH PRIVILEGES;"

# Fill the databases with data goodness

mysql -u"$USERID1001" -p"$USERID1001PASSWORD" <<< "
CREATE TABLE `$PROJECTDB.users` (
  `userid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'This is the be all and end all id, this is what identifies our user in our system.',
  `active` char(1) DEFAULT NULL,
  `fname` char(50) DEFAULT NULL COMMENT 'This is the user''s first name, birth certificate/legal name stuff',
  `nickname` char(50) DEFAULT NULL COMMENT 'This is the nickname that a user would prefer to use in place of a first name-- which our app will respect',
  `lname` char(50) DEFAULT NULL COMMENT 'The last name of the user',
  `password` char(255) DEFAULT NULL COMMENT 'This field stores the password hash particulars / salted hash',
  `sessionStart` int(10) unsigned DEFAULT NULL COMMENT 'When the user initially ''logged in'' and had a successful authentication as a timestamp',
  `sessionRenewal` int(10) unsigned DEFAULT NULL COMMENT 'This is an activity that extends the active sesion as a timestamp',
  `lastModified` int(10) unsigned DEFAULT NULL COMMENT 'This field stores the last change for searching in the logs',
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table is what it is all about.';"


mysql -u"$USERID1001" -p"$USERID1001PASSWORD" <<< "
CREATE TABLE `$PROJECTDB.phones` (
  `phonesid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL COMMENT 'The id that ties the phone to a user',
  `phoneType` enum('landline','mobile','multi-ring','fax','tdd-tty','other') DEFAULT NULL COMMENT 'What type of device or endpoint is this number representing',
  `sms` char(1) DEFAULT NULL COMMENT 'Can this phone receive sms entries',
  `title` char(80) DEFAULT NULL,
  `areaCode` smallint(6) DEFAULT NULL COMMENT 'What the phone is to display to the user',
  `prefix` smallint(6) DEFAULT NULL COMMENT 'The phone number prefix',
  `number` smallint(6) DEFAULT NULL COMMENT 'the four numbers that make a phone number individual',
  `extention` char(80) DEFAULT NULL COMMENT 'Extension information about the phone number',
  `lastModified` int(10) unsigned DEFAULT NULL COMMENT 'This field is used to track the last change in the logs',
  PRIMARY KEY (`phonesid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='the table with US format phone numbers';"


# Run the sentinel SQL scripts

mysql mysql -u"$USERID1001" -p"$USERID1001PASSWORD" "$SENTINELDB" < $PROJECTROOT/vendor/cartalyst/sentinel/schema/mysql-5.6+.sql

cd $PROJECTROOT/dal
$PROJECTROOT/vendor/propel/propel/bin/propel reverse "mysql:host=$PROJECTDBHOST;dbname=$PROJECTDB;user=$USERID1001;password=$USERID1001PASSWORD" --output-dir=$PROJECTROOT/dal/config

#Configure the DSN and settings for the model classes generation

cd $PROJECTROOT/dal/config

#conditionals go here to setup differently for which system they are on AWS, local, or docker

cat <<EOF > $PROJECTROOT/dal/config/propel.json
{
    "propel": {
        "database": {
            "connections": {
                "default": {
                    "adapter": "mysql",
                    "dsn": "mysql:host=$PROJECTDBHOST;port=3306;dbname=$PROJECTDB",
                    "user": "$USERID1001",
                    "password": "$USERID1001PASSWORD",
                    "settings": {
                        "charset": "utf8"
                    }
                }
            }
        }
    }
}
EOF



#Build the model classes and put them in a more convenient place
$PROJECTROOT/vendor/propel/propel/bin/propel model:build

mv $PROJECTROOT/dal/config/generated-classes $PROJECTROOT/dal

if [ "$DEV" = "true" ]
    then
    composer composer install --optimize-autoloader
    else
    composer.phar install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
fi

cat <<EOF > $PROJECTROOT
{
    "name": "viperks/api",
    "description": "The viperks api dependencies",
    "license": "Unlicense",
    "minimum-stability": "dev",
    "prefer-stable": true,
    "require": {
        "cartalyst/sentinel": ">=2.0 <3.0",
        "ext-gd": "*",
        "ext-mcrypt": "*",
        "ezyang/htmlpurifier": ">=4.7 <5.0",
        "firebase/php-jwt": ">=4.0 <5.0",
        "funct/funct": ">=1.1 <2.0",
        "google/apiclient": ">=1.1 <2.0",
        "guzzlehttp/guzzle": ">=6.0 <7.0",
        "illuminate/database": ">=5.2 <6.0",
        "illuminate/events": ">=5.2 <6.0",
        "illuminate/pagination": ">=5.3 <6.0",
        "league/csv": ">=8.0 <9.0",
        "mailgun/mailgun-php": ">=2.1 <3.0",
        "monolog/monolog": ">=1.0 <2.0",
        "mpdf/mpdf": ">=6.0 <7.0",
        "nategood/httpful": ">=0.2 <1.0",
        "paragonie/random_compat": ">=2.0 <3.0",
        "phpmailer/phpmailer": ">=5.2 <6.0",
        "phpoffice/phpexcel": ">=1.8 <2.0",
        "propel/propel": "~2.0@dev",
        "psr/log": ">=1.0 <2.0",
        "swiftmailer/swiftmailer": ">=5.4 <6.0",
        "symfony/intl": ">=3.1 <4.0"
    },
    "require-dev": {
        "phpmd/phpmd": "*",
        "phpunit/phpunit": ">=5.0 <6.0",
        "squizlabs/php_codesniffer": "*"
    },
    "autoload": {
        "psr-0": {
            "$PROJECTNAME": "app/src/",
            "$PROJECTNAME\\Database\\Propel": "app/src/database/propel",
            "$PROJECTNAME\\User": "app/src/user",
            "$PROJECTNAME\\Utility\\DbObjectAccess": "app/src/utility/db-object-access",
            "$PROJECTNAME\\Utility\\PostCleanup": "app/src/utility/post-cleanup",
            "$PROJECTNAME\\Utility\\Reporting": "app/src/utility/reporting"

        },
        "classmap": ["$PROJECTROOT/dal/generated-classes/"]
    },
    "autoload-dev": {
        "psr-0": {
            "$PROJECTNAME\\Tests": "app/tests/"
        }
    }
}
EOF

cd $PROJECTROOT

composer dump-autoload
