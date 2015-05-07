# vim:set ft=dockerfile:
FROM rhel:latest
MAINTAINER MariaDB Corporation kolbe@mariadb.com

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
COPY mariadb-enterprise.repo /etc/yum.repos.d/mariadb-enterprise.repo
RUN yum repolist all
RUN rpm --import https://downloads.mariadb.com/files/MariaDB/RPM-GPG-KEY-MariaDB-Ent

#ENV MARIADB_MAJOR 10.0
#ENV MARIADB_VERSION 10.0.17+maria-1~wheezy

RUN yum -y install MariaDB-server


VOLUME /var/lib/mysql

# COPY docker-entrypoint.sh /
# ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306
ENTRYPOINT ["mysqld"]
