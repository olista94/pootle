
if [ ! -f /var/www/pootle/.initialized ]; then
	systemctl start pootle-rtworker
	su - pootle
	~/env/bin/pootle migrate
 	~/env/bin/pootle initdb
 	~/env/bin/pootle createsuperuser
	touch /var/www/pootle/.initialized
fi
