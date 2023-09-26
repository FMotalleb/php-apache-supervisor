
BUILD = docker build
CONTEXT = .
TAG = php-supervisor
COMPILE=make builder
all: apache fpm nginx
apache: 
	$(COMPILE) PHP_VERSION="8.2-apache-bookworm" FILE=apache/Dockerfile TAG=php-apache

fpm: 
	$(COMPILE) PHP_VERSION="8.2-fpm-bookworm" FILE=fpm/Dockerfile TAG=php-fpm
	
nginx: 
	$(COMPILE) PHP_VERSION="8.2-fpm-bookworm" FILE=nginx/Dockerfile TAG=nginx-php-fpm  

builder:
	$(BUILD) $(CONTEXT) -f $(FILE) -t $(TAG) --build-arg="PHP_VERSION=$(PHP_VERSION)"