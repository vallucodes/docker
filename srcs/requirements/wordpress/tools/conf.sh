#!/bin/bash

# Exit scipt if any of the commands returns a non-zero exit status
set -e

# Check if environment variable is set
require_env() {
	var_name="$1"
	var_value="${!var_name}"
	if [ -z "$var_value" ]; then
		echo "❌ Missing required environment variable: $var_name"
		exit 1
	fi
}

# Required environment variables
require_env WORDPRESS_DB_HOST
require_env WORDPRESS_DB_USER
require_env WORDPRESS_DB_PASSWORD_FILE
require_env WORDPRESS_DB_NAME
require_env WORDPRESS_TITLE
require_env WORDPRESS_ADMIN_USERNAME
require_env WORDPRESS_ADMIN_PASSWORD_FILE
require_env WORDPRESS_ADMIN_EMAIL
require_env WORDPRESS_SECOND_USERNAME
require_env WORDPRESS_SECOND_PASSWORD_FILE
require_env WORDPRESS_SECOND_EMAIL
require_env URL

DB_PASSWORD="$(tr -d '\r\n' < "$WORDPRESS_DB_PASSWORD_FILE")"
WP_ADMIN_PASSWORD="$(tr -d '\r\n' < "$WORDPRESS_ADMIN_PASSWORD_FILE")"
USR_PASSWORD="$(tr -d '\r\n' < "$WORDPRESS_SECOND_PASSWORD_FILE")"


if [ ! -f /var/www/wordpress/wp-config.php ]; then
	echo "Downloading wordpress..."
	wp core download --path=/var/www/wordpress --allow-root
	echo "Configurationg wp-config.php..."
	wp config create \
		--path=/var/www/wordpress \
		--dbname="$WORDPRESS_DB_NAME" \
		--dbuser="$WORDPRESS_DB_USER" \
		--dbpass="$DB_PASSWORD" \
		--dbhost="$WORDPRESS_DB_HOST" \
		--allow-root
	echo "Installing wordpress..."
	wp core install \
		--path=/var/www/wordpress \
		--url="$URL" \
		--title="$WORDPRESS_TITLE" \
		--admin_user="$WORDPRESS_ADMIN_USERNAME" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_EMAIL" \
		--allow-root
	echo "Creating non-admin user..."
	wp user create \
		"$WORDPRESS_SECOND_USERNAME" \
		"$WORDPRESS_SECOND_EMAIL" \
		--path=/var/www/wordpress \
		--role=editor \
		--user_pass="$USR_PASSWORD" \
		--allow-root
fi

# Execute command in the container (php-fpm83 -F)
exec "$@"
