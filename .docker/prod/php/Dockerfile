FROM php:8-fpm-alpine3.12
ARG USER=app
ARG USERID=1000

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN set -ex && apk --update --no-cache add \
    $PHPIZE_DEPS \
    postgresql-dev \
    rabbitmq-c-dev \
    openjdk8-jre \
    supervisor \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql \
    && docker-php-source extract \
    && mkdir /usr/src/php/ext/amqp \
    && curl -L https://github.com/php-amqp/php-amqp/archive/master.tar.gz | tar -xzC /usr/src/php/ext/amqp --strip-components=1 \
    && docker-php-ext-install amqp \
    && docker-php-ext-enable amqp \
    # Clean-up
    && apk del ${PHPIZE_DEPS} postgresql-dev \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/*
    # Folders and permissions
    && mkdir -p /var/log/supervizord \
    && adduser -D -u $USERID -s /bin/sh $USER -G www-data \
    && mkdir -p /app/storage/files /app/var/log \
    && chown -R $USER:www-data /app/storage/files /app/var \
    && chmod -R 770 /app/storage/files /app/var

COPY ./supervisor/supervisord.conf /etc/supervisord.conf
COPY ./conf.d/php.ini /usr/local/etc/php/php.ini
COPY ./cron/crontab /etc/crontabs/root

WORKDIR /app
EXPOSE 9000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
