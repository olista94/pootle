FROM debian:8
MAINTAINER amj "amj@tdct.org"

RUN apt-get -qq update && \
 apt-get install -y python-dev python-setuptools git build-essential libxml2-dev libxslt-dev libxml2 libxslt1.1 zlib1g-dev
RUN easy_install pip && \
 pip install virtualenv
RUN mkdir -p /var/www/pootle/{env,logs} && \
 groupadd --gid 1000 pootle && \
 adduser --disabled-password --uid 1000 --gid 1000 --home /var/www/pootle --gecos '' pootle && \
 chown -R pootle:pootle /var/www/pootle
RUN git clone https://github.com/ncopa/su-exec &&  cd su-exec && make && cp su-exec /usr/local/bin/ && cd .. && rm -r su-exec/

USER pootle
RUN virtualenv ~/env && \
 ~/env/bin/pip install psycopg2 Pootle==2.7.6

USER root
COPY pootle-starter.sh /usr/local/bin/pootle-starter

EXPOSE 8000
CMD pootle-starter

