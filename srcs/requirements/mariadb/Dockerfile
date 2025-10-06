FROM alpine:3.14

# Install bash and MariaDB
RUN 	apk update
RUN 	apk add --no-cache bash mariadb mariadb-client

# Create directories for MariaDB and give ownreship to the mysql user
RUN		mkdir -p /run/mariadb /var/lib/mysql /var/log/mysql && \
		chown -R mysql:mysql /run/mariadb /var/lib/mysql /var/log/mysql

# Copy config file to docker
COPY	tools/conf.sh /usr/local/bin
RUN		chmod +x /usr/local/bin/conf.sh

# Expose MariaDB port
EXPOSE	3306

# Configurate MariaDB
ENTRYPOINT ["conf.sh"]

# Start MariaDB in foreground (wrapper)
CMD ["mysqld_safe"]

# Start MariaDB. Foreground guaranteed by --console
# CMD ["mariadbd", "--user=mysql", "--console"]
