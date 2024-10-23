#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    echo "Installing composer dependencies..."
    composer installn --no-progress --no-interaction
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
else
    echo "env file exists."
fi

php-fpm -D
nginx -g "daemon off;"

php artisan migrate
php artisan key:generate
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear




