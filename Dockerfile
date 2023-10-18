FROM php:8.2-fpm

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
        libzip-dev \
        libpq-dev \
        chromium \
        chromium-driver \
        unzip \
        libmagickwand-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install zip pdo gd pdo_pgsql \
    && pecl install -o -f redis-7.0.8 imagick \
    && docker-php-ext-enable redis imagick

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 -g appuser \
    -G www-data,root --shell /bin/bash \
    --create-home appuser

USER appuser
