**PHP-Supervisor: An Out-of-the-Box Solution for PHP-Based Images**

The `php-supervisor` is a turnkey solution designed to replace basic PHP images by seamlessly integrating Supervisor to handle the initiation and management of PHP and Apache processes internally. This comprehensive containerization approach streamlines the deployment and orchestration of PHP applications, making it a valuable tool for developers seeking a hassle-free way to ensure the reliable execution of their web applications.

With `php-supervisor`, you can effortlessly containerize your PHP applications without worrying about the intricacies of process management. By utilizing Supervisor internally, this solution simplifies the setup and maintenance of your PHP and Apache processes, offering an efficient and reliable foundation for your containerized web applications.

**Key Features of `php-supervisor`:**

1. **Effortless PHP Containerization**: Easily package your PHP application into a Docker container with all the necessary components in place.

2. **Apache Integration**: Seamlessly incorporate the Apache web server into your containerized environment, providing a complete web hosting solution.

3. **Supervisor for Process Management**: The supervisor is employed internally to take care of starting, monitoring, and managing both PHP and Apache processes within the container.

4. **Custom Configuration**: Tailor the Supervisor configuration to meet your specific requirements, ensuring that it aligns perfectly with your application's needs.

5. **Out-of-the-Box Convenience**: Get up and running quickly with minimal configuration, reducing the time and effort needed to deploy PHP-based web applications.

Whether you're a seasoned developer or new to containerization, `php-supervisor` offers a user-friendly solution for deploying PHP applications while taking the complexity out of process management. Say goodbye to the challenges of coordinating PHP and Apache in a container – this image provides an out-of-the-box answer to your PHP+Supervisor containerization needs.

In summary, `php-supervisor` is a powerful and convenient tool that simplifies the deployment of PHP applications in a containerized environment. By leveraging Supervisor internally, ensures the smooth execution of PHP and Apache processes, allowing you to focus on what matters most: building and delivering exceptional web applications.

The only change you may need to apply to your Dockerfiles is replacing the image name from `php:<tag>-alpine|bookworm` with `ghcr.io/fmotalleb/php-supervisor:php-<tag>`.

All images are based on a stable Debian version derived from PHP's original image.
## Laravel App Example
```Dockerfile
ARG COMPOSER_IMAGE_TAG="2.5.8"
ARG PHP_VERSION="8.2"
FROM composer:${COMPOSER_IMAGE_TAG} AS composer

FROM ghcr.io/fmotalleb/php-supervisor:php-${PHP_VERSION}-apache

ARG APACHE_CONF_PATH="/etc/apache2/sites-available/000-default.conf"
ARG COMPOSER_INSTALL_PATH="/usr/local/bin/composer"
ARG COMPOSER_ARGS="install"
ARG PHP_EXTENSIONS="pdo_mysql mbstring exif pcntl bcmath gd sodium soap"
ARG APT_PACKAGES="curl libpng-dev libonig-dev libxml2-dev zip unzip libsodium-dev git libzip-dev"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends ${APT_PACKAGES}

# Install PHP extensions
RUN docker-php-ext-install ${PHP_EXTENSIONS}

# Apache Mods
RUN a2enmod rewrite
ENV ALLOW_OVERRIDE=true

# Clean up unnecessary packages
RUN apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ${PWD}/ /var/www

WORKDIR /var/www/

# Apache config
RUN sed 's@/var/www/html@/var/www/public@g' ${APACHE_CONF_PATH} | tee ${APACHE_CONF_PATH}

# install composer + dependencies
COPY --from=composer /usr/bin/composer ${COMPOSER_INSTALL_PATH}
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN ${COMPOSER_INSTALL_PATH} ${COMPOSER_ARGS}
```
