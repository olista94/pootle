
~/env/bin/pootle rqworker

if [ ! -f /var/www/pootle/.initialized ]; then
	~/env/bin/pootle migrate
	~/env/bin/pootle initdb --no-projects
	~/env/bin/pootle createsuperuser

	touch /var/www/pootle/.initialized
fi

#~/env/bin/pootle runfcgi host=0.0.0.0 port=8000
~/env/bin/pootle start host=0.0.0.0 port=8000
