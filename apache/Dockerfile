ARG PHP_VERSION
FROM php:${PHP_VERSION}

LABEL php.tag="${PHP_VERSION}"
LABEL webserver="apache"

RUN apt-get -y update && apt-get install -y supervisor && apt-get clean
COPY apache/defaults.d /etc/supervisor/defaults.d
COPY global.supervisor/supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]