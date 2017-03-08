#!/bin/bash

until psql -h "$DB_SERVICE" -U "postgres" -c '\l'; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is up - executing command"



if [ ! -f ~pootle/.pootle/pootle.conf ]; then
	chown  1000:1000 /var/www/pootle/.pootle/
	echo "run pootle init"
	su-exec pootle ~pootle/env/bin/pootle init --db postgresql --db-name $DB_NAME --db-user $DB_USER --db-host $DB_SERVICE
	echo "run sed"
	su-exec pootle sed -e "s@\('PASSWORD' *: *\).*@\1'$DB_PASS',@" \
                           -e '/#CACHES/,/#}/ s/#\(.*\)/\1/g' \
                           -e 's@\(redis://\)127.0.0.1\(:6379\)@\1redis\2@g' -i ~pootle/.pootle/pootle.conf

	su-exec pootle sed -e "s|#\(EMAIL_HOST_USER = \).*|\1 $EMAIL_HOST_USER|" \
                           -e "s@#\(EMAIL_HOST_PASSWORD = \).*@\1 $EMAIL_HOST_PASSWORD@" \
                           -e "s@#\(EMAIL_HOST = \).*@\1 $EMAIL_HOST@" \
                           -e "s@#\(EMAIL_PORT = \).*@\1 $EMAIL_PORT@" \
                           -e "s@#\(EMAIL_USE_TLS = \).*@\1 $EMAIL_USE_TLS@" \
                           -e "s|\(DEFAULT_FROM_EMAIL = \).*|\1 $DEFAULT_FROM_EMAIL|" -i ~pootle/.pootle/pootle.conf
fi

echo "start rqworker"
su-exec pootle ~pootle/env/bin/pootle rqworker &

sleep 2

if [ ! -f ~pootle/.pootle/.initialized ]; then
	echo "run migrate"
	su-exec pootle ~pootle/env/bin/pootle migrate
	su-exec pootle ~pootle/env/bin/pootle initdb --no-projects
	# replace pootle createsuperuser
	su-exec pootle echo "from django.contrib import auth; auth.get_user_model()._default_manager.db_manager(\"default\").create_superuser(\"$POOTLE_ADMIN_NAME\", \"$POOTLE_ADMIN_EMAIL\", \"$POOTLE_ADMIN_PASSWORD\")" | ~pootle/env/bin/pootle shell
	su-exec pootle ~pootle/env/bin/pootle verify_user "$POOTLE_ADMIN_NAME"

	su-exec pootle touch ~pootle/.pootle/.initialized
fi

echo "start pootle"
su-exec pootle ~pootle/env/bin/pootle runserver --insecure 0.0.0.0:8000
