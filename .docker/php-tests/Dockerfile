FROM php:8-cli-alpine3.12
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN set -ex && apk --update --no-cache add \
    $PHPIZE_DEPS \
    git \
    postgresql-dev
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql \
    && pecl install xdebug-3.0.0 \
    && install-php-extensions xdebug-3.0.0

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin \
    --filename=composer \
    --version=2.0.7
#CMD composer install ; wait-for-it database:3306 -- bin/console doctrine:migrations:migrate ;  php-fpm
EXPOSE 9000