FROM ubuntu:14.04
MAINTAINER MariaDB Corporation

RUN apt-get install -y software-properties-common \
	&& apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xce1a3dd5e3c94f49 \
	&& add-apt-repository "deb http://portaluser:testing@code.mariadb.com/mariadb-enterprise/10.0/repo/ubuntu trusty main" \
	&& apt-get update -y \
	&& apt-get install -y mariadb-server \
	&& sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
