
ARG PHP_VERSION="8.3-apache-bookworm"
FROM ghcr.io/fmotalleb/php-supervisor:${PHP_VERSION}

# Default packages needed for most laravel applications
ARG APT_PACKAGES="curl libpng-dev libonig-dev libxml2-dev zip unzip libsodium-dev git libzip-dev"
LABEL apt.packages="${APT_PACKAGES}"
# Default php_extensions needed for most laravel applications
ARG PHP_EXTENSIONS="pdo_mysql mbstring exif pcntl bcmath gd sodium soap zip"
LABEL php.extensions="${PHP_EXTENSIONS}"

# Default required apache_mod for Laravel application
ARG APACHE_MODS="rewrite"
LABEL webserver.mods="${APACHE_MODS}"

ENV ALLOW_OVERRIDE=true
# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends ${APT_PACKAGES} && \
    docker-php-ext-install ${PHP_EXTENSIONS} && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    sed 's@/var/www/html@/var/www/public@g' /etc/apache2/sites-available/000-default.conf | tee /etc/apache2/sites-available/000-laravel.conf && \
    a2enmod ${APACHE_MODS} && \
    a2dissite 000-default.conf && \
    a2dissite default-ssl.conf && \
    a2ensite 000-laravel.conf

# Initialize app-data
COPY ${PWD}/ /var/www
WORKDIR /var/www/

# Composer version from https://getcomposer.org/download/
ARG COMPOSER_VERSION="latest-stable"
LABEL composer.version="${COMPOSER_VERSION}"
# Default settings will enable composer direct call in terminal
ARG COMPOSER_INSTALL_PATH="/usr/local/bin/composer"
LABEL composer.path="${COMPOSER_INSTALL_PATH}"

# Default settings will call `composer install`
ARG COMPOSER_ARGS="install"
ENV COMPOSER_DOWNLOAD_URL="https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar"
# install composer + dependencies
RUN curl "${COMPOSER_DOWNLOAD_URL}" -o "${COMPOSER_INSTALL_PATH}" && \
    chmod +x "${COMPOSER_INSTALL_PATH}"
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN ${COMPOSER_INSTALL_PATH} ${COMPOSER_ARGS}