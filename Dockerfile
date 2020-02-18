FROM ubuntu:18.04
MAINTAINER melvinkcx at gmail dot com

ENV PGPOOL_VERSION 4.1.0

# Fix timezone issue, see: https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
# RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt update --fix-missing
RUN apt install -y postgresql postgresql-server-dev-10 build-essential curl libmemcached-dev

WORKDIR /tmp
RUN curl -L -o pgpool-II-$PGPOOL_VERSION.tar.gz http://www.pgpool.net/download.php?f=pgpool-II-$PGPOOL_VERSION.tar.gz
RUN tar xf pgpool-II-$PGPOOL_VERSION.tar.gz

WORKDIR /tmp/pgpool-II-$PGPOOL_VERSION
RUN ./configure --with-memcached=/usr/include/libmemcached-1.0
RUN make
RUN make install

WORKDIR /tmp/pgpool-II-$PGPOOL_VERSION/src/sql
RUN make
RUN make install

RUN rm -rf /tmp/*

RUN mkdir -p /var/run/pgpool
RUN mkdir -p /var/log/pgpool
RUN chmod -R 777 /var/run/pgpool 
RUN chmod -R 777 /var/run/pgpool

EXPOSE 9999
EXPOSE 9000

WORKDIR /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod 777 ./docker-entrypoint.sh


CMD ["pgpool", "-n", "-D"]
