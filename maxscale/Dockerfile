FROM centos
MAINTAINER Guillaume Lefranc <guillaume@mariadb.com>

RUN rpm -i https://downloads.mariadb.com/software/mariadb-maxscale/configure-maxscale-repo-0.1.2.rpm
RUN yum -y install maxscale

ENV MAXSCALE_HOME /usr/local/mariadb-maxscale
ENV PATH $PATH:/usr/local/mariadb-maxscale/bin

COPY MaxScale.cnf /usr/local/mariadb-maxscale/etc/MaxScale.cnf

EXPOSE 6603 4442 4006 4008
CMD ["maxscale","-d"] 
