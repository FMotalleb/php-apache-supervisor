# PHP+Supervisor+Apache

**PHP-Supervisor: An Out-of-the-Box Solution for PHP-Based Images**

* Supported tags:

    > **apache**
    >
    > * apache-bookworm
    > * apache-bullseye
    > * 8.3-rc-apache-bookworm
    > * 8.2-apache-bookworm
    > * 8.1-apache-bookworm
    > * 7.4-apache-bullseye
    > * 7.3-apache-bullseye

    > **fpm**
    >
    > * fpm-bookworm
    > * fpm-bullseye
    > * 8.3-rc-fpm-bookworm
    > * 8.2-fpm-bookworm
    > * 8.1-fpm-bookworm
    > * 7.4-fpm-bullseye
    > * 7.3-fpm-bullseye
    >
* Example: `docker run --rm -it -p 80:80 ghcr.io/fmotalleb/php-supervisor:8.2-apache-bookworm`

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

The only change you may need to apply to your Dockerfiles is replacing the image name from `php:<tag>` with `ghcr.io/fmotalleb/php-supervisor:<tag>`. (only supported tags are stable Debian builds as provided above)

* If you need to build this image for any other tags
  * Note 1. Alpine is not supported
  * Note 2. Only fpm or Apache are available
  * Note 3. In order to build an image you need to use a Debian +buster base image (currently Buster and Bookworm)  

```
git clone https://github.com/FMotalleb/php-supervisor.git
cd php-supervisor
docker build . -f ./<fpm or apache>/Dockerfile --build-arg="PHP_VERSION=<Debian Tag>"
```

All images are based on a stable Debian version derived from PHP's original image.

## Laravel App Example

Using build arguments enables you to customize the build process. With this Dockerfile,
you are able to set the desired Composer/PHP version, Composer arguments, default PHP mods, Apache mods, and more.

* Example build command to build this image for php:8.1-apache-bookworm and latest version of composer

```bash
docker build . -t my_php:8.1 --build-arg "COMPOSER_IMAGE_TAG=latest" --build-arg "PHP_VERSION=8.1-apache-bookworm"
```

* Dockerfile

```Dockerfile
ARG COMPOSER_IMAGE_TAG="2.5.8"
ARG PHP_VERSION="8.2-apache-bookworm"
FROM composer:${COMPOSER_IMAGE_TAG} AS composer

FROM ghcr.io/fmotalleb/php-supervisor:${PHP_VERSION}

ARG APACHE_MODS="rewrite"
ARG COMPOSER_INSTALL_PATH="/usr/local/bin/composer"
ARG COMPOSER_ARGS="install"
ARG APT_PACKAGES="curl libpng-dev libonig-dev libxml2-dev zip unzip libsodium-dev git libzip-dev"
ARG PHP_EXTENSIONS="pdo_mysql mbstring exif pcntl bcmath gd sodium soap zip"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends ${APT_PACKAGES}

# Install PHP extensions
RUN docker-php-ext-install ${PHP_EXTENSIONS}

# Apache Mods
RUN a2enmod ${APACHE_MODS}
ENV ALLOW_OVERRIDE=true

# Clean up unnecessary packages
RUN apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ${PWD}/ /var/www

WORKDIR /var/www/

# Apache config
RUN sed 's@/var/www/html@/var/www/public@g' /etc/apache2/sites-available/000-default.conf | tee ${APACHE_CONF_PATH}

# install composer + dependencies
COPY --from=composer /usr/bin/composer ${COMPOSER_INSTALL_PATH}
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN ${COMPOSER_INSTALL_PATH} ${COMPOSER_ARGS}
```
