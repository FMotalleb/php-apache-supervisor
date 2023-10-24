ARG PHP_VERSION
FROM php:${PHP_VERSION}

LABEL php.tag="${PHP_VERSION}"
LABEL webserver="none"

RUN apt-get -y update && apt-get install -y supervisor && apt-get clean
COPY fpm/defaults.d /etc/supervisor/defaults.d
COPY global.supervisor/supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]