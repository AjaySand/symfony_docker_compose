#!/bin/sh

echo "frankenphp version: $SYMFONY_VERSION"
echo "$1"

if [ "$1" = 'frankenphp' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
    # Install the project the first time PHP is started
    echo "Install the project the first time PHP is started"
    if [ ! -f composer.json ]; then
        rm -rf tmp/
        composer create-project "symfony/skeleton $SYMFONY_VERSION" tmp --stability=$SYMFONY_STABILITY --prefer-dist --no-progress --no-interaction

        cd tmp
        cp -Rp . ..
        cd -
        rm -Rf tmp

        composer require "php:>=$PHP_VERSION" runtime/frankenphp-symfony
        composer config --json extra.symfony.docker 'true'
    fi

    setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var
fi


exec docker-php-entrypoint "$@"
