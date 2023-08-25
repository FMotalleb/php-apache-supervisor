FROM php:8.0-fpm-bullseye
RUN apt-get -y update && apt-get install -y supervisor && apt-get clean
COPY php-8.0-fpm/defaults.d /etc/supervisor/defaults.d
COPY php-8.0-fpm/supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]