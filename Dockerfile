FROM debian:8
MAINTAINER amj "amj@tdct.org"
VOLUME ["/var/pootledb"]

RUN apt-get -qq update && apt-get install -y python-dev python-setuptools git build-essential libxml2-dev libxslt-dev libxml2 libxslt1.1 zlib1g-dev
RUN easy_install pip && pip install virtualenv

RUN mkdir -p /var/www/pootle/env /var/local/pootledb && adduser --disabled-password --home /var/www/pootle --gecos '' pootle && chown -R pootle /var/www/pootle /var/local/pootledb

USER pootle
RUN virtualenv ~/env && ~/env/bin/pip install Pootle==2.7.6 && ~/env/bin/pootle init

# somes configs
RUN sed -e '/#CACHES/,/#}/ s/#\(.*\)/\1/g' -e 's@\(redis://\)127.0.0.1\(:6379\)@\1redis\2@g'  -i ~/.pootle/pootle.conf
RUN echo "LANGUAGE_CODE = 'fr' " >> ~/.pootle/pootle.conf
RUN sed -i "s@\('NAME' *: *\).*@\1'/var/local/pootledb/pootle.db',@"  ~/.pootle/pootle.conf

USER root
COPY pootle-starter.sh /usr/local/bin/pootle-starter

USER pootle
EXPOSE 8000
CMD  pootle-starter
