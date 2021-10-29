#!/bin/bash

if [ -z "${1}" -o "${1}" = "-h" -o "${1}" = "--help" -o "${1}" = "-help" -o "${1}" = "-?" -o "${1}" = "help" -o "${1}" = "h" ]; then
	echo "Usage: ${0} <command>"
	exit 1
fi

while true; do
	${*}
	sleep 900
done
