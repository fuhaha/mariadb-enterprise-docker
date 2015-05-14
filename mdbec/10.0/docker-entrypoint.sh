#!/bin/bash
#
# MariaDB Enterprise Galera Cluster Docker image entry point

set -e

mysqld='/usr/bin/mysqld_safe'

if [ "${1:0:1}" = '-' ] ; then
	set -- "${mysqld}" "$@"
fi

#if [ "$1" = "${mysqld}" ]; then
#	if [ -z "${MARIADB_ROOT_PASSWORD}" ] ; then
#		echo >&2 "ERROR: MariaDB root user password not set. Did you forget to add '-e MARIADB_ROOT_PASSWORD=...'?"
#		exit 1
#	fi
#	temp_sql_file='/tmp/mysql-first-time.sql'
#	cat > "${temp_sql_file}" <<-EOSQL
#		DELETE FROM mysql.user WHERE user='root';
#		CREATE USER 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
#		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
#		FLUSH PRIVILEGES;
#	EOSQL
#	set -- "$@" --init-file="${temp_sql_file}"
#fi

exec "$@"
