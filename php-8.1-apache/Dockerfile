FROM php:8.1-apache-bookworm
RUN apt-get -y update && apt-get install -y supervisor && apt-get clean
COPY php-8.1-apache/defaults.d /etc/supervisor/defaults.d
COPY php-8.1-apache/supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]