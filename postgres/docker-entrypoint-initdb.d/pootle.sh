#!/bin/bash
psql -U postgres -c "CREATE USER $DB_USER PASSWORD '$DB_PASS'"
#psql -U postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER"
#createuser -P $DB_USER
createdb --encoding='utf8' --locale=en_US.utf8 --template=template0 --owner=$DB_USER $DB_NAME
