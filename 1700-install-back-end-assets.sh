cd /var/www
if [ "$viperksenv" = "dev" ]
    then
    composer composer install --optimize-autoloader
    else
    composer.phar install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
fi

#Don't forget to add the sentinel tables to the RDS instance
#ToDo

#Set up directories and reverse engineer the DB for the Propel ORM
mkdir -p /var/www/dal
mkdir -p /var/www/dal/config



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
            "Viperks": "src/",
            "Viperks\\Database\\Propel": "lib/database/propel",
            "Viperks\\Organization": "lib/organization",
            "Viperks\\Shipping": "lib/shipping",
            "Viperks\\Transaction": "lib/transaction",
            "Viperks\\User": "lib/user",
            "Viperks\\Utility\\DrupalPassword": "lib/utility/drupal-password",
            "Viperks\\Utility\\ObjectAccess": "lib/utility/object-access",
            "Viperks\\Utility\\PostCleanup": "lib/utility/post-cleanup",
            "viperks\\Utility\\Reporting": "lib/utility/reporting"

        },
        "classmap": ["/var/www/dal/generated-classes/"]
    },
    "autoload-dev": {
        "psr-0": {
            "Viperks\\Tests": "lib/tests/"
        }
    }
}
