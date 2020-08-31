FROM alpine:3.11
LABEL mantainer="Opennemas Developers Team <developers@opennemas.com>"

WORKDIR /tmp

RUN apk --no-cache add \
        bash \
        build-base \
        expat-dev \
        git \
        libxml2 \
        libxml2-dev \
        libxslt \
        libxslt-dev \
        musl \
        musl-dev \
        nodejs \
        npm \
        perl \
        perl-app-cpanminus \
        perl-cpanel-json-xs \
        perl-dbd-pg \
        perl-dbd-sqlite \
        perl-dbi \
        perl-json-xs \
        perl-module-build \
        perl-scalar-list-utils \
        perl-text-csv \
        perl-text-csv_xs \
        perl-utils \
        perl-xml-libxml \
        perl-xml-libxslt \
        perl-xml-parser \
        perl-yaml-xs \
        postgresql-client \
        postgresql-dev \
        postgresql-plperl \
        py-pip \
        python \
        python-dev \
        zlib-dev

RUN mkdir -p /var/opt/serge

WORKDIR /var/opt/serge

RUN wget https://github.com/evernote/serge/archive/1.4.zip -O serge-1.4.zip

RUN unzip serge-1.4.zip

RUN unlink serge-1.4.zip

WORKDIR /var/opt

RUN cpan App::cpanminus

WORKDIR /var/opt/serge/serge-1.4

RUN cpanm --force --no-wget --installdeps .

RUN ln -s /var/opt/serge/serge-1.4/bin/serge /usr/local/bin/serge

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

USER root
COPY pootle-starter.sh /usr/local/bin/pootle-starter

CMD pootle-starter
