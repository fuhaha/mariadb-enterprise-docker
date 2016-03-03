FROM centos
MAINTAINER Guillaume Lefranc <guillaume@mariadb.com>

ARG mdbe_token

RUN rpm -i http://downloads.mariadb.com/enterprise/${mdbe_token}/generate/10.0/mariadb-enterprise-repository.rpm 
RUN yum -y install maxscale

COPY maxscale.cnf /etc/maxscale.cnf

EXPOSE 6603 4442 4006 4008
CMD ["maxscale", "-d"] 
