chown  1000:1000 /var/www/pootle/.pootle/
ls -ld /var/www/pootle/.pootle/
ls -ld /var/www/pootle/

if [ ! -f /var/www/pootle/.pootle/pootle.conf ]; then
	echo "run pootle init"
	su-exec pootle ~pootle/env/bin/pootle init --db postgresql --db-name $DB_NAME --db-user $DB_USER --db-host $DB_SERVICE
	echo "run sed"
	su-exec pootle sed -e '/#CACHES/,/#}/ s/#\(.*\)/\1/g' -e 's@\(redis://\)127.0.0.1\(:6379\)@\1redis\2@g'  -i ~pootle/.pootle/pootle.conf
	su-exec pootle echo "LANGUAGE_CODE = 'fr' " >> ~pootle/.pootle/pootle.conf
	cat ~pootle/.pootle/pootle.conf
fi

su-exec pootle ~pootle/env/bin/pootle rqworker

if [ ! -f /var/www/pootle/.pootle/.initialized ]; then
	echo "run migrate"
	su-exec pootle ~pootle/env/bin/pootle migrate
	su-exec pootle ~pootle/env/bin/pootle initdb --no-projects
	su-exec pootle ~pootle/env/bin/pootle createsuperuser

	su-exec pootle touch /var/www/pootle/.pootle/.initialized
fi

#~pootle/env/bin/pootle runfcgi host=0.0.0.0 port=8000
su-exec pootle ~pootle/env/bin/pootle start host=0.0.0.0 port=8000
