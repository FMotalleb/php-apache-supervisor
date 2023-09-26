ARG PHP_VERSION
ARG NGINX_VERSION=bookworm
FROM php:${PHP_VERSION} AS PHP

FROM nginx:${NGINX_VERSION} AS RUNTIME
RUN apt-get -y update && apt-get install -y libonig5 libargon2-1 supervisor && apt-get clean
COPY nginx/defaults.d /etc/supervisor/defaults.d
COPY nginx/supervisord.conf /etc/supervisor/

# Copy all php files into nginx image
COPY --from=PHP /etc/apt/preferences.d/no-debian-php    /etc/apt/preferences.d/no-debian-php
COPY --from=PHP /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf.default
COPY --from=PHP /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY --from=PHP /usr/local/etc/php-fpm.d    /usr/local/etc/php-fpm.d
# COPY --from=PHP /usr/local/etc/conf.d/  /usr/local/etc/conf.d/
# COPY --from=PHP /usr/local/etc/php.ini-development  /usr/local/etc/php.ini-development
# COPY --from=PHP /usr/local/etc/php.ini-production   /usr/local/etc/php.ini-production
COPY --from=PHP /usr/local/include/php/ /usr/local/include/php/
COPY --from=PHP /usr/local/lib/php/ /usr/local/lib/php/
COPY --from=PHP /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm
COPY --from=PHP /usr/local/bin/docker-php-ext-enable    /usr/local/bin/docker-php-ext-enable
COPY --from=PHP /usr/local/bin/docker-php-ext-configure /usr/local/bin/docker-php-ext-configure
COPY --from=PHP /usr/local/bin/docker-php-source    /usr/local/bin/docker-php-source
COPY --from=PHP /usr/local/bin/phpize   /usr/local/bin/phpize
COPY --from=PHP /usr/local/bin/php  /usr/local/bin/php
COPY --from=PHP /usr/local/bin/php-config   /usr/local/bin/php-config
COPY --from=PHP /usr/local/bin/docker-php-entrypoint    /usr/local/bin/docker-php-entrypoint
COPY --from=PHP /usr/local/bin/docker-php-ext-install   /usr/local/bin/docker-php-ext-install

# USER 1000

CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]