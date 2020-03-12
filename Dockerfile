FROM ubuntu:16.04
MAINTAINER melvinkcx at gmail dot com
WORKDIR /app
ENV PGPOOL_VERSION 3.7.13
ENV PG_VERSION 9.6.17

# Fix timezone issue, see: https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN apt update --fix-missing
RUN apt install -y postgresql postgresql-server-dev-10 build-essential curl libmemcached-dev libpgpool0

RUN curl -L -o pgpool-II-$PGPOOL_VERSION.tar.gz http://www.pgpool.net/download.php?f=pgpool-II-$PGPOOL_VERSION.tar.gz
RUN tar xf pgpool-II-$PGPOOL_VERSION.tar.gz

RUN cd pgpool-II-$PGPOOL_VERSION && ./configure --with-memcached=/usr/include/libmemcached-1.0 && \
    make && \
    make install

RUN cd pgpool-II-$PGPOOL_VERSION/src/sql && \
    make && \
    make install && \
    rm -rf pgpool-II-$PGPOOL_VERSION*

RUN mkdir -p /var/run/pgpool && \
    mkdir -p /var/log/pgpool && \
    chmod -R 777 /var/run/pgpool && \
    chmod -R 777 /var/run/pgpool

EXPOSE 9999
EXPOSE 9000

CMD ["/usr/local/bin/pgpool", "-n", "-D"]
