FROM alpine:3.11
LABEL mantainer="Opennemas Developers Team <developers@opennemas.com>"

WORKDIR /tmp

RUN apk --no-cache add \
        bash \
        build-base \
        libxml2-dev \
        libxslt \
        libxslt-dev \
        nodejs \
        npm \
        python \
        python-dev \
        py-pip \
        postgresql-client \
        musl-dev \
        perl \
        perl-utils \
        perl-dbi \
        postgresql-dev \
        postgresql-plperl \
        perl-app-cpanminus \
        perl-dbd-pg \
        git \
        zlib-dev \
        perl-module-build \
        perl-json-xs \
        perl-cpanel-json-xs \
        perl-text-csv_xs \
        perl-yaml-xs \
        musl \
        libxslt \
        libxslt-dev \
        libxml2 \
        libxml2-dev \
        expat-dev \
        perl-utils \
        perl-scalar-list-utils \
        perl-xml-libxml \
        perl-xml-libxslt \
        perl-text-csv \
        perl-xml-parser \
        perl-dbi \
        perl-dbd-sqlite \
        postgresql-plperl \
        perl-dbd-pg \
        perl-app-cpanminus \
        git


################################# SERGE.IO ####################################

RUN mkdir -p /var/opt/serge

WORKDIR /var/opt/serge

RUN wget https://github.com/evernote/serge/archive/1.4.zip -O serge-1.4.zip

RUN unzip serge-1.4.zip

RUN unlink serge-1.4.zip

## Directorio instalacion de dependencias ##

WORKDIR /var/opt

RUN cpan App::cpanminus

WORKDIR /var/opt/serge/serge-1.4

RUN cpanm --force --no-wget --installdeps .

WORKDIR /home

RUN ln -s /var/opt/serge/serge-1.4/bin/serge /usr/local/bin/serge

WORKDIR /var

# RUN git clone https://github.com/olista94/serge.git

################################# SERGE.IO ####################################

RUN pip install --upgrade pip

RUN pip install https://github.com/django-compressor/django-appconf/archive/v1.0.2.zip

RUN pip install psycopg2-binary

RUN pip install pootle

RUN mkdir -p /var/www/pootle/env /var/www/pootle/logs && \
    addgroup -g 1000 -S pootle && \
    adduser -D -u 1000 -G pootle -h /var/www/pootle -g '' pootle && \
    chown -R pootle:pootle /var/www/pootle && \
    chmod 777 -R /var/www/pootle

RUN git clone https://github.com/ncopa/su-exec &&  cd su-exec && make && cp su-exec /usr/local/bin/ && cd .. && rm -r su-exec/

# USER pootle
# RUN virtualenv ~/env && \
# ~/env/bin/pip install psycopg2 Pootle==2.8.0rc5 && \
# rm -r ~/.cache


USER root
COPY pootle-starter.sh /usr/local/bin/pootle-starter

CMD pootle-starter
