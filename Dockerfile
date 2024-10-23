FROM php:8.2-fpm as php

# Set environment variables
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=1
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=1
ENV PHP_OPCACHE_REVALIDATE_FREQ=1

RUN usermod -u 1000 www-data
RUN apt-get update -y && apt-get install -y \
    unzip \
    libpq-dev \
    libzip-dev \
    nginx \
    libcurl4-openssl-dev \
    libonig-dev \
    libxml2-dev \
    libssl-dev \
    pkg-config \
    zlib1g-dev \
    && docker-php-ext-install pdo pdo_mysql bcmath curl opcache zip

WORKDIR /var/www
COPY --chown=www-data . .

# Copy custom PHP configuration
COPY ./docker/nginx/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/nginx/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

COPY --from=composer:2.7.6 /usr/bin/composer /usr/bin/composer

# RUN php artisan cache:clear
# RUN php artisan config:clear

RUN chmod -R 755 /var/www/storage
RUN chmod -R 755 /var/www/bootstrap

ENTRYPOINT ["docker/entrypoint.sh"]