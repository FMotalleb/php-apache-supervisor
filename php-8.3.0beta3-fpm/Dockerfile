FROM php:8.3.0beta3-fpm-bookworm
RUN apt-get -y update && apt-get install -y supervisor && apt-get clean
COPY php-8.3.0beta3-fpm/defaults.d /etc/supervisor/defaults.d
COPY php-8.3.0beta3-fpm/supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]