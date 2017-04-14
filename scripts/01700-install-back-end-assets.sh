printf "\n\n##### Beginning 01700-install-back-end-assets.sh\n\n" >> /root/report/build-report.txt

printf "\n## CONVERT BASH VARIABLES TO PERSISTENT VARIABLES AVAILABLE TO PHP\n\n"

printf "\nHOSTNAME=$HOSTNAME" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\nDOMAIN=$DOMAIN" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\nHOSTINGSERV=$HOSTINGSERV" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\nDEV=$DEV" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\nTARGETEMAIL=$TARGETEMAIL" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\nCOUNTRY=$COUNTRY" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini
printf "\nSTATE=$STATE" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini
printf "\nLOCALITY=$LOCALITY" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini
printf "\nORGANIZATION=$ORGANIZATION" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini
printf "\nORGANIZATIONALUNIT=$ORGANIZATIONALUNIT" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\nDEFAULTSITEDBUSER=$DEFAULTSITEDBUSER" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini
printf "\nDEFAULTSITEDBPASSWORD=$DEFAULTSITEDBPASSWORD" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini
printf "\nPROJECTDBHOST=$PROJECTDBHOST" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini
printf "\nSENTINELDBHOST=$SENTINELDBHOST" >> /etc/php/7.1/fpm/conf.d/50-user-supplied-vars.ini

printf "\n## INSTALL PHP COMPOSER\n\n"

EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
    php composer-setup.php --quiet --install-dir=/bin --filename=composer
    RESULT=$?
    rm composer-setup.php
    #exit $RESULT
else
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    #exit 1
fi

printf "\n## FIRST COMPOSER INSTALL\n\n"

cd /var/www

cat <<EOF > $PROJECTROOT/composer.json
{
    "name": "$PROJECTNAME",
    "description": "The $PROJECTNAME dependencies",
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

composer install --no-ansi --no-dev --no-interaction --no-progress --no-scripts

printf "\n## SET UP SENTINEL DB\n\n"
# Run the sentinel SQL scripts

mysql -u"$DEFAULTSITEDBUSER" -p"$DEFAULTSITEDBPASSWORD" "$SENTINELDB" < $PROJECTROOT/vendor/cartalyst/sentinel/schema/mysql-5.6+.sql

printf "\n## REVERSE ENGINEER DB XML SCHEMA FOR ORM\n\n"

# Set up directories and reverse engineer the DB for the Propel ORM
mkdir -p $PROJECTROOT/$PROJECTNAME/dal/config

cd $PROJECTROOT/$PROJECTNAME/dal
$PROJECTROOT/vendor/propel/propel/bin/propel reverse "mysql:host=$PROJECTDBHOST;dbname=$PROJECTDB;user=$DEFAULTSITEDBUSER;password=$DEFAULTSITEDBPASSWORD" --output-dir=$PROJEDTROOT/$PROJECTNAME/dal/config

#Configure the DSN and settings for the model classes generation

printf "\n## CONFIGURE ORM DB CONFIGURATION\n\n"

cd $PROJECTROOT/$PROJECTNAME/dal/config

cat <<EOF > $PROJECTROOT/$PROJECTNAME/dal/config/propel.json
{
    "propel": {
        "database": {
            "connections": {
                "default": {
                    "adapter": "mysql",
                    "dsn": "mysql:host=$PROJECTDBHOST;port=3306;dbname=$PROJECTDB",
                    "user": "$DEFAULTSITEDBUSER",
                    "password": "$DEFAULTSITEDBPASSWORD",
                    "settings": {
                        "charset": "utf8"
                    }
                }
            }
        }
    }
}
EOF

printf "\n## GENERATE ORM DB ACCESS CODE\n\n"

#Build the model classes and put them in a more convenient place
$PROJECTROOT/vendor/propel/propel/bin/propel model:build

mv $PROJECTROOT/$PROJECTNAME/dal/config/generated-classes $PROJECTROOT/$PROJECTNAME/dal

printf "\n## REWRITE COMPOSER.JSON TO USE ORM ACCESS CODE\n\n"

cat <<EOF > $PROJECTROOT/composer.json
{
    "name": "$PROJECTNAME",
    "description": "The $PROJECTNAME dependencies",
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
        "psr-4": {
            "$PROJECTNAME\\Src": "$PROJECTROOT/$PROJECTNAME/src",


        },
        "classmap": ["$PROJECTROOT/$PROJECTNAME/dal/generated-classes/"]
    },
    "autoload-dev": {
        "psr-4": {
            "$PROJECTNAME\\Test": "$PROJECTROOT/$PROJECTNAME/tests"
        }
    }
}
EOF

printf "\n## GENERATE FOUNDATION APP CODE\n\n"
mkdir -p $PROJECTROOT/$PROJECTNAME/src/Database
mkdir -p $PROJECTROOT/$PROJECTNAME/src/Utility
mkdir -p $PROJECTROOT/$PROJECTNAME/tests

cat <<EOF > $PROJECTROOT/$PROJECTNAME/src/Database/InitPropel.php
<?php namespace $PROJECTNAME\Database;

use Illuminate\Database\Capsule\Manager as Capsule;
use Propel\Common\Config\ConfigurationManager;
use Propel\Runtime\Connection\ConnectionManagerSingle;

class InitPropel {
    public $serviceContainer;

    public function __construct()
    {
        $capsuleConfig = ['driver' => 'mysql',
                'host' => get_cfg_var('PROJECTDBHOST'),
                'database' => get_cfg_var('PROJECTDB'),
                'username' => get_cfg_var('DEFAULTSITEDBUSER'),
                'password' => get_cfg_var('DEFAULTSITEDBPASSWORD'),
                'charset' => 'utf8',
                'collation' => 'utf8_unicode_ci'
        ];

        // Setup a new Eloquent Capsule instance
        $capsule = new Capsule;
        $capsule->addConnection($capsuleConfig);
        $capsule->bootEloquent();

        // Load the configuration file
        $configManager = new ConfigurationManager('$PROJEDTROOT/$PROJECTNAME/dal/config/propel.json');

        // Set up the connection manager
        $manager = new ConnectionManagerSingle();
        $manager->setConfiguration($configManager->getConnectionParametersArray()['default']);
        $manager->setName('default');

        //*
        // Add the connection manager to the service container
        // the IDE does not see into $PROJECTROOT/html/$PROJECTNAME/dal/generated-classes
        // this next lines are defined there and the proper use statement is supplied
        $this->serviceContainer = "";
        $this->serviceContainer = Propel::getServiceContainer();
        $this->serviceContainer->setAdapterClass('default', 'mysql');
        $this->serviceContainer->setConnectionManager('default', $manager);
        $this->serviceContainer->setDefaultDatasource('default');

    }


    public function getPopulatedServiceContainer()
    {
        return $this->serviceContainer;
    }
}
EOF

if [ "$DEV" = "true" ]
    then

# build user object based on DB data related to the user

printf "
Once logged in to mysql client...

mysql> describe users;
+----------------+------------------+------+-----+---------+----------------+
| Field          | Type             | Null | Key | Default | Extra          |
+----------------+------------------+------+-----+---------+----------------+
| userid         | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| active         | char(1)          | YES  |     | NULL    |                |
| fname          | char(50)         | YES  |     | NULL    |                |
| nickname       | char(50)         | YES  |     | NULL    |                |
| lname          | char(50)         | YES  |     | NULL    |                |
| password       | char(255)        | YES  |     | NULL    |                |
| sessionStart   | int(10) unsigned | YES  |     | NULL    |                |
| sessionRenewal | int(10) unsigned | YES  |     | NULL    |                |
| lastModified   | int(10) unsigned | YES  |     | NULL    |                |
+----------------+------------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> describe emails;
+--------------+----------------------------------------------------------------------+------+-----+---------+----------------+
| Field        | Type                                                                 | Null | Key | Default | Extra          |
+--------------+----------------------------------------------------------------------+------+-----+---------+----------------+
| emailsid     | int(10) unsigned                                                     | NO   | PRI | NULL    | auto_increment |
| userid       | int(10) unsigned                                                     | YES  | MUL | NULL    |                |
| title        | char(80)                                                             | YES  |     | NULL    |                |
| account      | char(70)                                                             | YES  | MUL | NULL    |                |
| host         | char(255)                                                            | YES  | MUL | NULL    |                |
| level        | enum('all','marketing','information','notifications','legal','none') | YES  |     | NULL    |                |
| lastModified | int(10) unsigned                                                     | YES  |     | NULL    |                |
+--------------+----------------------------------------------------------------------+------+-----+---------+----------------+
7 rows in set (0.00 sec)

mysql> describe phones;
+--------------+----------------------------------------------------------------+------+-----+---------+----------------+
| Field        | Type                                                           | Null | Key | Default | Extra          |
+--------------+----------------------------------------------------------------+------+-----+---------+----------------+
| phonesid     | int(10) unsigned                                               | NO   | PRI | NULL    | auto_increment |
| userid       | int(10) unsigned                                               | YES  | MUL | NULL    |                |
| phoneType    | enum('landline','mobile','multi-ring','fax','tdd-tty','other') | YES  |     | NULL    |                |
| sms          | char(1)                                                        | YES  |     | NULL    |                |
| title        | char(80)                                                       | YES  |     | NULL    |                |
| areaCode     | smallint(6)                                                    | YES  |     | NULL    |                |
| prefix       | smallint(6)                                                    | YES  |     | NULL    |                |
| number       | smallint(6)                                                    | YES  |     | NULL    |                |
| extention    | char(80)                                                       | YES  |     | NULL    |                |
| lastModified | int(10) unsigned                                               | YES  |     | NULL    |                |
+--------------+----------------------------------------------------------------+------+-----+---------+----------------+
10 rows in set (0.00 sec)"
fi

printf "\n## GENERATING EXAMPLE OBJECT CODE\n\n"

cat <<EOF > $PROJECTROOT/$PROJECTNAME/src/user.php
<?php namespace $PROJECTNAME

// Include the composer autoload file
require $PROJECTROOT/vendor/autoload.php

use Propel\Common\Config\ConfigurationManager;
use Propel\Runtime\Connection\ConnectionManagerSingle;
use Propel\Runtime\Propel;

use Firebase\JWT;
use app\src\Utility;

//use Monolog\Logger;
//use Monolog\Handler\StreamHandler;

class User {

  public userid;
  public active;
  public fname;
  public lname;
  public password;
  public sessionStart;
  public sessionRenewal;
  public emails; //object list
  public phones; //object list

  public function __construct(int $userid = null, string $email = null) {
    // on instantiating a user object-- just populate all the data from users. Need most of it for many things.
      if(isset($userid) {
          $basicUserDetailsQuery = new UserheadQuery();
          $basicUserData = $basicUserDetailsQuery->create()->filterByUserid($userid)->find()->getData();
      }
      elseif(isset($email) && !isset($userid) {
        // Use email to
      }
      else {
        // We got nothing to give to the clothing industry or there's been a mistake....
      }




  }

  private function getUserIdFromEmail(string $account, string $host) {

  }

}
EOF

cat <<EOF > "$APIWEBROOT/1/user/logout"
<?php

?>
EOF

cat <<EOF > "$APIWEBROOT/1/user/register"
<?php
require $PROJECTROOT/vendor/autoload.php;

$credentials = [
    'email'    => $clean['email'],
    'password' => $clean['password']
];

$user = Sentinel::register($credentials);

?>
EOF

cat <<EOF > "$APIWEBROOT/1/user/activate"
<?php

?>
EOF

cat <<EOF > "$APIWEBROOT/1/user/login"
<?php

$email = trim(str_replace("\xc2\xa0", ' ', $_POST['email']));
$password = trim(str_replace("\xc2\xa0", ' ', $_POST['password']));

}
?>
EOF

cat <<EOF > "$APIWEBROOT/1/user/read"
<?php

?>
EOF

cat <<EOF > "$APIWEBROOT/1/user/modify"
<?php

?>
EOF

cat <<EOF > "$APIWEBROOT/1/user/remove"
<?php

?>
EOF

printf "\n## SETUP PHPUNIT CONFIG\n\n"

cat <<EOF > $PROJECTROOT/phpunit.xml
<phpunit bootstrap="vendor/autoload.php"
  colors="true"
  convertErrorsToExceptions="true"
  convertNoticesToExceptions="true"
  convertWarningsToExceptions="true"
  processIsolation="false"
  stopOnFailure="false"
  syntaxCheck="false"

  <testsuites>
    <testsuite name="$PROJECTNAME Tests">
      <directory>test</directory>
    </testsuite>
  </testsuites>
</phpunit>
EOF

printf "\n## WRITE EXAMPLE TEST CODE\n\n"

cat <<EOF > $PROJECTROOT/$PROJECTNAME/tests/initpropelTest.php
<?php

require $PROJECTROOT/vendor/autoload.php

use App\Src\Database;

class PropelTest extends PHPUnit_Framework_TestCase {
  public function testInitializationOfPropel()
  {
    $connectionReady = new Initpropel;

    $this->assertInstanceOf('Initpropel',$connectionReady);
  }
}
EOF

printf "\n## CLEAN UP\n\n"

rm -rf $PROJECTROOT/vendor $PROJECTROOT/composer.lock

printf "\n## HERE WE GO, COMPOSER INSTALL\n\n"

if [ "$DEV" = "true" ]
    then
    composer composer install --optimize-autoloader
    else
    composer.phar install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
fi

cd $PROJECTROOT
composer dump-autoload
