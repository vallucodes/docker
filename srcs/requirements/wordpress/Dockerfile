FROM alpine:3.21

RUN apk add --no-cache curl bash

RUN apk add --no-cache \
	php83 \
	php83-phar \
	php83-json \
	php83-curl \
	php83-fpm \
	php83-mysqli \
	php83-iconv \
	php83-mbstring \
	php83-xml \
	php83-zip \
	php83-gd \
	php83-opcache

# Configure PHP memory limit for CLI
RUN echo "memory_limit = 512M" >> /etc/php83/php.ini

# Create directory
RUN		mkdir -p /var/www/wordpress
WORKDIR	/var/www/wordpress

# Download and install WP-CLI
RUN		curl -o wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar \
		&& mv wp-cli.phar /usr/local/bin/wp

# Create user to run WP and PHP
# -S: create system group
# || true: if group already exists, build doesn't fail
# -D: create a default user (no password, no home directory unless specified)
# -S: mark as system user (no login, no home directory)
# -G www-data: add user to the group www-data
# www-data: name of the user
RUN		addgroup -S www-data || true \
		&& adduser -D -S -G www-data www-data

# Set permissions for wordpress
RUN		chown -R www-data:www-data /var/www/wordpress

# Copy wordpress initialization config to
# TODO change this to /usr/local/bin
COPY tools/conf.sh /conf.sh
RUN chmod +x /conf.sh

# Copy PHP-FPM pool config
COPY	conf/www.conf /etc/php83/php-fpm.d/www.conf

# Expose php-fpm port
EXPOSE	9000

# Set configuration script as entrypoint for docker
# TODO change this to ["conf.sh"]
ENTRYPOINT ["/conf.sh"]

# Launch FastCGI Process Manager.
# -F: keep as PID 1 in foreground
CMD ["php-fpm83", "-F"]
