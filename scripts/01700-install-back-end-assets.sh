printf "\n\n##### Beginning 01700-install-back-end-assets.sh\n\n" >> /root/report/build-report.txt

printf "\n## CONVERT BASH VARIABLES TO PERSISTENT VARIABLES AVAILABLE TO PHP\n\n"

printf "\nHOSTNAME=$HOSTNAME" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini

printf "\nDOMAIN=$DOMAIN" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini

printf "\nHOSTINGSERV=$HOSTINGSERV" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini

printf "\nDEV=$DEV" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini

printf "\nTARGETEMAIL=$TARGETEMAIL" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini

printf "\nCOUNTRY=$COUNTRY" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini
printf "\nSTATE=$STATE" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini
printf "\nLOCALITY=$LOCALITY" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini
printf "\nORGANIZATION=$ORGANIZATION" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini
printf "\nORGANIZATIONALUNIT=$ORGANIZATIONALUNIT" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini

printf "\nDEFAULTSITEDBUSER=$DEFAULTSITEDBUSER" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini
printf "\nDEFAULTSITEDBPASSWORD=$DEFAULTSITEDBPASSWORD" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini
printf "\nPROJECTDBHOST=$PROJECTDBHOST" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini
printf "\nSENTINELDBHOST=$SENTINELDBHOST" >> /etc/php/7.0/fpm/conf.d/50-user-supplied-vars.ini

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
    printf "\n Download & Install $RESULT\n"
else
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    printf "\n Sorry buckaroo, composer done failed\n"
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
        "monolog/monolog": "^1.22"
    },
    "autoload": {
        "psr-4": {
            "KingChesney\\": "KingChesney/src"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "KingChesney\\Test": "KingChesney/tests"
        }
    }
}
EOF

printf "\n## GENERATE FOUNDATION APP CODE\n\n"

mkdir -p $PROJECTROOT/$PROJECTNAME/src/Database
mkdir -p $PROJECTROOT/$PROJECTNAME/src/Utility
mkdir -p $PROJECTROOT/$PROJECTNAME/tests


printf "\n## GENERATING EXAMPLE OBJECT CODE\n\n"

cat <<EOF > $PROJECTROOT/$PROJECTNAME/src/User.php
<?php namespace $PROJECTNAME/User

// Include the composer autoload file
require $PROJECTROOT/vendor/autoload.php

use $PROJECTNAME\User;
use $PROJECTNAME\Utility;

use Monolog\Logger;
use Monolog\Handler\StreamHandler;

class User {

  public $userid;
  public $active;
  public $fname;
  public $lname;
  public $password;
  public $sessionStart;
  public $sessionRenewal;
  public $emails; //object list
  public $phones; //object list

  public function __construct(int $userid = null, string $email = null) {
    $this->userid = 1;
    $this->fname = 'Bob'
  }

  public function getDetails() {
  
    return $this->userid
    

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
      <directory>$PROJECTNAME/tests</directory>
    </testsuite>
  </testsuites>
</phpunit>
EOF

printf "\n## WRITE EXAMPLE TEST CODE\n\n"

cat <<EOF > $PROJECTROOT/$PROJECTNAME/tests/userTest.php
<?php

require $PROJECTROOT/vendor/autoload.php

use $PROJECTNAME/User;

class PropelTest extends PHPUnit_Framework_TestCase {
  public function testInitializationOfPropel()
  {
    $user = new User;
    
    $this->assertInstanceOf('User',$user);
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
