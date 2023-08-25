FROM php:8.3.0beta3-apache-bookworm
RUN apt-get -y update && apt-get install -y supervisor
COPY php-8.3.0beta3-apache/defaults.d /etc/supervisor/defaults.d
COPY php-8.3.0beta3-apache/supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]