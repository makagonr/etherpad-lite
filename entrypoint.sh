#!/bin/bash
set -e

if [ ! -f APIKEY.txt ]; then
	if (( ${#API_KEY} > 20 )); then
		echo "Writing API key"
		echo "$API_KEY" > APIKEY.txt
	fi
fi

exec "$@"

