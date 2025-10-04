FROM alpine:3.14

RUN apk add --no-cache curl bash

RUN apk add --no-cache \
	php7 \
	php-phar \
	php-json \
	php-curl \
	php-fpm \
	php-mysqli \
	php-iconv \
	php-mbstring \
	php-xml \
	php-zip \
	php-gd \
	php-opcache

# Create directory
RUN		mkdir -p /var/www/wordpress
WORKDIR	/var/www/wordpress

# Download WP-CLI
# WORKDIR /tmp
RUN curl -o wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# Set permissions for wordpress
# RUN	chown -R www-data:www-data /var/www/html

# Download wordpress
RUN		wp core download --allow-root

# Copy PHP-FPM pool config
COPY	/conf/www.conf /etc/php7/php-fpm.d/www.conf

# Expose php-fpm port
EXPOSE	9000

CMD ["php-fpm7", "-F"]
