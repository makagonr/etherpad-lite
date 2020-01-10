#!/bin/bash
set -e

: ${DB_HOST:=mysql}
: ${DB_PORT:=3306}
: ${DB_USER:=root}
: ${DB_NAME:=etherpad}

if [ -z "$DB_PASS" ]; then
	echo >&2 'error: missing required DB_PASS environment variable'
	echo >&2 '  Did you forget to -e DB_PASS=... ?'
	echo >&2
	echo >&2 '  (Also of interest might be DB_USER and DB_NAME.)'
	exit 1
fi

# Wait for database host to start up mysql
while ! mysqlshow -h$DB_HOST -P$DB_PORT \
	-u"${DB_USER}" -p"${DB_PASS}"
do
	echo "$(date) - still trying connect to DBMS on "
	echo "$DB_HOST:$DB_PORT as user ${DB_USER}"
	sleep 1
done

# Check if database already exists
RESULT=`mysql -u${DB_USER} -p${DB_PASS} \
	-h${DB_HOST} -P${DB_PORT} --skip-column-names \
	-e "SHOW DATABASES LIKE '${DB_NAME}'"`

if [ "$RESULT" != $DB_NAME ]; then
	# mysql database does not exist, create it
	echo "Creating database ${DB_NAME}"

	mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} \
	      -P${DB_PORT} -e "CREATE DATABASE ${DB_NAME}"
fi

if [ ! -f APIKEY.txt ]; then
	if (( ${#API_KEY} > 20 )); then
		echo "Writing API key"
		echo "$API_KEY" > APIKEY.txt
	fi
fi

exec "$@"

