#!/bin/bash
set -e

if [ -z "$DB_HOST" ]; then
	echo >&2 'error: missing required DB_HOST environment variable'
	echo >&2 '  Did you forget to -e DB_HOST=... ?'
	exit 1
fi

if [ -z "$DB_PORT" ]; then
	echo >&2 'error: missing required DB_PORT environment variable'
	echo >&2 '  Did you forget to -e DB_PORT=... ?'
	exit 1
fi

if [ -z "$DB_USER" ]; then
	echo >&2 'error: missing required DB_USER environment variable'
	echo >&2 '  Did you forget to -e DB_USER=... ?'
	exit 1
fi

if [ -z "$DB_NAME" ]; then
	echo >&2 'error: missing required DB_NAME environment variable'
	echo >&2 '  Did you forget to -e DB_NAME=... ?'
	exit 1
fi

if [ -z "$DB_PASS" ]; then
	echo >&2 'error: missing required DB_PASS environment variable'
	echo >&2 '  Did you forget to -e DB_PASS=... ?'
	exit 1
fi

# Wait for database host to start up mysql
while ! mysqlshow -h$DB_HOST -P$DB_PORT \
	-u"${DB_USER}" -p"${DB_PASS}" "${DB_NAME}"
do
	echo "$(date) - still trying connect to DBMS on "
	echo "$DB_HOST:$DB_PORT as user ${DB_USER}"
	sleep 1
done

if [ ! -f APIKEY.txt ]; then
	if (( ${#API_KEY} > 20 )); then
		echo "Writing API key"
		echo "$API_KEY" > APIKEY.txt
	fi
fi

exec "$@"

