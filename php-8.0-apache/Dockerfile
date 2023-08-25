FROM php:8.0-apache-bullseye
RUN apt-get -y update && apt-get install -y supervisor
COPY defaults.d /etc/supervisor/defaults.d
COPY supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]