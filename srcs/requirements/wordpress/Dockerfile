FROM alpine:3.14

RUN apk add --no-cache curl bash

RUN apk add --no-cache \
	php7 \
	php-phar \
	php-json \
	php-curl \
	php-fpm \
	php-mysqli \
	php-iconv

# Download wordpress
WORKDIR /tmp
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
	&& tar -xzf wordpress.tar.gz \
	&& mv wordpress/* /var/www/wordpress/ \
	&& rm -rf wordpress wordpress.tar.gz

