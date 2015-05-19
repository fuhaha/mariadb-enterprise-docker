#!/bin/bash
#
# MariaDB Enterprise Galera Cluster Docker image entry point
#
# TODO: SST_AUTH environment variable support for setting SST credentials in my.cnf

set -e

mysqld='/usr/bin/mysqld_safe'

if [ "${1:0:1}" = '-' ] ; then
	set -- "${mysqld}" "$@"
fi

if [ "$1" = "${mysqld}" ]; then
	# Initializing database directory if needed
	if [ ! -e /var/lib/mysql/bootstrapped ]; then
		status "Initializing MariaDB database in '/var/lib/mysql' directory"
		mysql_install_db
		touch /var/lib/mysql/bootstrapped
	fi

	# Composing start command
	if [ -z "${CLUSTER+x}" ]; then
		NODE=1 # force this
		set -- "$@" --wsrep_new_cluster --wsrep_cluster_address="gcomm://" \
			--log-error=/var/lib/mysql/mysql-${NODE}.error.log
		if [ ! -z "${MARIADB_ROOT_PASSWORD}" ] ; then
			temp_sql_file='/tmp/mysql-set-root-password.sql'
			cat > "${temp_sql_file}" <<-EOSQL
				DELETE FROM mysql.user WHERE user='root';
				CREATE USER 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
				GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
				FLUSH PRIVILEGES;
			EOSQL
			set -- "$@" --init-file="${temp_sql_file}"
		fi
	else
		if [ -z ${NODE+x} ]; then
			echo "NODE environment variable must be set to node number" >&2
			exit 1
		fi
		set -- "$@" --wsrep_cluster_address="gcomm://${CLUSTER}" \
			--log-error=/var/lib/mysql/mysql-${NODE}.error.log
	fi
fi

exec "$@"
