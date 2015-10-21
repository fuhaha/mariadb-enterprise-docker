FROM centos:7
MAINTAINER Kolbe Kegel <kolbe@mariadb.com>

USER root
COPY mariadb.repo /etc/yum/repos.d/
COPY cnf/ /etc/my.cnf.d/

# An empty mysql subdirectory is created in datadir to keep the RPM installer from running 
# mysql_install_db, but it's removed right away so that the entrypoint script knows to run 
# mysql_install_db. Initializing the datadir ahead of time would be needless and could cause 
# the image to contain InnoDB tablespace & log files (110M), which is surely unnecessary.
#
# The MySQL-server RPM also installs a whole bunch of enormous files that are of almost no
# use in most environments, so we ditch those to save about 150M in our final image.
#
# And finally clean the yum caches to save about 100M more.

RUN mkdir -p /var/lib/mariadb-socket /var/lib/mariadb-load-data /var/lib/mysql/mysql /home/mariadb \
    && yum -y update \
    && yum -y install hostname MariaDB-server MariaDB-client \
    && rmdir /var/lib/mysql/mysql \
    && rm /usr/lib64/libmysqld.so* \
          /usr/lib64/mysql/plugin/ha_spider.so \
          /usr/lib64/mysql/plugin/ha_mroonga.so \
          /usr/lib64/mysql/plugin/ha_tokudb.so \
          /usr/lib64/mysql/plugin/ha_innodb.so \
    && yum clean all \
    && rm -rf /var/tmp/yum* \
    && usermod -d /home/mariadb mysql

COPY exe/ /usr/local/bin/

RUN chmod 555 /usr/local/bin/mariadb-server-entry /usr/local/bin/my_print_uidgid /usr/local/bin/my_wait_socket \
    && chown -R mysql:mysql /var/lib/mariadb-socket /var/lib/mariadb-load-data /var/lib/mysql /home/mariadb

USER mysql
WORKDIR /home/mariadb

VOLUME /var/lib/mysql /var/lib/mariadb-socket /var/lib/mariadb-load-data
EXPOSE 3306

# the mysql client complains that TERM is not set
ENV TERM dumb

ENTRYPOINT ["mariadb-server-entry"]
