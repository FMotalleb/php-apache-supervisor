FROM php:7.4-apache-bullseye
RUN apt-get -y update && apt-get install -y supervisor
COPY php-7.4-apache/defaults.d /etc/supervisor/defaults.d
COPY php-7.4-apache/supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]