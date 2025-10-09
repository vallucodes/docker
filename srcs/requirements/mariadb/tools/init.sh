#!/bin/sh

# # Exit scipt if any of the commands returns a non-zero exit status
# set -e

# # Check if environment variable is set
# require_env() {
# 	var_name="$1"
# 	var_value="${!var_name}"
# 	if [ -z "$var_value" ]; then
# 		echo "❌ Missing required environment variable: $var_name"
# 		exit 1
# 	fi
# }

# # Required environment variables
# require_env MYSQL_DATABASE
# require_env MYSQL_USER
# require_env MYSQL_ROOT_PASSWORD_FILE
# require_env MYSQL_PASSWORD_FILE

# # Save passwords from secrets files
# MYSQL_ROOT_PASSWORD="$(tr -d '\r\n' < "$MYSQL_ROOT_PASSWORD_FILE")"
# MYSQL_PASSWORD="$(tr -d '\r\n' < "$MYSQL_PASSWORD_FILE")"

# echo $MYSQL_ROOT_PASSWORD
# echo $MYSQL_PASSWORD

# DATABASE_DIR="/var/lib/mysql"
# RUN_DIR="/run/mariadb"

# # -d: Check if directory exists
# if [ ! -d "$DATABASE_DIR/mysql" ]; then
# 	echo "Initializing MariaDB database directory..."
# 	mysql_install_db --user=mysql --ldata=$DATABASE_DIR --rpm > /dev/null

# 	# Bootstrap to set settings. Bootstrapping is initialization mode.
# 	#	1. Reload privilege tables in MariaDB
# 	#	2. Set root password
# 	#	3. Create database named $MYSQL_DATABASE
# 	#	4. Create new database user and set pw. '%' allow user to connect from any host
# 	#	5. Give new user full privileges. '@' is separator between username and host
# 	#	6. Apply all privileges
# 	echo "Bootstrap MariaDB..."
# 	mariadbd --user=mysql --bootstrap --datadir="$DATABASE_DIR" <<EOF
# USE mysql;
# FLUSH PRIVILEGES;
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF
# fi

# # Disable skip-networking to allow connection between containers
# sed -i 's|^[[:space:]]*skip-networking[[:space:]]*$|#skip-networking|' /etc/my.cnf.d/mariadb-server.cnf

# # Accept connections from any host
# sed -i 's|#bind-address=.*|bind-address=0.0.0.0|' /etc/my.cnf.d/mariadb-server.cnf

# echo "Starting MariaDB..."
# # Execute command in the container (mysqld_safe) as PID 1
# exec "$@"

#!/bin/sh
set -eu

# --- helpers ---
trim_file() { tr -d '\r\n' < "$1"; }
need() { eval "v=\${$1:-}"; [ -n "$v" ] || { echo "❌ Missing env: $1" >&2; exit 1; }; }

# --- required env ---
need MYSQL_DATABASE
need MYSQL_USER
need MYSQL_ROOT_PASSWORD_FILE
need MYSQL_PASSWORD_FILE

# --- secrets (trim newline) ---
MYSQL_ROOT_PASSWORD="$(trim_file "$MYSQL_ROOT_PASSWORD_FILE")"
echo "🔐 [DEBUG]Root password: ${MYSQL_ROOT_PASSWORD:-<empty>}"
MYSQL_PASSWORD="$(trim_file "$MYSQL_PASSWORD_FILE")"
echo "🔐 [DEBUG]User password: ${MYSQL_PASSWORD:-<empty>}"
echo "ℹ️  Database: ${MYSQL_DATABASE}"
echo "ℹ️  User: ${MYSQL_USER}"
DATADIR="/var/lib/mysql"
RUNDIR="/run/mariadbd"


# Initialize database if not already done
if [ ! -d "${DATADIR}/mysql" ]; then
  echo "🔧 Initializing MariaDB datadir..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir="$DATADIR" >/dev/null

  echo "🚀 Running bootstrap SQL…"
  mariadbd --user=mysql --bootstrap --datadir="$DATADIR" <<EOF
-- Secure root and prepare app database
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
DELETE FROM mysql.user WHERE user='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF
fi

sed -i '/^[[:space:]]*skip-networking[[:space:]]*$/d' /etc/my.cnf.d/mariadb-server.cnf
sed -i 's/^[[:space:]]*bind-address[[:space:]]*=.*/bind-address = 0.0.0.0/' /etc/my.cnf.d/mariadb-server.cnf
cat /etc/my.cnf.d/mariadb-server.cnf

echo "✅ MariaDB datadir is ready."

# Hand off to mariadbd in foreground (no hacks)
exec mariadbd-safe
#exec mariadbd --user=mysql --console --bind-address=0.0.0.0 --port=3306 --socket="$RUNDIR/mariadbd.sock"
