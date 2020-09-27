#!/bin/bash
if [ ! -z ${IS_INSTALLED} ]
then
    rm -rf /var/www/html/setup
fi

if [ ! -z ${APACHE_SERVERNAME} ]
then
    sed -i "s/#ServerName www.example.com/ServerName ${APACHE_SERVERNAME}/" /etc/apache2/sites-available/000-default.conf
fi

if [ -d /docker-entrypoint-init.d ]
then
	if [ ! -z $(ls /docker-entrypoint-init.d/) ]
	then
		for f in /docker-entrypoint-init.d/*; do
  		echo "     - Running $f"
  		bash "$f" -H 
		done
	fi
fi
cd /var/www/html
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"