FROM php:8-fpm-alpine3.12

ARG USER=app
ARG USERID=1000

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN set -ex && apk --update --no-cache add \
    $PHPIZE_DEPS \
    git \
    postgresql-dev \
    rabbitmq-c-dev \
    openjdk8-jre \
    supervisor \
    busybox-suid \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql \
    && docker-php-source extract \
    && mkdir /usr/src/php/ext/amqp \
    && curl -L https://github.com/php-amqp/php-amqp/archive/master.tar.gz | tar -xzC /usr/src/php/ext/amqp --strip-components=1 \
    && docker-php-ext-install amqp \
    && docker-php-ext-enable amqp \
    && pecl install xdebug-3.0.0 \
    && install-php-extensions xdebug-3.0.0 \
    # Clean-up
    && apk del ${PHPIZE_DEPS} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/*

RUN adduser -S -D -H -u $USERID -s /bin/sh $USER -G www-data \
    && mkdir -p /app/var/log \
    && chown -R $USER:www-data /app/var \
    && chmod -R 770 /app/var

COPY ./supervisor/supervisord.conf /etc/supervisord.conf
COPY ./conf.d/php.ini /usr/local/etc/php/php.ini
COPY ./conf.d/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./cron/crontab /etc/crontabs/root

ENV PHP_IDE_CONFIG="serverName=Docker"
ENV XDEBUG_CONFIG="remote_host=host.docker.internal"

WORKDIR /app
EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
