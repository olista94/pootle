FROM debian:8
MAINTAINER amj "amj@tdct.org"

RUN apt-get -qq update && \
 apt-get install -y python-dev python-setuptools git build-essential libxml2-dev libxslt-dev libxml2 libxslt1.1 zlib1g-dev
RUN easy_install pip && \
 pip install virtualenv
RUN mkdir -p /var/www/pootle/env && \
 adduser --disabled-password --home /var/www/pootle --gecos '' pootle && \
 chown -R pootle /var/www/pootle

USER pootle
RUN virtualenv ~/env && \
 ~/env/bin/pip install psycopg2 Pootle==2.7.6

USER root
COPY pootle-starter.sh /usr/local/bin/pootle-starter

USER pootle
EXPOSE 8000
CMD  pootle-starter
