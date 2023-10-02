ARG PHP_VERSION

FROM php:${PHP_VERSION} AS PHP

RUN apt-get -y update && apt-get install -y libonig5 libargon2-1 supervisor nginx && apt-get clean
COPY nginx/defaults.d /etc/supervisor/defaults.d
COPY nginx/supervisord.conf /etc/supervisor/
COPY nginx/nginx.d/* /etc/nginx/


# USER 1000

CMD [ "supervisord","-n","-c","/etc/supervisor/supervisord.conf" ]
