FROM php:8.1-apache-bookworm
RUN apt-get -y update && apt-get install -y supervisor
COPY defaults.d /etc/supervisor/defaults.d
COPY supervisord.conf /etc/supervisor/
CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]