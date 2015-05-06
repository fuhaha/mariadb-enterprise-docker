# What is MariaDB

MariaDB is a community-developed fork of the MySQL relational database management system intended to remain free under the GNU GPL.
Being a fork of a leading open source software system, it is notable for being led by the original developers of MySQL, who forked
it due to concerns over its acquisition by Oracle. Contributors are required to share their copyright with the MariaDB Foundation.

> [wikipedia.org/wiki/MariaDB](http://en.wikipedia.org/wiki/MariaDB)

![logo](http://badges.mariadb.org/logo/Mariadb-seal-shaded-browntext-alt.png)

# How to use this image

Go to &lt;version&gt; subdirectory in accordance to version you want to build a Docker image for, e.g. for MariaDB 10.0:

```
$ cd 10.0/
```

Build Docker image:

```
$ sudo docker build -t mdbe/mariadb .
```

Run Docker image in new container and set MariaDB root user password:

```
$ sudo docker run -d --name=my_mariadb_container -e MARIADB_ROOT_PASSWORD=mysecretpassword mdbe/mariadb
```

To be able to connect to MariaDB server from host OS TCP-port mapping should be used, e.g.:

```
$ sudo docker run -d --name=my_mariadb_container -p 3306:3306 -e MARIADB_ROOT_PASSWORD=mysecretpassword mdbe/mariadb
```

You can use any name for the container instead of &quot;my\_mariadb\_container&quot; or even not to assing one at all -
Docker will automatically assign new name to it. Check the docker image is running:

```
$ sudo docker ps -a | grep my_mariadb_container
f29de89deae1        mdbe/mariadb:latest   "/docker-entrypoint.   15 seconds ago      Up 15 seconds                                   my_mariadb_container
```

Stop container:

```
$ sudo docker stop my_mariadb_container
my_mariadb_container
```

Remove container:

```
$ sudo docker rm my_mariadb_container
my_mariadb_container
```

## Environment variables

Following environment variables could be used when running MariaDB Enterprise Docker image in new container.

### `MARIADB_ROOT_PASSWORD`

Required environment variable, which is used to set MariaDB root user password.
