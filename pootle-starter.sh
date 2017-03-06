#!/bin/bash
sleep 10
if [ ! -f ~pootle/.pootle/pootle.conf ]; then
	chown  1000:1000 /var/www/pootle/.pootle/
	echo "run pootle init"
	su-exec pootle ~pootle/env/bin/pootle init --db postgresql --db-name $DB_NAME --db-user $DB_USER --db-host $DB_SERVICE
	echo "run sed"
	su-exec pootle sed -e "s@\('PASSWORD' *: *\).*@\1'$DB_PASS',@" -e '/#CACHES/,/#}/ s/#\(.*\)/\1/g' -e 's@\(redis://\)127.0.0.1\(:6379\)@\1redis\2@g'  -i ~pootle/.pootle/pootle.conf
fi

echo "start rqworker"
su-exec pootle ~pootle/env/bin/pootle rqworker &

if [ ! -f ~pootle/.pootle/.initialized ]; then
	echo "run migrate"
	su-exec pootle ~pootle/env/bin/pootle migrate
	su-exec pootle ~pootle/env/bin/pootle initdb --no-projects
	su-exec pootle ~pootle/env/bin/pootle createsuperuser

	su-exec pootle touch ~pootle/.pootle/.initialized
fi

echo "start pootle"
su-exec pootle ~pootle/env/bin/pootle run_cherrypy --host 0.0.0.0 --port 8000
