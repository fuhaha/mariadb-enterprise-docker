#!/bin/bash
#
# MariaDB Enterprise Galera Cluster Docker image entry point

set -e

mysqld='/usr/bin/mysqld_safe'

if [ "${1:0:1}" = '-' ] ; then
	set -- "${mysqld}" "$@"
fi

if [ "$1" = "${mysqld}" ]; then
	if [ -z "${CLUSTER+x}" ]; then
		echo "CLUSTER environment variable must be set to 'BOOT', 'INIT' or comma-separated cluster node list" >&2
		exit 1
	elif [ ${CLUSTER} = "BOOT" ]; then
		NODE=1 # force this
		# grab the ip address of eth0 if NODE_ADDR is not provided 
		NODE_ADDR=${NODE_ADDR:-$(ip -4 addr show eth0 | grep inet | sed -e 's/  */ /g' | cut -d ' ' -f 3 | cut -d '/' -f 1)}
		#set -- "$@" --wsrep_node_address="${NODE_ADDR}" \
		#	--wsrep_node_incoming_address="${NODE_ADDR}" \
		#	--wsrep_new_cluster --wsrep_cluster_address="gcomm://" \
		#	--wsrep_provider_options="$WSREP_PROVIDER_OPTIONS" \
		#	--log-error=/var/lib/mysql/mysql-${NODE}.error.log
		set -- "$@" --wsrep_new_cluster --wsrep_cluster_address="gcomm://" \
			--log-error=/var/lib/mysql/mysql-${NODE}.error.log
		if [ ! -z "${MARIADB_ROOT_PASSWORD}" ] ; then
			temp_sql_file='/tmp/mysql-first-time.sql'
			cat > "${temp_sql_file}" <<-EOSQL
				DELETE FROM mysql.user WHERE user='root';
				CREATE USER 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
				GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
				FLUSH PRIVILEGES;
			EOSQL
			set -- "$@" --init-file="${temp_sql_file}"
		fi
	else
		if [ -z ${NODE+x} ]; then
			echo "NODE environment variable must be set to node number" >&2
			exit 1
		fi
		NODE_ADDR=${NODE_ADDR:-$(ip -4 addr show eth0 | grep inet | sed -e 's/  */ /g' | cut -d ' ' -f 3 | cut -d '/' -f 1)}
		set -- "$@" --wsrep_node_address="${NODE_ADDR}" \
			--wsrep_node_incoming_address="${NODE_ADDR}" \
			--wsrep_provider_options="$WSREP_PROVIDER_OPTIONS" \
			--wsrep_cluster_address="gcomm://${CLUSTER}" --log-error=/var/lib/mysql/mysql-${NODE}.error.log
	fi
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
fi

echo "$(date --rfc-3339=ns): executing '$@' command" >> /exec_cmd.log
exec "$@"
