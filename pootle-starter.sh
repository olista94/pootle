ls -ld /var/www/pootle/.pootle/
ls -ld /var/www/pootle/

if [ ! -f /var/www/pootle/.pootle/pootle.conf ]; then
	echo "run pootle init"
	~/env/bin/pootle init --db postgresql --db-name $DB_NAME --db-user $DB_USER --db-host $DB_SERVICE
	echo "run sed"
	sed -e '/#CACHES/,/#}/ s/#\(.*\)/\1/g' -e 's@\(redis://\)127.0.0.1\(:6379\)@\1redis\2@g'  -i ~/.pootle/pootle.conf
	echo "LANGUAGE_CODE = 'fr' " >> ~/.pootle/pootle.conf
fi

~/env/bin/pootle rqworker

if [ ! -f /var/www/pootle/.pootle/.initialized ]; then
	echo "run migrate"
	~/env/bin/pootle migrate
	~/env/bin/pootle initdb --no-projects
	~/env/bin/pootle createsuperuser

	touch /var/www/pootle/.pootle/.initialized
fi

#~/env/bin/pootle runfcgi host=0.0.0.0 port=8000
~/env/bin/pootle start host=0.0.0.0 port=8000
